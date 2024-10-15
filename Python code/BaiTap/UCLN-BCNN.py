n = int(input("Nhap so nguyen n: "))
dSach = []
for i in range(0,n,1):
    sNguyen = int(input(f"Nhap so nguyen thu {i+1}: "))
    dSach.append(sNguyen)
print(f"Danh sach cac so da nhap gom {n} so nguyen la: {dSach}")


#tim UCLN 
soNN = min(dSach)
print(f"Số nhỏ nhất trong dãy: {soNN}")

dsUoc = set()
for i in range(1,soNN+1):
    if soNN % i == 0:
        dsUoc.add(i)
print(f"uoc cua {soNN} la: {dsUoc}")


dsUocChung = dsUoc.copy()  
for sNguyen in dSach:
    tempUocChung = set()  
    for uoc in dsUocChung:
        if sNguyen % uoc == 0:
            tempUocChung.add(uoc)
    dsUocChung = tempUocChung  
print(f"Ước chung của dãy là: {dsUocChung}")



if dsUocChung:
    UCLN = max(dsUocChung)
    print(f"uoc chung lon nhat cua day la: {UCLN}")
else:
    print("khong co uoc chung")
    
    
    
#tim BCNN 
