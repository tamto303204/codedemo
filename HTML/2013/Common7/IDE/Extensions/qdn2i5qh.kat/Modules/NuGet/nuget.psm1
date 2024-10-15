# make sure we stop on exceptions
$ErrorActionPreference = "Stop"

# This object reprents the result value for tab expansion functions when no result is returned.
# This is so that we can distinguish it from $null, which has different semantics
$NoResultValue = New-Object PSObject -Property @{ NoResult = $true }

# Hashtable that stores tab expansion definitions
$TabExpansionCommands = New-Object 'System.Collections.Hashtable' -ArgumentList @([System.StringComparer]::InvariantCultureIgnoreCase)

function Register-TabExpansion {
<#
.SYNOPSIS
    Registers a tab expansion for the parameters of the specified command.
.DESCRIPTION
    Registers a tab expansion for the parameters of the specified command.
.PARAMETER Name
    Name of the command the expansion is for.
.EXAMPLE
    PS> Register-TabExpansion 'Set-Color', @{'color' = {'blue', 'green', 'red'}}
         This adds a tab expansion to the Set-Color command. Set-Color contains a single 
         parameter, color, with three possible expansion values.
#>
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [string]$Name,
        [parameter(Mandatory = $true)]
        $Definition
    )

    # transfer $definition data into a new hashtable that compare values using InvariantCultureIgnoreCase
    $normalizedDefinition = New-Object 'System.Collections.Hashtable' -ArgumentList @([System.StringComparer]::InvariantCultureIgnoreCase)
    $definition.GetEnumerator() | % { $normalizedDefinition[$_.Name] = $_.Value }
        
    $TabExpansionCommands[$Name] = $normalizedDefinition
}

Register-TabExpansion 'Get-Package' @{
    'Source' = {
        GetPackageSources
    }
    'ProjectName' = {
        GetProjectNames
    }
}

Register-TabExpansion 'Install-Package' @{
    'Id' = {
        param($context)
        GetRemotePackageIds $context
    }
    'ProjectName' = {
        GetProjectNames
    }
    'Version' = {
        param($context)
        GetRemotePackageVersions $context
    }
    'Source' = {
        GetPackageSources
    }
}

Register-TabExpansion 'Uninstall-Package' @{
    'Id' = {
        param($context)
        GetInstalledPackageIds $context
    }
    'ProjectName' = {
        GetProjectNames
    }
    'Version' = {
        GetInstalledPackageVersions $context
    }
}

Register-TabExpansion 'Update-Package' @{
    'Id' = {
        param($context)
        GetInstalledPackageIds $context
    }
    'ProjectName' = {
        GetProjectNames
    }
    'Version' = {
        param($context)

        # Only show available versions if an id was specified
        if ($context.id) { 
            # Find the installed package (this might be nothing since we could have a partial id)
            $versions = @()
            $packages = @(Get-Package $context.id | ? { $_.Id -eq $context.id })

            if($packages.Count) {
                $package = @($packages | Sort-Object Version)[0]

                $versions = GetRemotePackageVersions $context

                # Only show versions that are higher than the lowest installed version
                $versions = $versions | ?{ $_ -gt $package.Version }
            }

            $versions
        }
    }
    'Source' = {
        GetPackageSources
    }
}

Register-TabExpansion 'Open-PackagePage' @{
    'Id' = {
        param($context)
        GetRemotePackageIds $context
    }
    'Version' = {
        param($context)
        GetRemotePackageVersions $context
    }
    'Source' = {
        GetPackageSources
    }
}

Register-TabExpansion 'Add-BindingRedirect' @{ 'ProjectName' = { GetProjectNames } }
Register-TabExpansion 'Get-Project' @{ 'Name' = { GetProjectNames } }

function HasProperty($context, $name) {
    return $context.psobject.properties | ? { $_.Name -eq $name }
}

function IsPrereleaseSet($context) {
	# Need to figure out a better way to do this. 
	return (HasProperty $context 'IncludePreRelease') -or (HasProperty $context 'PreRelease') -or (HasProperty $context 'Pre')
}

function GetPackages($context) {
    $parameters = @{}

    if ($context.Id) { $parameters.filter = $context.Id }
    if ($context.Source) { $parameters.source = $context.Source }
    if (IsPrereleaseSet $context) {
        $parameters.IncludePreRelease = $true 
    }

    return Find-Package @parameters -Remote -ErrorAction SilentlyContinue
}

function GetProjectNames {
    $uniqueNames = @(Get-Project -All | Select-Object -ExpandProperty ProjectName)
    
    $simpleNames = Get-Project -All | Select-Object -ExpandProperty Name
    $safeNames = @($simpleNames | Group-Object | Where-Object { $_.Count -eq 1 } | Select-Object -ExpandProperty Name)

    ($uniqueNames + $safeNames) | Select-Object -Unique | Sort-Object
}

function GetInstalledPackageIds($context) {
    $parameters = @{}
    
    if ($context.Id) { $parameters.filter = $context.id }

    Find-Package @parameters -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Id -Unique
}

function GetRemotePackageIds($context) {
    $parameters = @{}

    if ($context.Id) { $parameters.filter = $context.Id }
    if ($context.Source) { $parameters.source = $context.Source }
    if (IsPrereleaseSet $context) {
        $parameters.includePrerelease = $true 
    }

    try {
		return Get-RemotePackageId @parameters
    }
    catch {
        # If the server doesn't have the JSON API endpoints, get the remote package IDs the old way.
        return GetPackages $context | Select-Object -ExpandProperty Id -Unique
    }
}

function GetPackageSources() {
    $allSources = [NuGet.VisualStudio.AggregatePackageSource]::GetEnabledPackageSourcesWithAggregate()
    $allSources | Select-Object -ExpandProperty Name
}

function GetInstalledPackageVersions($context) {
    $parameters = @{}
    if ($context.id) { $parameters.filter = $context.id }
    GetAndSortVersions (Find-Package @parameters -ExactMatch -ErrorAction SilentlyContinue)
}

function GetRemotePackageVersions($context) {
    $parameters = @{}

    if ($context.Id -eq $null) {
        return @()
    }

    if ($context.Id) { $parameters.id = $context.Id }
    if ($context.Source) { $parameters.source = $context.Source }
    if (IsPrereleaseSet $context) {
        $parameters.IncludePreRelease = $true 
    }

    try {
	    return Get-RemotePackageVersion @parameters | %{ [NuGet.SemanticVersion]::Parse($_) } | Sort-Object -Descending
    }
    catch {
	    # If the server doesn't have the JSON API endpoints, get the remote package versions the old way.
        $parameters = @{}
        if ($context.Id) { $parameters.filter = $context.Id }
        if ($context.Source) { $parameters.source = $context.Source }
        if (IsPrereleaseSet $context) {
            $parameters.IncludePreRelease = $true 
        }
        $parameters.Remote = $true
        $parameters.AllVersions = $true
        GetAndSortVersions(Find-Package @parameters -ExactMatch -ErrorAction SilentlyContinue)
    }
}

function GetAndSortVersions($packages) {
    $packages | Select -Unique -ExpandProperty Version | %{
        if($_ -is [string]) { 
            [NuGet.SemanticVersion]::Parse($_) 
        } else { 
            $_ 
        }  
    } | Sort-Object -Descending
}

function NugetTabExpansion($line, $lastWord) {
    # Parse the command
    $parsedCommand = [NuGetConsole.Host.PowerShell.CommandParser]::Parse($line)

    # Get the command definition
    $definition = $TabExpansionCommands[$parsedCommand.CommandName]

    # See if we've registered a command for intellisense
    if($definition) {
        # Get the command that we're trying to show intellisense for
        $command = Get-Command $parsedCommand.CommandName -ErrorAction SilentlyContinue

        if($command) {            
            # We're trying to find out what parameter we're trying to show intellisense for based on 
            # either the name of the an argument or index e.g. "Install-Package -Id " "Install-Package "
            
            $argument = $parsedCommand.CompletionArgument
            $index = $parsedCommand.CompletionIndex

            if(!$argument -and $index -ne $null) {                
                do {
                    # Get the argument name for this index
                    $argument = GetArgumentName $command $index

                    if(!$argument) {
                        break
                    }
                    
                    # If there is already a value for this argument, then check the next one index.
                    # This is so we don't show duplicate intellisense e.g. "Install-Package -Id elmah {tab}".
                    # The above statement shouldn't show intellisense for id since it already has a value
                    if($parsedCommand.Arguments[$argument] -eq $null) {
                        $value = $parsedCommand.Arguments[$index]

                        if(!$value) {
                            $value = ''
                        }
                        $parsedCommand.Arguments[$argument] = $value
                        break
                    }
                    else {
                        $index++
                    }

                } while($true);    
            }

            if($argument) {
                # Populate the arguments dictionary with the name and value of the 
                # associated index. i.e. for the command "Install-Package elmah" arguments should have
                # an entries with { 0, "elmah" } and { "Id", "elmah" }
                $arguments = New-Object 'System.Collections.Hashtable' -ArgumentList @([System.StringComparer]::InvariantCultureIgnoreCase)

                $parsedCommand.Arguments.Keys | Where-Object { $_ -is [int] } | %{
                    $argName = GetArgumentName $command $_
                    $arguments[$argName] = $parsedCommand.Arguments[$_]
                }

                # Copy the arguments over to the parsed command arguments
                $arguments.Keys | %{ 
                    $parsedCommand.Arguments[$_] = $arguments[$_]
                }

                # If the argument is a true argument of this command and not a partial argument
                # and there is a non null value (empty is valid), then we execute the script block
                # for this parameter (if specified)
                $action = $definition[$argument]
                $argumentValue = $parsedCommand.Arguments[$argument]

                if($command.Parameters[$argument] -and 
                   $argumentValue -ne $null -and
                   $action) {
                    $context = New-Object PSObject -Property $parsedCommand.Arguments
                    
                    $results = @(& $action $context)

                    if($results.Count -eq 0) {
                        return $null
                    }

                    # Use the argument value to filter results
                    $results = $results | %{ $_.ToString() } | Where-Object { $_.StartsWith($argumentValue, "OrdinalIgnoreCase") }

                    return NormalizeResults $results
                }
            }
        }
    } 

    return $NoResultValue
}

function NormalizeResults($results) {
    $results | %{
        $result = $_

        # Add quotes to a result if it contains whitespace or a quote
        $addQuotes = $result.Contains(" ") -or $result.Contains("'") -or $result.Contains("`t")
        
        if($addQuotes) {
            $result = "'" + $result.Replace("'", "''") + "'"
        }

        return $result
    }
}

function GetArgumentName($command, $index) {    
    # Next we try to find the parameter name for the parameter index (in the default parameter set)
    $parameterSet = $Command.DefaultParameterSet

    if(!$parameterSet) {
        $parameterSet = '__AllParameterSets'
    }

    return $command.Parameters.Values | ?{ $_.ParameterSets[$parameterSet].Position -eq $index } | Select -ExpandProperty Name
}

function Format-ProjectName {
    param(
        [parameter(position=0, mandatory=$true)]
        [validatenotnull()]
        $Project,
        [parameter(position=1, mandatory=$true)]
        [validaterange(6, 1000)]
        [int]$ColWidth
    )

    # only perform special formatting for web site projects
    if ($project.kind -ne "{E24C65DC-7377-472B-9ABA-BC803B73C61A}") {
        return $project.name
    }

    [NuGet.VisualStudio.PathHelper]::SmartTruncate($project.name, $ColWidth)
}
# SIG # Begin signature block
# MIIavQYJKoZIhvcNAQcCoIIarjCCGqoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQURQe3byEaHrIqOOVSWo+OhVKq
# isSgghWCMIIEwzCCA6ugAwIBAgITMwAAACs5MkjBsslI8wAAAAAAKzANBgkqhkiG
# 9w0BAQUFADB3MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4G
# A1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSEw
# HwYDVQQDExhNaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EwHhcNMTIwOTA0MjExMjM0
# WhcNMTMxMjA0MjExMjM0WjCBszELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hp
# bmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jw
# b3JhdGlvbjENMAsGA1UECxMETU9QUjEnMCUGA1UECxMebkNpcGhlciBEU0UgRVNO
# OkMwRjQtMzA4Ni1ERUY4MSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBT
# ZXJ2aWNlMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAprYwDgNlrlBa
# hmuFn0ihHsnA7l5JB4XgcJZ8vrlfYl8GJtOLObsYIqUukq3YS4g6Gq+bg67IXjmM
# wjJ7FnjtNzg68WL7aIICaOzru0CKsf6hLDZiYHA5YGIO+8YYOG+wktZADYCmDXiL
# NmuGiiYXGP+w6026uykT5lxIjnBGNib+NDWrNOH32thc6pl9MbdNH1frfNaVDWYM
# Hg4yFz4s1YChzuv3mJEC3MFf/TiA+Dl/XWTKN1w7UVtdhV/OHhz7NL5f5ShVcFSc
# uOx8AFVGWyiYKFZM4fG6CRmWgUgqMMj3MyBs52nDs9TDTs8wHjfUmFLUqSNFsq5c
# QUlPtGJokwIDAQABo4IBCTCCAQUwHQYDVR0OBBYEFKUYM1M/lWChQxbvjsav0iu6
# nljQMB8GA1UdIwQYMBaAFCM0+NlSRnAK7UD7dvuzK7DDNbMPMFQGA1UdHwRNMEsw
# SaBHoEWGQ2h0dHA6Ly9jcmwubWljcm9zb2Z0LmNvbS9wa2kvY3JsL3Byb2R1Y3Rz
# L01pY3Jvc29mdFRpbWVTdGFtcFBDQS5jcmwwWAYIKwYBBQUHAQEETDBKMEgGCCsG
# AQUFBzAChjxodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpL2NlcnRzL01pY3Jv
# c29mdFRpbWVTdGFtcFBDQS5jcnQwEwYDVR0lBAwwCgYIKwYBBQUHAwgwDQYJKoZI
# hvcNAQEFBQADggEBAH7MsHvlL77nVrXPc9uqUtEWOca0zfrX/h5ltedI85tGiAVm
# aiaGXv6HWNzGY444gPQIRnwrc7EOv0Gqy8eqlKQ38GQ54cXV+c4HzqvkJfBprtRG
# 4v5mMjzXl8UyIfruGiWgXgxCLBEzOoKD/e0ds77OkaSRJXG5q3Kwnq/kzwBiiXCp
# uEpQjO4vImSlqOZNa5UsHHnsp6Mx2pBgkKRu/pMCDT8sJA3GaiaBUYNKELt1Y0Sq
# aQjGA+vizwvtVjrs73KnCgz0ANMiuK8icrPnxJwLKKCAyuPh1zlmMOdGFxjn+oL6
# WQt6vKgN/hz/A4tjsk0SAiNPLbOFhDvioUfozxUwggTsMIID1KADAgECAhMzAAAA
# sBGvCovQO5/dAAEAAACwMA0GCSqGSIb3DQEBBQUAMHkxCzAJBgNVBAYTAlVTMRMw
# EQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVN
# aWNyb3NvZnQgQ29ycG9yYXRpb24xIzAhBgNVBAMTGk1pY3Jvc29mdCBDb2RlIFNp
# Z25pbmcgUENBMB4XDTEzMDEyNDIyMzMzOVoXDTE0MDQyNDIyMzMzOVowgYMxCzAJ
# BgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25k
# MR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xDTALBgNVBAsTBE1PUFIx
# HjAcBgNVBAMTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjCCASIwDQYJKoZIhvcNAQEB
# BQADggEPADCCAQoCggEBAOivXKIgDfgofLwFe3+t7ut2rChTPzrbQH2zjjPmVz+l
# URU0VKXPtIupP6g34S1Q7TUWTu9NetsTdoiwLPBZXKnr4dcpdeQbhSeb8/gtnkE2
# KwtA+747urlcdZMWUkvKM8U3sPPrfqj1QRVcCGUdITfwLLoiCxCxEJ13IoWEfE+5
# G5Cw9aP+i/QMmk6g9ckKIeKq4wE2R/0vgmqBA/WpNdyUV537S9QOgts4jxL+49Z6
# dIhk4WLEJS4qrp0YHw4etsKvJLQOULzeHJNcSaZ5tbbbzvlweygBhLgqKc+/qQUF
# 4eAPcU39rVwjgynrx8VKyOgnhNN+xkMLlQAFsU9lccUCAwEAAaOCAWAwggFcMBMG
# A1UdJQQMMAoGCCsGAQUFBwMDMB0GA1UdDgQWBBRZcaZaM03amAeA/4Qevof5cjJB
# 8jBRBgNVHREESjBIpEYwRDENMAsGA1UECxMETU9QUjEzMDEGA1UEBRMqMzE1OTUr
# NGZhZjBiNzEtYWQzNy00YWEzLWE2NzEtNzZiYzA1MjM0NGFkMB8GA1UdIwQYMBaA
# FMsR6MrStBZYAck3LjMWFrlMmgofMFYGA1UdHwRPME0wS6BJoEeGRWh0dHA6Ly9j
# cmwubWljcm9zb2Z0LmNvbS9wa2kvY3JsL3Byb2R1Y3RzL01pY0NvZFNpZ1BDQV8w
# OC0zMS0yMDEwLmNybDBaBggrBgEFBQcBAQROMEwwSgYIKwYBBQUHMAKGPmh0dHA6
# Ly93d3cubWljcm9zb2Z0LmNvbS9wa2kvY2VydHMvTWljQ29kU2lnUENBXzA4LTMx
# LTIwMTAuY3J0MA0GCSqGSIb3DQEBBQUAA4IBAQAx124qElczgdWdxuv5OtRETQie
# 7l7falu3ec8CnLx2aJ6QoZwLw3+ijPFNupU5+w3g4Zv0XSQPG42IFTp8263Os8ls
# ujksRX0kEVQmMA0N/0fqAwfl5GZdLHudHakQ+hywdPJPaWueqSSE2u2WoN9zpO9q
# GqxLYp7xfMAUf0jNTbJE+fA8k21C2Oh85hegm2hoCSj5ApfvEQO6Z1Ktwemzc6bS
# Y81K4j7k8079/6HguwITO10g3lU/o66QQDE4dSheBKlGbeb1enlAvR/N6EXVruJd
# PvV1x+ZmY2DM1ZqEh40kMPfvNNBjHbFCZ0oOS786Du+2lTqnOOQlkgimiGaCMIIF
# vDCCA6SgAwIBAgIKYTMmGgAAAAAAMTANBgkqhkiG9w0BAQUFADBfMRMwEQYKCZIm
# iZPyLGQBGRYDY29tMRkwFwYKCZImiZPyLGQBGRYJbWljcm9zb2Z0MS0wKwYDVQQD
# EyRNaWNyb3NvZnQgUm9vdCBDZXJ0aWZpY2F0ZSBBdXRob3JpdHkwHhcNMTAwODMx
# MjIxOTMyWhcNMjAwODMxMjIyOTMyWjB5MQswCQYDVQQGEwJVUzETMBEGA1UECBMK
# V2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0
# IENvcnBvcmF0aW9uMSMwIQYDVQQDExpNaWNyb3NvZnQgQ29kZSBTaWduaW5nIFBD
# QTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALJyWVwZMGS/HZpgICBC
# mXZTbD4b1m/My/Hqa/6XFhDg3zp0gxq3L6Ay7P/ewkJOI9VyANs1VwqJyq4gSfTw
# aKxNS42lvXlLcZtHB9r9Jd+ddYjPqnNEf9eB2/O98jakyVxF3K+tPeAoaJcap6Vy
# c1bxF5Tk/TWUcqDWdl8ed0WDhTgW0HNbBbpnUo2lsmkv2hkL/pJ0KeJ2L1TdFDBZ
# +NKNYv3LyV9GMVC5JxPkQDDPcikQKCLHN049oDI9kM2hOAaFXE5WgigqBTK3S9dP
# Y+fSLWLxRT3nrAgA9kahntFbjCZT6HqqSvJGzzc8OJ60d1ylF56NyxGPVjzBrAlf
# A9MCAwEAAaOCAV4wggFaMA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFMsR6MrS
# tBZYAck3LjMWFrlMmgofMAsGA1UdDwQEAwIBhjASBgkrBgEEAYI3FQEEBQIDAQAB
# MCMGCSsGAQQBgjcVAgQWBBT90TFO0yaKleGYYDuoMW+mPLzYLTAZBgkrBgEEAYI3
# FAIEDB4KAFMAdQBiAEMAQTAfBgNVHSMEGDAWgBQOrIJgQFYnl+UlE/wq4QpTlVnk
# pDBQBgNVHR8ESTBHMEWgQ6BBhj9odHRwOi8vY3JsLm1pY3Jvc29mdC5jb20vcGtp
# L2NybC9wcm9kdWN0cy9taWNyb3NvZnRyb290Y2VydC5jcmwwVAYIKwYBBQUHAQEE
# SDBGMEQGCCsGAQUFBzAChjhodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpL2Nl
# cnRzL01pY3Jvc29mdFJvb3RDZXJ0LmNydDANBgkqhkiG9w0BAQUFAAOCAgEAWTk+
# fyZGr+tvQLEytWrrDi9uqEn361917Uw7LddDrQv+y+ktMaMjzHxQmIAhXaw9L0y6
# oqhWnONwu7i0+Hm1SXL3PupBf8rhDBdpy6WcIC36C1DEVs0t40rSvHDnqA2iA6VW
# 4LiKS1fylUKc8fPv7uOGHzQ8uFaa8FMjhSqkghyT4pQHHfLiTviMocroE6WRTsgb
# 0o9ylSpxbZsa+BzwU9ZnzCL/XB3Nooy9J7J5Y1ZEolHN+emjWFbdmwJFRC9f9Nqu
# 1IIybvyklRPk62nnqaIsvsgrEA5ljpnb9aL6EiYJZTiU8XofSrvR4Vbo0HiWGFzJ
# NRZf3ZMdSY4tvq00RBzuEBUaAF3dNVshzpjHCe6FDoxPbQ4TTj18KUicctHzbMrB
# 7HCjV5JXfZSNoBtIA1r3z6NnCnSlNu0tLxfI5nI3EvRvsTxngvlSso0zFmUeDord
# EN5k9G/ORtTTF+l5xAS00/ss3x+KnqwK+xMnQK3k+eGpf0a7B2BHZWBATrBC7E7t
# s3Z52Ao0CW0cgDEf4g5U3eWh++VHEK1kmP9QFi58vwUheuKVQSdpw5OPlcmN2Jsh
# rg1cnPCiroZogwxqLbt2awAdlq3yFnv2FoMkuYjPaqhHMS+a3ONxPdcAfmJH0c6I
# ybgY+g5yjcGjPa8CQGr/aZuW4hCoELQ3UAjWwz0wggYHMIID76ADAgECAgphFmg0
# AAAAAAAcMA0GCSqGSIb3DQEBBQUAMF8xEzARBgoJkiaJk/IsZAEZFgNjb20xGTAX
# BgoJkiaJk/IsZAEZFgltaWNyb3NvZnQxLTArBgNVBAMTJE1pY3Jvc29mdCBSb290
# IENlcnRpZmljYXRlIEF1dGhvcml0eTAeFw0wNzA0MDMxMjUzMDlaFw0yMTA0MDMx
# MzAzMDlaMHcxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYD
# VQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xITAf
# BgNVBAMTGE1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQTCCASIwDQYJKoZIhvcNAQEB
# BQADggEPADCCAQoCggEBAJ+hbLHf20iSKnxrLhnhveLjxZlRI1Ctzt0YTiQP7tGn
# 0UytdDAgEesH1VSVFUmUG0KSrphcMCbaAGvoe73siQcP9w4EmPCJzB/LMySHnfL0
# Zxws/HvniB3q506jocEjU8qN+kXPCdBer9CwQgSi+aZsk2fXKNxGU7CG0OUoRi4n
# rIZPVVIM5AMs+2qQkDBuh/NZMJ36ftaXs+ghl3740hPzCLdTbVK0RZCfSABKR2YR
# JylmqJfk0waBSqL5hKcRRxQJgp+E7VV4/gGaHVAIhQAQMEbtt94jRrvELVSfrx54
# QTF3zJvfO4OToWECtR0Nsfz3m7IBziJLVP/5BcPCIAsCAwEAAaOCAaswggGnMA8G
# A1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFCM0+NlSRnAK7UD7dvuzK7DDNbMPMAsG
# A1UdDwQEAwIBhjAQBgkrBgEEAYI3FQEEAwIBADCBmAYDVR0jBIGQMIGNgBQOrIJg
# QFYnl+UlE/wq4QpTlVnkpKFjpGEwXzETMBEGCgmSJomT8ixkARkWA2NvbTEZMBcG
# CgmSJomT8ixkARkWCW1pY3Jvc29mdDEtMCsGA1UEAxMkTWljcm9zb2Z0IFJvb3Qg
# Q2VydGlmaWNhdGUgQXV0aG9yaXR5ghB5rRahSqClrUxzWPQHEy5lMFAGA1UdHwRJ
# MEcwRaBDoEGGP2h0dHA6Ly9jcmwubWljcm9zb2Z0LmNvbS9wa2kvY3JsL3Byb2R1
# Y3RzL21pY3Jvc29mdHJvb3RjZXJ0LmNybDBUBggrBgEFBQcBAQRIMEYwRAYIKwYB
# BQUHMAKGOGh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2kvY2VydHMvTWljcm9z
# b2Z0Um9vdENlcnQuY3J0MBMGA1UdJQQMMAoGCCsGAQUFBwMIMA0GCSqGSIb3DQEB
# BQUAA4ICAQAQl4rDXANENt3ptK132855UU0BsS50cVttDBOrzr57j7gu1BKijG1i
# uFcCy04gE1CZ3XpA4le7r1iaHOEdAYasu3jyi9DsOwHu4r6PCgXIjUji8FMV3U+r
# kuTnjWrVgMHmlPIGL4UD6ZEqJCJw+/b85HiZLg33B+JwvBhOnY5rCnKVuKE5nGct
# xVEO6mJcPxaYiyA/4gcaMvnMMUp2MT0rcgvI6nA9/4UKE9/CCmGO8Ne4F+tOi3/F
# NSteo7/rvH0LQnvUU3Ih7jDKu3hlXFsBFwoUDtLaFJj1PLlmWLMtL+f5hYbMUVbo
# nXCUbKw5TNT2eb+qGHpiKe+imyk0BncaYsk9Hm0fgvALxyy7z0Oz5fnsfbXjpKh0
# NbhOxXEjEiZ2CzxSjHFaRkMUvLOzsE1nyJ9C/4B5IYCeFTBm6EISXhrIniIh0EPp
# K+m79EjMLNTYMoBMJipIJF9a6lbvpt6Znco6b72BJ3QGEe52Ib+bgsEnVLaxaj2J
# oXZhtG6hE6a/qkfwEm/9ijJssv7fUciMI8lmvZ0dhxJkAj0tr1mPuOQh5bWwymO0
# eFQF1EEuUKyUsKV4q7OglnUa2ZKHE3UiLzKoCG6gW4wlv6DvhMoh1useT8ma7kng
# 9wFlb4kLfchpyOZu6qeXzjEp/w7FW1zYTRuh2Povnj8uVRZryROj/TGCBKUwggSh
# AgEBMIGQMHkxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYD
# VQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xIzAh
# BgNVBAMTGk1pY3Jvc29mdCBDb2RlIFNpZ25pbmcgUENBAhMzAAAAsBGvCovQO5/d
# AAEAAACwMAkGBSsOAwIaBQCggb4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQw
# HAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFIs/
# zFx/+EBCLP0zwXpFZMeGSkzwMF4GCisGAQQBgjcCAQwxUDBOoDSAMgBNAGkAYwBy
# AG8AcwBvAGYAdAAgAFAAYQBjAGsAYQBnAGUAIABNAGEAbgBhAGcAZQByoRaAFGh0
# dHA6Ly93d3cuYXNwLm5ldC8gMA0GCSqGSIb3DQEBAQUABIIBAMy89iChgyDmnjus
# cNV5uI31lwS/O01Vbnap7RPL95XHFX51j2591VpJGYDEJNeSJvpdLtNPmtZas2Uq
# NIhieI5xo1m1BjFiuYp/jPcJcESLGU9MD3aZywUPstpzFJp9b+i8HBMIyR14hdE0
# OQXXeTN14zPzkBYh4UD8YAMHjlZUdsbgC0/AEI2VLWCu+BorH+Ah3nrkRmt0wCkx
# cuNAaCoCpk0rCD0aZfeHR+LfOufnvS+K6y8zoJy/EcjnCFjBdl4HevIKpuw+redr
# tqKo6m0TOXCifRCD6kF7c1Xb4H0lAMOrM5hbyuWuTl5m/gZv/5G1jxdHB5U1rYYg
# S70ELQmhggIoMIICJAYJKoZIhvcNAQkGMYICFTCCAhECAQEwgY4wdzELMAkGA1UE
# BhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAc
# BgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEhMB8GA1UEAxMYTWljcm9zb2Z0
# IFRpbWUtU3RhbXAgUENBAhMzAAAAKzkySMGyyUjzAAAAAAArMAkGBSsOAwIaBQCg
# XTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMzA5
# MTIxMDM2MzZaMCMGCSqGSIb3DQEJBDEWBBS5E2AgXGQaiuMRrksHMm65Wo7pBTAN
# BgkqhkiG9w0BAQUFAASCAQAXG/U++huyHFWJLzfbb7Y+91uVWNHJxODIXqiiAJ4J
# IU0juiFoXtHnDYDdpRgu0BO4BJqNOAseHpMPASLBec6xYuGrBsdjiXB0Mqjm4QhL
# edj2H+skg+vGYpWvweuk+r7OAM829bsT2WG4xaSSygp7IP3j0gzrb/uWOR6zNl4D
# PQdS2Pekw9/KX44Gn2TCy9CqNFOoxnmrVURE1EdpqnEPJiNG9jWsrLza5O0oHeOe
# ZMt3S1H5vf/lxphRhc5ambtaJnhT3hKtiidhCux9BrgDOpj8iWewIPWGdcF7gI0i
# MmBdmkxtNGUDR8jCdvhGlMSqvQUGx/AK2DW0hN7uT/Ww
# SIG # End signature block
