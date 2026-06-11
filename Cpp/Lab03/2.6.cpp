#include <iostream>
#include <string>
using namespace std;

class DongVat { 
private:
    int tuoiThoToiDa; 

protected:
    string tenLoai; 

public:
    string layTenLoai() {
        return tenLoai;
    }
        DongVat(string ten, int tuoi) {
        tenLoai = ten;
        tuoiThoToiDa = tuoi; 
    }
    int layTuoiThoToiDa() {
        return tuoiThoToiDa;
    }
    virtual void keu() { 
        cout << tenLoai << " phát ra âm thanh chung chung." << endl;
    }
};
class Meo : public DongVat {
public:
    Meo() : DongVat("Mèo", 15) {}
    void keu() override { 
        cout << tenLoai << " kêu: Meo Meo" << endl;
    }
};
class Cho : public DongVat {
public:
    Cho() : DongVat("Chó", 20) {}
    void keu() override {
        cout << tenLoai << " kêu:Gâu Gâu" << endl;
    } };
int main() {
    Meo meoCon;
    Cho choCon;
 
    cout << "Kết quả" << endl;
    cout << "1. Kế Thừa & Đóng Gói:" << endl;
    cout << "- Loài 1 " << meoCon.layTenLoai() << " có tuổi thọ tối đa: " << meoCon.layTuoiThoToiDa() << " năm." << endl; 
    cout << "- Loài 2 " << choCon.layTenLoai() << " có tuổi thọ tối đa: " << choCon.layTuoiThoToiDa() << " năm." << endl;
    cout << "\n2. Trừu Tượng & Đa Hình:" << endl;
    DongVat* dsDongVat[2] = {&meoCon, &choCon};
    
        for (int i = 0; i < 2; i++) {
        dsDongVat[i]->keu(); 
    }

    return 0;
}