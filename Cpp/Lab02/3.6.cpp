#include <iostream>
using namespace std;

int g = 100; 

void testStatic() {
    static int s = 0; 
    s++;
    cout << "Static s = " << s << endl;
}

int main() {
    int x = 10; 
    cout << "Global g = " << g << endl;
    cout << "Local x = " << x << endl;

    for (int i = 0; i < 2; i++) {
        int y = i; 
        cout << "y = " << y << endl;
    }

    testStatic();
    testStatic();

    int *p = new int(50); 
    cout << "Dynamic *p = " << *p << endl;
    delete p;

    return 0;
}
