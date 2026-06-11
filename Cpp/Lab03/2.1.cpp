#include <iostream>
#include <string>

using namespace std;

class DongVat {
public:
    string ten;
    int soChan;

    void keu() {
        cout << ten << " đang kêu..." << endl;
    }
};

int main() {
    DongVat cho; 
    cho.ten = "Chó đen";
    cho.soChan = 4;

    DongVat meo; 
    meo.ten = "Mèo mướp";
    meo.soChan = 4;

    cout << "Đv 1: " << cho.ten << ", có " << cho.soChan << " chân." << endl;
    cho.keu();
    cout << "Đv 2: " << meo.ten << ", có " << meo.soChan << " chân." << endl;
    meo.keu();

    return 0;
}