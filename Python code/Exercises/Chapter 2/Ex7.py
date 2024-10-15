def SX_Giam(a,b,c):
    if a < b:
        a,b = b,a
    if a < c:
        a,c = c,a
    if c > b:
        c,b = b,c
    print("Cac so theo thu tu giam dan:", a, b, c)


def SX_Tang(a,b,c):
    if a > b:
        a,b = b,a
    if a > c:
        a,c = c,a
    if c < b:
        c,b = b,c
    print("Cac so theo thu tu tang dan:", a, b, c)
    
    
a = float(input("Nhap so thuc thu nhat: "))
b = float(input("Nhap so thuc thu hai: ")) 
c = float(input("Nhap so thuc thu ba: ")) 
SX_Giam(a,b,c)
SX_Tang(a,b,c)