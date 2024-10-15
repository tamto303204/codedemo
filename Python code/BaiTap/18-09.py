"""l1 = [1, 2]
l2 = [3, 4, 5]
l3 = l1+l2
print(l3)
l4=3*l1
print(l4)
"""

"""
ls = [i+1 for i in range(1,5,1)]
print('ls: ', ls)
la = list([2, 4, 6])
print('la: ', la)
tong = ls +la
print('tong: ', tong)
tong = 2* tong
print(tong)"""


"""a = int(input())
b = int(input())
try:
    c = a/b
except ZeroDivisionError:
    print("loi chia 0")
  """  
    
    
"""ls = [1,2,3,6,7,12,15]

print(ls[0])
print(ls[2:4])
la = ls[1:4]
print(la)
la = 2* la
print(la)"""




"""l = [1,2,3,4,5]
s = [1,'a',2]

m = 1
m1 = list(l)
m2 = l[0:5]
m3 = sorted(l)
m4 = [i for i in l]
m5 = [i+1 for i in range(len(l))]


sl = len(s)
print('so luong phan tu s ',sl)


print('tong ca phan tu danh sach l ', sum(l))
try:
    print(' tong ca phan tu danh sach s ', sum(s))
except TypeError:
    print('loi tong danh sach s')
    
    
print('gia tri nho nhat trong danh sach l ', min(l))
try:
    print('gia tri nho nhat trong danh sach s ', min(s))
except TypeError:
    print('loi')"""
    
    
"""    
l = [1,2,3,4,5]
print(l)

for i in l:
    print(i, end='')
print()

s1 = ''
for i in l:
    s1 += str(i)+' '
print(s1)


for i in range(len(l)):
    print(l[i],end=' ')"""
    
    
"""
a = [n for n in range(1,10,2)]
ls = list(a)
print('danh sach ls la ', ls)
print('so luong phan tu ',len(ls))

#them phan tu
ls = [11] + ls
print('danh sach them 1 phan tu ',ls)

#sap xep danh sach
ls = sorted(ls)
print('danh sach sau sap xep ',ls)"""


ls = [1,2,3,4,5]
a = int(input())
try:
    ls.remove(a)
except ValueError:
    print('khong tim thay trong danh sach')
print(ls)