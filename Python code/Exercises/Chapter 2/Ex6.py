import math
def Xet_Vitri(x1,y1,r1,x2,y2,r2):
    d = math.sqrt(pow(x1-x2,2) + pow(y1-y2,2))
    if abs(r1-r2) < d < r1+r2:
        return "Hai duong tron giao nhau!"
    elif r1+r2 < d:
        return "Hai duong tron khong giao nhau!"
    elif d == r1+r2 or d == abs(r1-r2):
        return "Hai duong tron tiep xuc nhau!"
    elif d < abs(r1-r2):
        return "Hai duong tron nam trong nhau!"
    
    
    
x1 = int(input("Nhap toa do x cua tam duong tron thu nhat: "))
y1 = int(input("Nhap toa do y cua tam duong tron thu nhat: "))
r1 = int(input("Nhap ban kinh cua duong tron thu nhat: "))

x2 = int(input("Nhap toa do x cua tam duong tron thu hai: "))
y2 = int(input("Nhap toa do y cua tam duong tron thu hai: "))
r2 = int(input("Nhap ban kinh cua duong tron thu hai: "))

KetQua = Xet_Vitri(x1,y1,r1,x2,y2,r2)
print(KetQua)