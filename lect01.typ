= Lecture 1

== C++ Intro

=== C++ Workflow
Source Code (`*.cpp`) $==>$ Compiler (`gcc`) ผ่าน Code::Blocks $==>$ Executable File (`*.exe`)

=== Hello World
```cpp
#include <iostream>

int main() {
  std::cout << "Hello, CP!" << std::endl;
  return 0;
}
```


== C++ from Java & Python

=== ตัวแปร
- ต้องประกาศ
- ต้องระบุประเภท
- ตัวแปร โดยปรกติเป็น "กล่อง" ที่เก็บข้อมูล ไม่ใช่ของที่ "อ้างถึง" ข้อมูล

```cpp
#include <iostream>

using namespace std;

int main() {
  int x;
  x = 10;
  bool y = true;
  cout << y << endl;
  cout << (x+20) << endl;
  // x = y; // ไม่ได้
}
```

== C++, if, for, while, function

=== If
- ต้องมีวงเล็บ ตรงเงื่อนไข
- ใช้ `{}` เป็นตัวระบุ suite (ใน c++ เรียก block)
- ไม่มี `elif` ต้องใช้ `else if`

```cpp
int main() {
  int age;
  cout << "Please enter your age:";
  cin >> age;
  if ( age < 5 ) {
    cout << "You are a kid!\n";
  } else if ( age < 100 ) {
    cout << "You are not old!\n";
  } else {
    cout << "You live long!\n";
  }
  return 0;
}
```

=== For loop
- เหมือน Java
- ประกอบด้วย 3 ส่วน
  - initial
  - condition
  - iteration

```cpp
#include <iostream>

using namespace std;

int main() {
  for (int i=0; i < 10; i++) {  // i = i + 1
    cout << "i = " << i << endl;
  }
  return 0;
}
```

=== While loop
```cpp
int main() {
  int x = 0;
  while ( x < 10 ) {
    cout << "x = " << x << endl;
    x++;
  }
  return 0;
}

int main() {
  int x = 20;
  do {
    x--;
    cout << x << endl;
  } while ( x > 10 )
}
```

=== Function
- Pass by value vs pass by reference

```cpp
void pass_by_value(int x) {
  cout << "X is " << x << endl;
  x = 30;
}

void pass_by_reference(int &x) {
  cout << "X is " << x << endl;
  x = 40;
}

int main() {
  cout << "Pass by Value, direct" << endl;
  pass_by_value(10);  // X is 10
  cout << endl;

  int x = 20;
  cout << "Pass by value, variable" << endl;
  pass_by_value(x);  // X is 20
  cout << "outside PbV function x = " << x << endl;  // 20
  cout << endl;

  cout << "Pass by reference" << endl;
  pass_by_reference(x);  // X is 20
  cout << "outside PbR function x = " << x << endl; // 40

  // the following line cannot be compiled
  // because we need reference
  // pass_by_reference(20);
}
```
