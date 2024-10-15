"""n = int(input("Nhap so nguyen n: "))
dSach = []
for i in range(0,n,1):
    sNguyen = int(input(f"Nhap so nguyen thu {i+1}: "))
    dSach.append(sNguyen)
print(f"Danh sach cac so da nhap gom {n} so nguyen la: {dSach}")


#phan tram so le trong day
dsLe = set()
dem = 0
for sNg in dSach:
    if sNg % 2 != 0:
       dem += 1
       dsLe.add(sNg)
pTram = (dem / n) * 100
print(f"so le trong day la {dsLe} chiem {pTram:.2f}%")
"""

#dung ham
def loc_so_le( dSach):
    n = Nhap(dSach)
    dsLe = []
    dem = 0
    for sNg in dSach:
        if sNg % 2 != 0:
            dsLe.append(sNg)
            dem += 1
    pTram = (dem / n) * 100
    KQ = print(f"trong day co {dem} so le la: {dsLe} chiem {pTram:.3f}% trong day")
    return KQ


def Nhap(dSach):
    n = int(input("Nhap so luong phan tu: "))
    for i in range (n):
        sNg = int(input(f"Nhap so nguyen thu {i+1}: "))
        dSach.append(sNg)
    return n

DSach = []
loc_so_le(DSach)