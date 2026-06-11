#include <iostream>
using namespace std;

void byValue(int a) {
    a += 5;
}

void byReference(int &a) {
    a += 5;
}

void byPointer(int *a) {
    *a += 5;
}

int main() {
    int x = 10, y = 10, z = 10;

    byValue(x);
    cout << "Sau byValue, x = " << x << endl;

    byReference(y);
    cout << "Sau byReference, y = " << y << endl;

    byPointer(&z);
    cout << "Sau byPointer, z = " << z << endl;

    return 0;
}
