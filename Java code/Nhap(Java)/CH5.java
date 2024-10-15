
import java.util.Scanner;
public class CH5 {
	public static boolean CH51(int sNg) {
		int sDu = 0;
		if (sDu == sNg % 5) {
			System.out.println(sNg + " co chia het cho 5");
		}else {
			System.out.println(sNg + " khong chia het cho 5");
		}
		return sDu == 0;
	}
	public static boolean CH52(int sNg) {
		int sDu = sNg % 10;
		if(sDu == 0 || sDu == 5) {
			System.out.println(sNg + " co chia het cho 5");
			return true;
		}else {
			System.out.println(sNg + " khong chia het cho 5");
			return false;
		}
	}
	public static boolean CH53(int sNg) {
		String s = String.valueOf(sNg);
		char csCuoi = s.charAt(s.length() - 1);
		if(csCuoi == '0' || csCuoi == '5') {
			System.out.println(sNg + " co chia het cho 5");
			return true;
		}else {
			System.out.println(sNg + " khong chia het cho 5");
			return false;
		}
	}
	
	public static boolean CH54(int sNg) {
		double sDu = (double)sNg / 5;
		if(sDu == (int)sDu) {
			System.out.println(sNg + " co chia het cho 5");
			return true;
		}else {
			System.out.println(sNg + " khong chia het cho 5");
			return false;
		}
	}
	public static void main(String[] args) {
		Scanner scanner = new Scanner(System.in);
		System.out.print("Nhap so nguyen muon kiem tra: ");
		int sNg = scanner.nextInt();
		CH51(sNg);
		CH52(sNg);
		CH53(sNg);
		CH54(sNg);
	}
}
