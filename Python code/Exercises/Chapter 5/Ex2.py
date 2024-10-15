def NhapLuutru(m,n):
    lop = {}
    dsmon = []
    for j in range(1,n+1):
        while True:
            mon = input(f"\t Nhap mon thu {j}: ")
            if mon:
                if mon not in dsmon:
                    dsmon.append(mon)
                    break
                else:
                    print("Da co mon trong danh sach")
            else:
                print("Ten mon khong duoc de trong")
                
    for i in range(1,m+1):
        sv = input(f"\nNhap ten sv thu {i}: ")
        dsdiem = {}
        for mon in dsmon:
            while True:
                try:
                    diem = float(input(f"\t{mon}: "))
                    if 0 <= diem <= 10:
                        dsdiem[mon] = diem
                        break
                    else:
                        print("Xin nhap lai!")
                except ValueError:
                    print("Diem phai la mot so!")
        lop[sv] = dsdiem
    return lop



def tinhTB(m,n):
    lop = NhapLuutru(m,n)
    dsdtb = {}
    for sv,dsdiem in lop.items():
        tongDiem = 0
        for mon,diem in dsdiem.items():
            tongDiem += diem
        dtb = tongDiem/len(dsdiem)
        dsdtb[sv] = dtb
    return dsdtb,lop



def XepHang(dsdtb):
    dsXH = sorted(dsdtb.items(), key=lambda item: item[1], reverse=True)
    return dsXH



def TimSvGioi_Kem(dsdtb):
    dtbCao = max(dsdtb.values())
    dtbThap = min(dsdtb.values())
    hsGioi = [sv for sv, dtb in dsdtb.items() if dtb == dtbCao]
    hsKem = [sv for sv, dtb in dsdtb.items() if dtb == dtbThap]
    return hsGioi, dtbCao, hsKem, dtbThap
    


def thongkeSV(dsdtb):
    loaiGioi = [sv for sv, dtb in dsdtb.items() if dtb >= 8.0]
    loaiKha = [sv for sv, dtb in dsdtb.items() if 8.0 > dtb >= 6.0]
    loaiTbinh = [ sv for sv, dtb in dsdtb.items() if 6.0 > dtb >= 5.0]
    loaiYeu = [sv for sv, dtb in dsdtb.items() if dtb < 5.0]
    return loaiGioi, loaiKha, loaiTbinh, loaiYeu
    
    
    
def main():
    m = int(input("Nhap so luong sinh vien: "))
    while m < 10 or m > 30:
        print("Nhap lai so luong sinh vien.")
        m = int(input("Nhap so luong sinh vien: "))
    n = int(input("Nhap so luong mon: "))
    while n < 5 or n > 10:
        print("Nhap lai so luong mon.")
        n = int(input("Nhap so luong mon: "))
    
    dsdtb,lop = tinhTB(m,n)
    print("\nDanh sach sinh vien va diem trung binh mon la: ")
    for sv,dsmon in lop.items():
        print(f"\n\t{sv}")
        for mon,diem in dsmon.items():
            print(f"\t\t{mon} : {diem}")
    print("\nDanh sach diem trung binh mon cac sinh vien la: ")
    for sv,dtb in dsdtb.items():
        print(f"\t{sv} : {dtb}")
    print(f"{dsdtb}")
    print("\nDanh sach sinh vien sau xep hang la: ")
    dsXH = XepHang(dsdtb)
    
    thuHangHT = 0
    dtbTrc = None
    for thuHang, (sv, dtb) in enumerate(dsXH, start=1):
        if dtb != dtbTrc:
            thuHangHT = thuHang
            dtbTrc = dtb
        print(f"{thuHangHT}. {sv} : {dtb:.2f}")
        
        
    hsGioi, dtbCao, hsKem, dtbThap = TimSvGioi_Kem(dsdtb)
    print("Sinh vien gioi: ")
    for sv in hsGioi:
        print(f"\t{sv} : {dtbCao:.2f}")
    print("Sinh vien kem: ")
    for sv in hsKem:
        print(f"\t{sv} : {dtbThap:.2f}")
        
        
    loaiGioi, loaiKha, loaiTbinh, loaiYeu = thongkeSV(dsdtb)
    print("Sinh vien dat loai gioi: ")
    for sv in loaiGioi:
        print(f"\t{sv} : {dtb}")
    print("Sinh vien dat loai kha: ")
    for sv in loaiKha:
        print(f"\t{sv} : {dtb}")
    print("Sinh vien dat loai trung binh: ")
    for sv in loaiTbinh:
        print(f"\t{sv} : {dtb}")
    print("Sinh vien dat loai yeu: ")
    for sv in loaiYeu:
        print(f"\t{sv} : {dtb}")
main()