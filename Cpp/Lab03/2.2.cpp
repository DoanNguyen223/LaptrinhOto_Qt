#include <iostream>
#include <string>
using namespace std;

class Sach {
private:
   
    string maSoNoiBo; 
    int soLuongTonKho; 
    
public:
    string tieuDe; 
    string tacGia;

    Sach(string td, string tg, string maSo, int tonKho) {
        tieuDe = td;
        tacGia = tg;
        maSoNoiBo = maSo; 
        soLuongTonKho = tonKho; 
    }
    void docSach() {
        cout << "đang đọc sách \"" << tieuDe << "\" của tác giả " << tacGia << "." << endl; 
    }
    void kiemTraTinhTrang() {
        cout << "Kiểm tra: Sách \"" << tieuDe << "\" hiện đang " << (soLuongTonKho > 0 ? "Còn hàng." : "Hết hàng.") << endl;
    }
};
int main() {
    cout << "kết quả" << endl;
    Sach kieu("Truyện Kiều", "Nguyễn Du", "ISBN-1001", 500); 
    cout << "Thông tin cơ bản:" << endl;
    cout << "- Tiêu đề: " << kieu.tieuDe << endl;
    cout << "- Tác giả: " << kieu.tacGia << endl;
    
    kieu.docSach(); 
    kieu.kiemTraTinhTrang(); 

    return 0;
}