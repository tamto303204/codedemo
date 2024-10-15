'''
print("Chào bạn")


name=input("Nhập tên: ")
print("Chào:",name)
a=int(input("Nhập số thứ 1: "))
b=int(input("Nhập số thứ 2: "))
c=a+b
print("a+b=",c)


seconds_in_a_day = 24 * 60 * 60
print(seconds_in_a_day)
'''
'''# Danh sách các số
numbers = [10, 20, 30, 40, 50]

# Tính tổng và độ dài của danh sách
total = sum(numbers)
count = len(numbers)

# Tính trung bình cộng
average = total / count

print("Trung bình cộng:", average)
'''
'''VD 1'''
#print('chào tâm')
#print("Chào Tô Tâm")
#print('''Chào Phương Tâm''')
#print("""Chào Tô Phương Tâm""")




#tuoi = int(input("so tuoi: "))

'''VD 2'''

'''age=20
print(f"Chao Tam {age} tuoi")

so1=5
so2=6
tong = so1+so2
print(f"{so1}+{so2}={tong}")'''

'''VD 3'''
'''ten= input("nhap ten: ")
nam = int(input("nhap nam sinh: "))
print("chao {0} sinh nam {1}".format(ten,nam))
print(f"Chao {ten} sinh nam {nam} ")'''


"""import datetime
namsinh = int(input("Nhập năm sinh của bạn: "))
namhientai = datetime.now().year
age = namhientai - namsinh

print(f"Tuổi của bạn là: {age} tuổi.")"""


"""Câu 1"""
"""a=int(input("Nhap so nguyen thu 1: "))
b=int(input("Nhap so nguyen thu 2: "))
def switch_case():
    str=input("Nhap phep tinh: ")
    
    match str:
        case '+':
            print(f"Tong cua 2 so {a} va {b} la: {a} + {b} = {a+b}")
            return str
        case '-':
            print(f"Hieu cua 2 so {a} va {b} la: {a} - {b} = {a-b}")
            return str
        case '*':
            print(f"Tich cua 2 so {a} va {b} la: {a} * {b} = {a*b}")
            return str
        case '/':
            print(f"Thuong cua 2 so {a} va {b} la: {a} / {b} = {a/b}")
            return str
switch_case()"""


"""Câu 2"""
"""y = int(input("Nhap nam: "))
if y%4==0:
    print(f"SỐ NGÀY CỦA NĂM {y} LÀ 366 ngày")
else:
    print(f"SỐ NGÀY CỦA NĂM {y} LÀ 365 ngày")"""
    
    


"""Câu 3"""
g = int(input("Nhập số thời gian hoàn thành công việc: "))
h = g // 3600
m = (g % 3600) // 60
s = g % 60
print(f"Thời gian làm việc sau khi đổi là: {h} giờ {m} phút {s} giây")



