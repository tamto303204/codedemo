from math import gcd
from functools import reduce

# Hàm tính BCNN của hai số
def lcm(a, b):
    return abs(a * b) // gcd(a, b)

# Hàm tính BCNN của một danh sách các số
def find_lcm_of_list(num_list):
    return reduce(lcm, num_list)

# Nhập số nguyên n
n = int(input("Nhập số nguyên n: "))
dSach = []

# Nhập danh sách số nguyên
for i in range(n):
    sNguyen = int(input(f"Nhập số nguyên thứ {i + 1}: "))
    dSach.append(sNguyen)

print(f"Danh sách các số đã nhập gồm {n} số nguyên là: {dSach}")

# Tính BCNN
BCNN = find_lcm_of_list(dSach)
print(f"Bội chung nhỏ nhất của dãy là: {BCNN}")
