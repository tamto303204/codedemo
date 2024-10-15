import math
n = int(input("Nhap so nguyen n: "))
dSach = []
for i in range(0,n,1):
    sNguyen = int(input(f"Nhap so nguyen thu {i+1}: "))
    dSach.append(sNguyen)
print(f"Danh sach cac so da nhap gom {n} so nguyen la: {dSach}")


#so chinh phuong
demCP = 0
dSachCP = []
for i in range(0,n,1):
    a = dSach[i]
    if pow(math.sqrt(a),2) == a:
        dSachCP.append(a)
        demCP = demCP + 1
print(f"Danh sach tren gom {demCP} so chinh phuong la: {dSachCP}")


#so nguyen to
demNT = 0
dSachNT = []
for i in range(0,n,1):
    b = dSach[i]
    dem = 0
    for j in range(1,b+1,1):
        if b % j == 0:
            dem += 1
    if dem == 2:
        dSachNT.append(b)
        demNT += 1
print(f"Danh sach tren gom {demNT} so nguyen to la: {dSachNT}")