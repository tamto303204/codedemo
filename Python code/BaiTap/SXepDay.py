"""n = int(input("Nhap so nguyen n: "))
dSach = []
for i in range(0,n,1):
    sNguyen = int(input(f"Nhap so nguyen thu {i+1}: "))
    dSach.append(sNguyen)
print(f"Danh sach cac so da nhap gom {n} so nguyen la: {dSach}")


#sap xep tang dan
for i in range(0,n-1,1):
    for j in range(i+1,n,1):
        if dSach[i] > dSach[j]:
            temp = dSach[i]
            dSach[i] = dSach[j] 
            dSach[j] = temp
print(f"Danh sach cac so sau khi sap xep tang dan la: {dSach}")


#sap xep giam dan
for i in range(0,n-1,1):
    for j in range(i+1,n,1):
        if dSach[i] < dSach[j]:
            temp = dSach[i]
            dSach[i] = dSach[j] 
            dSach[j] = temp
print(f"Danh sach cac so sau khi sap xep tang dan la: {dSach}")
"""

#dung ham
#Sap xep tang dan
def SXTang(n, dSach):
    for i in range(0,n-1,1):
        for j in range(i+1,n,1):
            if dSach[i] > dSach[j]:
                temp = dSach[j]
                dSach[j] = dSach[i]
                dSach[i] = temp
    return dSach

def SXGiam(n, dSach):
    for i in range(0,n-1,1):
        for j in range(i+1,n,1):
            if dSach[i] < dSach[j]:
                temp = dSach[j]
                dSach[j] = dSach[i]
                dSach[i] = temp
    return dSach

def Nhap(n,dSach):
    for i in range(0, n):
        sNg = int(input(f"Nhap so thu {i+1} vao day: "))
        dSach.append(sNg) 
    return dSach

def Xuat(n, dSach):
    SXGiam(n, dSach)
    print(f"Day so sau khi sap xep giam dan la: {dSach}")
    SXTang(n, dSach)
    print(f"Day so sau khi sap xep tang dan la: {dSach}")
    return dSach
DSach = []
n = int(input("Nhap so luong phan tu: "))
Nhap(n,DSach)
Xuat(n,DSach)