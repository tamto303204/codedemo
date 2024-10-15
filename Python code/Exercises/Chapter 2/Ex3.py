import numpy as np
   
    
def XetDK():
    while True:
        a = float(input("Nhap do dai a:"))
        b = float(input("Nhap do dai b:"))
        c = float(input("Nhap do dai c:"))
        if a < 0 or b < 0 or c < 0:
            print("Xin nhap lai cac canh lon hon 0!")
        else:
            break
    sumab = a + b
    sumac = a + c
    sumbc = b + c
    if sumab < c or sumac < b or sumbc < a:
            print("Day khong phai la 3 canh cua tam giac!") 
    return a,b,c



def TinhTG(a,b,c):
    P = a + b + c
    p = P / 2
    S = np.sqrt(p*(p-a)*(p-b)*(p-c))

    print(f"Chu vi cua tam giac la: {P:.2f}")
    print(f"Dien tich cua tam giac la: {S:.2f}")
    return S,p
    
    
def DuongTG(S,p):
    h = ((2*S)/a)
    m = (np.sqrt((2*pow(b,2)) + (2*pow(c,2)) - pow(a,2))/2)
    g = (2/(b+c))*np.sqrt(b*c*p*(p-a))
    print(f"Do dai chieu cao cua tam giac la: {h:.2f}")
    print(f"Do dai duong trung tuyen cua tam giac la: {m:.2f}")
    print(f"Do dai duong phan giac cua tam giac la: {g:.2f}")
    return h,m,g

def DuongTron(S,p):
    r = S/p
    R = (a*b*c)/(4*S)
    
    print(f"Do dai ban kinh duong tron noi tiep cua tam giac la: {r:.2f}")
    print(f"Do dai ban kinh duong tron ngoai tiep cua tam giac la: {R:.2f}")





a,b,c = XetDK()
S,p = TinhTG(a,b,c)
DuongTG(S,p)
DuongTron(S,p)