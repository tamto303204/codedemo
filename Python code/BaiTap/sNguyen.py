"""
n = int(input("Nhap so nguyen n: "))
dSach = []
for i in range(0,n,1):
    sNguyen = int(input(f"Nhap so nguyen thu {i+1}: "))
    dSach.append(sNguyen)
print(f"Danh sach cac so da nhap gom {n} so nguyen la: {dSach}")
"""

#Dung ham
def danh_sach():
    n = int(input("Nhap so luong so nguyen: "))
    DSach = []
    for i in range(0,n,1):
        sNguyen = int(input(f"Nhap so nguyen thu {i+1}: "))
        DSach.append(sNguyen)
    return n,DSach

n,DSach = danh_sach()
print(f"so luong so nguyen: {n}")
print(f"danh sach da nhap: {DSach}")