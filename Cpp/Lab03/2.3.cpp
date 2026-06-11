#include <iostream>
#include <string>

using namespace std;

class DongVat {
public:
    string tenChung = "Động Vật";
    void an() {
        cout << tenChung << " đang ăn thức ăn" << endl;
    }
};
class Cho : public DongVat {
public:
    string tenRieng = "Chó";

    void sua() {
        cout << tenRieng << " đang sủa 'Gâu Gâu '." << endl;
    }
    void hanhDong() {
        cout << tenRieng << " thuộc loài " << tenChung << "." << endl;
        an(); 
        sua();
    }
};

int main() {
    cout << "kết quả" << endl;
    Cho c;
    c.hanhDong(); 
    
    return 0;
}