= Lecture 5

== Stack

=== การเพิ่ม/ลบข้อมูลในกองซ้อน
- ข้อมูล เข้าหลัง ออกก่อน (Last_In First-Out)

=== กองซ้อน : stack
```cpp
    bool            empty();
    unsigned        size();
    T               top();           // ดูบนสุด
    void            push(T element); // ใส่ข้อมูล
    void            pop();           // เอาออก
```

=== ข้อควรระวัง
- ใช้ `#include <stack>`
- `top()` ตอนไม่มีข้อมูล $->$ พัง
- `pop()` ตอนไม่มีข้อมูล $->$ พัง
- stack ไม่มี iterator
  - ดูได้เฉพาะข้อมูลที่เพิ่งใส่เข้าไปล่าสุด (`top`)
  - ไม่มี `begin()`, `end()` ให้ใช้
  - ถ้าอยากมาดูข้อมูลทุกตัวใน stack ต้องจำใจ `pop` ข้อมูลออกมา

=== ตัวอย่างการใช้งาน Stack
- การตรวจสอบโครงสร้างแบบซ้อนกัน เช่น การใส่วงเล็บ `(){}[]`...
- การจัดเก็บตัวแปรและการทำ function calls
- การประมวลผลนิพจน์ทางคณิตศาสตร์ postFix $->$ Discrete Math
- การทำ undo/redo
- การค้นคำตอบแบบ depth-first search
- ...

== Parentheses Checking

=== การตรวจสอบการใส่วงเล็บ
- ถูก : `( { ( ) [ { } ] } )`
- ผิด : เปิดปิดไม่ตรงกัน `( `_`{ ]`_` )`
- ผิด : มีปิดมากเกินไป `( { ( ) } ) `_`) }`_
- ผิด : มีเปิดมากเกินไป _`(`_` { ( ) }`

#list[
  วิธีทำ
  - อ่านมาทีละตัว
  - ถ้าเป็นวงเล็บเปิด ให้ push ลง stack
  - ถ้าเป็นวงเล็บปิด ให้ pop จาก stack มาตรวจสอบว่าเป็นวงเล็บเปิดที่ตรงกันกับวงเล็บปิดหรือไม่
  - เมื่อใดที่อยาก `pop` ถ้า `isEmpty` แสดงว่า ปิดมีมากไป
  - เมื่ออ่านเสร็จหมด stack ยังมีข้อมูล แสดงว่า เปิดมีมากไป
]

== Function Call Stack

=== Using Stack in Java Virtual Machine

- jvm uses java stack to store
  - state of method calls
  - parameters and local variables
  - temporary memory for computation (operand stack)

```java
public class StackFrame {
  public static void main(String[] args) {
    a(3,2);
    b(5);
  }
  static void a(int x, int y) {
    int z = x/y;
    b(z);
  }
  static void b(int x) {
    ++x;
  }
}
```

We make a stack frame of function calls, each element consists of arguments and returning argument of the function.
Function `main` contains `args` and RA `JVM` and calls `a`, `a` will be added to stack and contains `z, y, x`, and RA `04:`, then it calls `b`.
After `b` is finished, it will come back to line `9` and popped itself. It will do `a` and go to line `4`, and so on.
Arguments in each functions are separated variables.

```cpp
#include <iostream>

using namespace std;

void test(int x) {
  if (x > 0) {
    int y = x-1;
    cout << "I am test(" << x << "). continue... " << endl;
    test(y);
    cout << "now x is " << x << endl;
  } else {
    cout << "I am test(0). stop"
  }
}

int main() {
  test(4);
  return 0;
}
```

*Output*
```
I am test(4). continue...
I am test(3). continue...
I am test(2). continue...
I am test(1). continue...
I am test(0). stop
now x is 1
now x is 2
now x is 3
now x is 4
```

== Postfix Evaluation

=== Infix and Postfix Expressions
- infix (เติมกลาง)
  - `a + b * c / d - 2`, `(a + b) * c / (d - 2)`
  - use order of operations
  - use parentheses
- postfix (เติมหลัง)
  - `a b c * d / + 2 -`, `a b + c * d 2 - /`
  - order is from left to right
  - parentheses may be omitted

```
    1   2   +   3   *   4   1   -   /
            3   3   *   4   1   -   /
                    9   4   1   -   /
                    9           3   /
                                    3
```

=== Calculate Postfix Expressions with Stack
- Value of ` 2 3 + 4 5 - 6 * + ` ?
- Use stack to help
- Solution
  - Check each element in postfix from left to right
  - If it is operand, `push` stack
  - If it is operator, `pop` elements from stack as many as operator needs, then `push` the result
  - After complete, answer will be at the top of stack

== Convert Infix to Postfix

=== Use Stack to Convert
- input : infix expression
- output : postfix expression
- Steps
  - Read each element in infix
  - If it is operand, move it to the back of output
  - If it is operator
    - May `pop` operator to the end of output
    - `push` operator to stack
  - If all infix is read
    - `pop` all operators to the end of input

```cpp
string infix2postfix(string &infix) {
  int n = infix.length();
  string postfix = "";
  stack<char> s;
  for (int i=0; i<n; i++) {  // Read each element
    char token = infix[i];
    if (token เป็น operand) {
      postfix += token;  // if operand, add to output
    } else {
      while ( ???? ) {
        postfix += s.top();  // if operator, pop stack to result,
        s.pop();
      }
      s.push(token);         // then push new operator
    }
  }
  while (!s.empty()) {postfix += s.top(); s,pop();}
  return postfix;
}
```

=== Priority of Operators

```
input   2   *   3   +   4

read     output     stack
 2
 *          2
 3          2         *
 +         2 3        *   (* comes before and is more important than +)
 4        2 3 *       +
         2 3 * 4      +
        2 3 * 4 +
```

```
input   2   +   3   *   4

read     output     stack
 2
 +          2
 3          2         +
 *         2 3        +
           2 3       * +
          2 3 *       +
         2 3 * +
```

=== Code to Compare Priority
```cpp
string infix2postfix(string &infix) {
  int n = infix.length();
  string postfix = "";
  stack<char> s;
  for (int i=0; i<n; i++) {
    char token = infix[i];
    if (priority.find(token) != priority.end()) {
      postfix += token;
    } else {
      int p = priority[token];  // Get priority of the new operator
      while ( !s.empty() && priority[s.top()] >= p ) {  // lazy evaluation; left first
        postfix += s.top();  // pop if top operator is not less important than new op
        s.pop();
      }
      s.push(token);
    }
  }
  while (!s.empty()) {postfix += s.top(); s,pop();}
  return postfix;
}
```

== Lazy Evaluation

=== Setting Priority of Operators
- `^` represents power `7`
- `^` before `+ - * /`
- `* /` before `+ -`
- `*` same as `/` `5`
- `+` same as `-` `3`

```cpp
map<char,int> priority =
    {{'+',3},{'-',3},{'*',5},{'/',5},{'^',7}};
```

=== Complications with Parentheses

- In parentheses is like sub-expression
- Open parentheses always push (very high priority)
- Close parentheses is very low priority
- If found, `pop` until sees open parentheses

```
input   2   *   (   3   +   4   )

read     output     stack
 2
 *          2
 (          2         *
 3          2        ( *
 +         2 3       ( *
 4         2 3      + ( *
 )        2 3 4     + ( *  (pop all)
        2 3 4 + *
```

```cpp
int p = priority[token];
while ( !s.empty() && priority[s.top()] >= p ) {
  postfix += s.top();
  s.pop();
}
s.push(token);

int p = outpriority[token];
while ( !s.empty() && inpriority[s.top()] >= p ) {
  postfix += s.top();
  s.pop();
}
if (token == ')') s.pop(); else s.push(token);
```

=== Priority of Operators with Parentheses
#table(
  columns: 2,
  [], [` +  -  *  /  ^  (  ) `],
  [In expression], [` 3  3  5  5  7  9  1`],
  [In stack], [` 3  3  5  5  7  0`],
)

=== Right to Left Operator
#table(
  columns: 2,
  [], [` +  -  *  /  ^  (  ) `],
  [In expression], [` 2  2  4  4  8  9  1`],
  [In stack], [` 3  3  5  5  7  0`],
)
/ Note: Power in expression is more important than in stack

```
input   2   +   3   -   4   ^   5   ^   6

read     output     stack
 2
 +          2
 3          2         +
 -         2 3        +
 4        2 3 +       -
 ^       2 3 + 4     ^ -
 5       2 3 + 4     ^ -
 ^      2 3 + 4 5    ^ -
 6      2 3 + 4 5   ^ ^ -
       2 3 + 4 5 6  ^ ^ -
    2 3 + 4 5 6 ^ ^ -
```

=== Conclusion
- Implementations of stack to solve problems
- Main operations: `push` / `pop` / `top`
- Make stack with array
- If reserve enough space, all runs is $Theta(1)$; constant time
