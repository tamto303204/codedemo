def KTra(m,y):
    match m:
        case 1:
            return "31 ngay"
        case 2:
            if (y % 4 == 0 and y % 100 != 0) or (y % 400 == 0):
                return "29 ngay"
            else:
                return "28 ngay"
        case 3:
            return "31 ngay"
        case 4:
            return "30 ngay"
        case 5:
            return "31 ngay"
        case 6:
            return "30 ngay"
        case 7:
            return "31 ngay"
        case 8:
            return "31 ngay"
        case 9:
            return "30 ngay"
        case 10:
            return "31 ngay"
        case 11:
            return "30 ngay"
        case 12:
            return "31 ngay"
        
        
m = int(input("Nhap thang: "))
y = int(input("Nhap nam: "))
print(KTra(m,y))