#include <iostream>
#include <string>
using namespace std;

class DongVat {
public:
    virtual void tiengKeu() {
        cout << "Động Vật phát ra âm thanh." << endl;
    }
};
class Meo : public DongVat {
public:
    void tiengKeu() override { 
        cout << "Mèo kêu 'Meo Meo'." << endl;
    }
};
class Vit : public DongVat {
public:
    void tiengKeu() override { 
        cout << "Vịt kêu 'Quạc Quạc'." << endl;
    }
};
void goiKeu(DongVat* dv) {
    dv->tiengKeu(); 
}
int main() {
    cout << "kết quả" << endl;
    Meo meoCon;
    Vit vitCon;
    goiKeu(&meoCon);
    goiKeu(&vitCon);

    return 0;
}