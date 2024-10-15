import math
a = int(input("Nhap 1 so nguyen bat ky:"))
if pow(math.sqrt(a),2) == a:
    print(f"{a} la so chinh phuong")
else:
    print(f"{a} khong phai la so chinh phuong")