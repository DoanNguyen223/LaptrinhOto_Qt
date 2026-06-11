#include <iostream>
using namespace std;

struct MyStruct {
    int a;
    float b;
    char c;
};

union MyUnion {
    int a;
    float b;
    char c;
};

int main() {
    cout << "Size Struct = " << sizeof(MyStruct) << " byte\n";
    cout << "Size Union  = " << sizeof(MyUnion) << " byte\n";

    MyUnion u;
    u.a = 10;
    cout << "Union a = " << u.a << endl;
    u.b = 3.14f;   
    cout << "Union b = " << u.b << endl;
    u.c = 'X';
    cout << "Union c = " << u.c << endl;

    return 0;
}
