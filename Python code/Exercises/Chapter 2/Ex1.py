a = int(input("Nhap 1 so nguyen: "))
if a < 0:
    print(f"{a} la so am")
else:
    print(f"{a} la so duong")
if a % 2 == 0:
    print(f"{a} la so chan")
else:
    print(f"{a} la so le")