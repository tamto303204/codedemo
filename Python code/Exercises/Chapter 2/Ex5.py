def HinhA(n):
    for i in range(1,n+1):
        for j in range(i,n+1):
            print(" ", end="")
        for j in range(1,2*i):
            print("*", end="")
        print()
    print("Hinh A")
        
        
def HinhB(n):
    for i in range(1,n+1):
        for j in range(1,n+1):
            print("*", end="")
        print()
    print("Hinh B")


def HinhC(n):
    for i in range(1,n+1):
        for j in range(1,2*i):
            print("*",end="")
        print()
    for i in range(n-1,0,-1):
        for j in range(2*i-1,0,-1):
            print("*",end="")
        print()
    print("Hinh C")



n = int(input("Nhap n: "))
HinhA(n)
print("\n")
HinhB(n)
print("\n")
HinhC(n)