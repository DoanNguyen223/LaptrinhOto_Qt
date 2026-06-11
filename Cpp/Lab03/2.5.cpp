#include <iostream>
#include <string>
using namespace std;

class Ca {
private:
    int tuoi; 

public:
    string loai;
    Ca(string tenLoai, int soTuoi) {
        loai = tenLoai;
        tuoi = soTuoi; 
    }
    int layTuoi() {
        return tuoi; 
    }
    void tangTuoi() {
        tuoi++;
        cout << loai << " đã lớn thêm 1 tuổi." << endl;
    }
};

int main() {
    cout << "kết quả" << endl;
    Ca caVang("Cá Vàng", 1);
    cout << "Loài: " << caVang.loai << endl;
    cout << "Tuổi hiện tại: " << caVang.layTuoi() << " tuổi." << endl;

    caVang.tangTuoi(); 
    cout << "Tuổi sau khi tăng: " << caVang.layTuoi() << " tuổi." << endl;

    return 0;
}