#include <iostream>
using namespace std;

struct A {
    char c;
    int x;
    double d;
};

struct B {
    int x;
    char c;
    double d;
};

int main() {
    cout << "Size A = " << sizeof(A) << " byte\n";
    cout << "Size B = " << sizeof(B) << " byte\n";
    return 0;
}
