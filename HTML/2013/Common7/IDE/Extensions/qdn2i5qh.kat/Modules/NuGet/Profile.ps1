#
# PowerConsole profile
#

<#
.SYNOPSIS
    Clear the host content.
    
.DESCRIPTION
    This function replaces the standard Clear-Host and is aliased by "cls".
#>
function Clear-Host
{
    $host.PrivateData.ClearHost()
}

<#
.SYNOPSIS
    Simple path completion function for PowerConsole.
#>
function _TabExpansionPath($line)
{
    function UnquoteString($s) {
        if ($s.StartsWith('"') -or $s.StartsWith("'")) {
            $s = $s.Substring(1)
        }
        if ($s.EndsWith('"') -or $s.EndsWith("'")) {
            $s = $s.Substring(0, $s.Length - 1)
        }
        return $s
    }
    
    $e = $null
    $tokens = @([System.Management.Automation.PSParser]::Tokenize($line, [ref]$e))
    $lastToken = $tokens | Select-Object -Last 1
    
    $replaceStart = -1
    $lastWord = $null
    
    if ($lastToken -and ($lastToken.EndColumn -gt $line.Length)) {
        #Last token is terminated
                        
        if ($tokens.Length -gt 1) {
            $prevToken = $tokens[$tokens.Length - 2]
            if ($prevToken.EndColumn -eq $lastToken.StartColumn) {
                $replaceStart = $prevToken.StartColumn - 1
                $lastWord = (UnquoteString $prevToken.Content) + (UnquoteString $lastToken.Content)
            }
        }
                                
        if ($replaceStart -lt 0) {
            $replaceStart = $lastToken.StartColumn - 1
            $lastWord = UnquoteString $lastToken.Content
        }
    } else {
        #There is unrecognized/unterminated words
    
        if(!$lastToken) {
            $lastWord = $line
        } else {
            $lastWord = $line.Substring($lastToken.EndColumn - 1).TrimStart()
        }
        $replaceStart = $line.Length - $lastWord.Length
        $lastWord = UnquoteString $lastWord
    }

    # If previously unquoted, put back quote in results
    $unquoted = ($replaceStart -lt ($line.Length - $lastWord.Length))    
    $relative = !(($lastWord.IndexOf(':') -ge 0) -or $lastWord.StartsWith('/') -or $lastWord.StartsWith('\'))    

    $result = "" | select ReplaceStart, Paths
    $result.ReplaceStart = $replaceStart
    $result.Paths = @(Resolve-Path ${lastWord}* -ErrorAction SilentlyContinue -Relative:$relative | %{
    
        # Resolve-Path may return PathInfo or String (e.g. when passing different -Relative)
        $path = $_.ToString()
        
        if ($unquoted -or ($path.IndexOf(' ') -ge 0)) {
            "'$path'"
        } else {
            $path
        }
    })
    
    $result
}

<#
.SYNOPSIS
    Get an explict interface on an object so that you can invoke the interface members.
    
.DESCRIPTION
    PowerShell object adapter does not provide explict interface members. For COM objects
    it only makes IDispatch members available.
    
    This function helps access interface members on an object through reflection. A new
    object is returned with the interface members as ScriptProperties and ScriptMethods.
    
.EXAMPLE
    $dte2 = Get-Interface $dte ([EnvDTE80.DTE2])
#>
function Get-Interface
{
    Param(
        $Object,
        [type]$InterfaceType
    )
    
    [NuGetConsole.Host.PowerShell.Implementation.PSTypeWrapper]::GetInterface($Object, $InterfaceType)
}

<#
.SYNOPSIS
    Get a VS service.

.EXAMPLE
    Get-VSService ([Microsoft.VisualStudio.Shell.Interop.SVsShell]) ([Microsoft.VisualStudio.Shell.Interop.IVsShell])
#>
function Get-VSService
{
    Param(
        [type]$ServiceType,
        [type]$InterfaceType
    )

    $service = [Microsoft.VisualStudio.Shell.Package]::GetGlobalService($ServiceType)
    if ($service -and $InterfaceType) {
        $service = Get-Interface $service $InterfaceType
    }

    $service
}

<#
.SYNOPSIS
    Get VS IComponentModel service to access VS MEF hosting.
#>
function Get-VSComponentModel
{
    Get-VSService ([Microsoft.VisualStudio.ComponentModelHost.SComponentModel]) ([Microsoft.VisualStudio.ComponentModelHost.IComponentModel])
}

# Set initial directory
Set-Location "$env:USERPROFILE"

# For PowerShell v2, we need to create a reference to the default TabExpansion function
# so we can delegate back to it in our custom function. This isn't needed in PowerShell v3, 
# as omitting output in a custom TabExpansion function signals to TabExpansion2 that it 
# should use its own completion list.
if ((Test-Path Function:\DefaultTabExpansion) -eq $false -and (Test-Path Function:\TabExpansion)) {
    Rename-Item Function:\TabExpansion DefaultTabExpansion
}

function TabExpansion([string]$line, [string]$lastWord) {
       $nugetSuggestions = & (Get-Module NuGet) NuGetTabExpansion $line $lastWord
       
       if ($nugetSuggestions.NoResult) {
              # We only want to delegate back to the default tab completion in PowerShell v2.
              # PowerShell v3's TabExpansion2 will use its own command completion list if the
              # custom TabExpansion doesn't return anything.
              if (Test-Path Function:\DefaultTabExpansion) {
                     $line = $line.ToUpperInvariant()
                     $lastWord = $lastWord.ToUpperInvariant()
                     return DefaultTabExpansion $line $lastWord
              }
       }
       else {
              return $nugetSuggestions
       }
}

# default prompt
function prompt {
    "PM>"
}

# SIG # Begin signature block
# MIIavQYJKoZIhvcNAQcCoIIarjCCGqoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUzrybryeGjFQ1ndAZPspjCdvf
# ahSgghWCMIIEwzCCA6ugAwIBAgITMwAAADQkMUDJoMF5jQAAAAAANDANBgkqhkiG
# 9w0BAQUFADB3MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4G
# A1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSEw
# HwYDVQQDExhNaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EwHhcNMTMwMzI3MjAwODI1
# WhcNMTQwNjI3MjAwODI1WjCBszELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hp
# bmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jw
# b3JhdGlvbjENMAsGA1UECxMETU9QUjEnMCUGA1UECxMebkNpcGhlciBEU0UgRVNO
# OkI4RUMtMzBBNC03MTQ0MSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBT
# ZXJ2aWNlMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA5RoHrQqWLNS2
# NGTLNCDyvARYgou1CdxS1HCf4lws5/VqpPW2LrGBhlkB7ElsKQQe9TiLVxj1wDIN
# 7TSQ7MZF5buKCiWq76F7h9jxcGdKzWrc5q8FkT3tBXDrQc+rsSVmu6uitxj5eBN4
# dc2LM1x97WfE7QP9KKxYYMF7vYCNM5NhYgixj1ESZY9BfsTVJektZkHTQzT6l4H4
# /Ieh7TlSH/jpPv9egMkGNgfb27lqxzfPhrUaS0rUJfLHyI2vYWeK2lMv80wegyxj
# yqAQUhG6gVhzQoTjNLLu6pO+TILQfZYLT38vzxBdGkVmqwLxXyQARsHBVdKDckIi
# hjqkvpNQAQIDAQABo4IBCTCCAQUwHQYDVR0OBBYEFF9LQt4MuTig1GY2jVb7dFlJ
# ZoErMB8GA1UdIwQYMBaAFCM0+NlSRnAK7UD7dvuzK7DDNbMPMFQGA1UdHwRNMEsw
# SaBHoEWGQ2h0dHA6Ly9jcmwubWljcm9zb2Z0LmNvbS9wa2kvY3JsL3Byb2R1Y3Rz
# L01pY3Jvc29mdFRpbWVTdGFtcFBDQS5jcmwwWAYIKwYBBQUHAQEETDBKMEgGCCsG
# AQUFBzAChjxodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpL2NlcnRzL01pY3Jv
# c29mdFRpbWVTdGFtcFBDQS5jcnQwEwYDVR0lBAwwCgYIKwYBBQUHAwgwDQYJKoZI
# hvcNAQEFBQADggEBAA9CUKDVHq0XPx8Kpis3imdYLbEwTzvvwldp7GXTTMVQcvJz
# JfbkhALFdRxxWEOr8cmqjt/Kb1g8iecvzXo17GbX1V66jp9XhpQQoOtRN61X9id7
# I08Z2OBtdgQlMGESraWOoya2SOVT8kVOxbiJJxCdqePPI+l5bK6TaDoa8xPEFLZ6
# Op5B2plWntDT4BaWkHJMrwH3JAb7GSuYslXMep/okjprMXuA8w6eV4u35gW2OSWa
# l4IpNos4rq6LGqzu5+wuv0supQc1gfMTIOq0SpOev5yDVn+tFS9cKXELlGc4/DC/
# Zef1Od7qIu2HjKuyO7UBwq3g/I4lFQwivp8M7R0wggTsMIID1KADAgECAhMzAAAA
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
# HAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFMuf
# sd32QCBuLAAV0rkqW6bKVWYSMF4GCisGAQQBgjcCAQwxUDBOoDSAMgBNAGkAYwBy
# AG8AcwBvAGYAdAAgAFAAYQBjAGsAYQBnAGUAIABNAGEAbgBhAGcAZQByoRaAFGh0
# dHA6Ly93d3cuYXNwLm5ldC8gMA0GCSqGSIb3DQEBAQUABIIBANc117BNejclp+Sm
# 7sIPbSRU3WOoWxoujmEtPW3yFP9H6DaOCA/8X2kfsffENDk1e1BRSabmnGU0e9jf
# cI6FWlL1X9XFbr7wrWhj2g+nPJ9IBV9bjcrCJNpSSKAeis1isbbTfmMwXv0v0Fdp
# z24p39DXcmyV+2Ueb3ZTa1RMiMzC/1+iKrNFmEt8yP2Ld9Td7XfoVcLr6jUHcp8S
# rHwTC/hR2UllP+HwKV8Nd+V435N7RUBTHI9hYu7TpJRZGXdLO3WxF6XUUsLjXcfx
# BfhPqLGojZVqu6vlUAxrR25XqK7nsbwkoPUDd5HvOdfCUaeAgrrRevCXD/enxNlc
# OAhRUiihggIoMIICJAYJKoZIhvcNAQkGMYICFTCCAhECAQEwgY4wdzELMAkGA1UE
# BhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAc
# BgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEhMB8GA1UEAxMYTWljcm9zb2Z0
# IFRpbWUtU3RhbXAgUENBAhMzAAAANCQxQMmgwXmNAAAAAAA0MAkGBSsOAwIaBQCg
# XTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMzA5
# MTIxMDM2MzZaMCMGCSqGSIb3DQEJBDEWBBRuf/LLGcqLbFBEXHK5IcqgM83jqjAN
# BgkqhkiG9w0BAQUFAASCAQDTdjd2WyDD34tCuR2KToNdQ6QeJyyipjjFenIw9HKG
# 6NpiQR8E2pu140Bfm04ZDYP6mfBbJwVGVojGVZRIuQhcbWEi24pUQJlWocRNhmpc
# Gay6Dk5LSdXuE1mEfpAshVtnvofeBhUUIlnuL0+y6P0nKVbsTtVq7PfWcFqUICRM
# Q80NEjgwIvq8N/Yd1XyOM3VpRscsHvlv16V1B/kYrE2uOZWUk2saMg7/520rlF3Z
# SftUuRi9kvjD2XqMZDigSycUtpyOvJUBEA59MLpju/wyGeICE/BjtKeg/cL2h/Ss
# prz8fp9tkKMwT7GPbACPr5CeDlNUfbtUKPfELwDTXp2K
# SIG # End signature block
