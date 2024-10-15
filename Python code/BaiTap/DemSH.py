"""
n = int(input("Nhap so nguyen n: "))
dSach = []
for i in range(0,n,1):
    sNguyen = int(input(f"Nhap so nguyen thu {i+1}: "))
    dSach.append(sNguyen)
print(f"Danh sach cac so da nhap gom {n} so nguyen la: {dSach}")


#Dem so lan xuat hien cua so xuat hien nhieu hon 1 lan
sDD = set()
for sNg in dSach:
    if dSach.count(sNg) > 1 and sNg not in sDD:
        sLan = dSach.count(sNg)
        print(f"so {sNg} xuat hien {sLan} lan")
        sDD.add(sNg)
"""
        
#Dung ham
def DemXH(n, dSach):
    soDD = set()
    for i in range(n):
        sNg = int(input())
        dSach.append(sNg)
    print(f"Danh sach cac so: {dSach}")
    for sNg in dSach:
        if dSach.count(sNg) > 1 and sNg not in soDD:
            sLanXH = dSach.count(sNg)
            print(f"So {sNg} xuat hien {sLanXH} lan")
            soDD.add(sNg)
    return sLanXH

DanhSach = []
n = int(input("Nhap so luong phan tu: "))
DemXH(n,DanhSach)