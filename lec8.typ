= Lecture 8

== Create Your Own CP::pair

=== Intro
- We start writing our own data structure
  - In our own _namespace_ (CP)
- We start with _pair_
  - Good introduction on writing a class
  - Some C++ feature we need to use
    - const
    - pass-by-value, pass-by-ref
    - Header file

=== What should we write in a class
- Class name and namespace
- Member _variables_ which define what data we want to stop in the class
- Member _functions_ which define behavior of the class and how member variable is manipulated
  - Include lots of special function such as _constructor_, _destructor_, _overloading_

=== CP:pair version 0.1 (minimal version)
- Templating
  - Parameter of a code
- No member functions
  - When we declare a pair, `T1` and `T2` must be declared as a type

```cpp
namespace CP {
  template <typename T1, typename T2>
  class pair{
    public:
      T1 first;
      T2 second;
  };
}

int main() {
  CP::pair<int,string> p1;  // In p1, T1 is int, T2 is string
  CP::pair<bool,int> p2;    // In p2, T1 is bool, T2 is int
}
```

=== Capabilities
- Can hold 2 pieces of data
- Can use template
- Works with operator `=`
- Has copy constructor
#text(fill: red)[
  - Cannot check equal
  - Cannot check less than
]

```cpp
#include <iostream>
#include <string>
using namespace std;
namespace CP {
  template <typename T1, typename T2>
  class pair{
    public:
      T1 first;
      T2 second;
  };
}

int main() {
  CP::pair<int,string> p1, p2;  // default ctor
  p1.first = 20; p1.second = "somchai";
  CP::pair<int,string> a(p1);   // copy ctor
  p2 = p1;

  cout << p2.first << "," << p2.second << endl;
}

/*
if (p1 == p2) { // won't compile
  cout << "yes" << endl;
}

if (p1 < a) { // won't compile
  cout << "yes" << endl;
}
*/
```

=== CP::pair version 0.2 (comparator overload)
```cpp
#include <iostream>
#include <string>
#include <set>
using namespace std;
namespace CP {
  template <typename T1, typename T2>
  class pair{
    public:
      T1 first;
      T2 second;

      // operator
      bool operator==(const pair<T1,T2> &other) {
        return (first == other.first && second == other.second);
      }

      bool operator<(const pair<T1,T2>& other) const {  // operator< must be const
        return ((first < other.first) ||
                (first == other.first && second < other.second));
      }
  };
}

int main() {
  CP::pair<int,string> p1, p2;  // default ctor
  p1.first = 20; p1.second = "somchai";
  CP::pair<int,string> a(p1);   // copy ctor
  p2 = p1;
  cout << p2.first << "," << p2.second << endl;  // 20, somchai

  if (p1 == p2) {cout << "yes" << endl;}  // yes
  if (p1 < a) {cout << "yes" << endl;}
  set<CP::pair<int,int>> s;
  s.insert({1,2});
  // Now we can compare and use less than (and also set, map, priority queue)
  cout << s.begin()->second << endl;  // 2
}
```

== Const Member

=== Const Parameter in Function
```cpp
void test(int &x, const int& y) {
  x++;                // Okay; doable
  cout << y << endl;  // Okay, we only read y
  for (int i=0; i<y; i++) { // Okay, too
    cout << i << endl;
  }
  y--;  // ERROR: we promised NOT to change y
}
```

- Declared by putting a keyword const as a prefix
- Const parameter must not be modified inside the function
- Why? So that we know that the function does not modify the data
  - Especially when we pass-by-reference

=== Difference of Pass-by-reference && Pass-by-value

*Pass-by-value*
- The _arguments_ can be either constants or variables
- Modifying _parameters_ (variable inside the function) does not change the _argument's_ value
- The _argument's_ value is copied to the parameter
  - #text(fill: red)[SLOWER!!!] Because we have to copy

*Pass-by-reference*
- The _arguments_ must be variables
- The _parameters_ are the argument's variables
  - Modify the _parameter_ also modify the _argument's_ variable
- #text(fill: red)[Faster]

=== Const Member Function
```cpp
class ccc {
public:
  int a,b;

  void inspect() const {  // This function promises NOT to change anything
    if (a < b) cout << "yes" << endl;  // Okay

    // b += 20;  // <-- NOT OKAY
  }

  void mutate() {  // This function might change something
    if (a < b) a += 10;  // Okay
  }
};

void test2(ccc& changeable, const ccc& unchangeable) {
  changeable.inspect();
  changeable.mutate();
  unchangeable.inspect();
  unchangeable.mutate();  // ERROR: attempt to change unchangeable object
}
```

- Declared by putting a keyword `const` after the function declaration
- Const member function cannot modify any member data
  - Also cannot call any other function that is not const
- Why? So that we know that the function does not modify its data

== Constructor & List Initialization

=== Custom Constructor
- In STL spec of std::pair, it has custom constructor called _intialization constructor_

```cpp
namespace CP {
  template <typename T1, typename T2>
  class pair{
    public:
      T1 first;
      T2 second;

      // Custom constructor, using initialization list
      pair(const T1 &a, const T2 &b) {
        first = a;
        second = b;
      }
      // When we have a constructor, a default constructor is not auto-generated

      // Operator
      bool operator==(const pair<T1,T2> &other) {...}
      bool operator<(const pair<T1,T2>& other) {...}
  };
}

int main() {
  CP::pair<int, bool> p(10,false);
  CP::pair<string, int> q("abc",42), r("",0);

  cout << (q < r) << endl;  // 0
  priority_queue<CP::pair<string,int>> pq;
  pq.push(r);
  pq.push(q);
  cout << pq.top().first << endl;  // abc

  CP::pair<string, int> x(q);
  CP::pair<string, int> y = x;

  // All below cannot be compiled
  // CP::pair<string, int> w;
  // vector<CP::pair<int, int>> v(10);
}
```

=== Initialization List
- Instead of writing a code to assign a value to each member, we can use _intialization list_
  - A little bit shorter code
  - Also little bit faster
  - Only way to init _const_ member

```cpp
namespace CP {
  template <typename T1, typename T2>
  class pair {
    public:
      T1 first;
      T2 second;

      // custom constructor, using initialization list
      pair(const T1 &a, const T2 &b) : first(a), second(b) { }
  };
}
```

=== Default Constructor
- A constructor used when we simply declare an object
- Auto-generated by init all members with its default constructor
- Won't be auto-gen if we have any other constructor

```cpp
namespace CP {
  template <typename T1, typename T2>
  class pair {
    T1 first;
    T2 second;

    // Constructor
    pair() : first(), second() { }
    pair(const T1 &a, const T2 &b) : first(a), second(b) { }
  };
}
```

== Include & Header file

=== Include File
- Usually, our data structure (which is written as a class) will be used by several programs in several files.
  - It is better NOT TO copy our data structure code into each each file
- Rather, put our code in a file and include it where it is needed
  - Better if we want to change it
  - Better compilation
- Introducing ".h" files

=== C++ header file (.h) and `#include`
- To put a content of one file into another file, we use `#include "filename"` keyword
- C++ will simply put the content of _filename_ into where we `#include` it
- `#include` has more benefit
  - Separation of _declaration_ (what it is) and _definition_ (how it works)
  - Not really explored in this class
- We usually use .h for a file that we will include but that is not a rule, we can use other extension

=== Problem with include

#grid(
  columns: (1fr, 1fr),
  [
    *a.h*
    ```cpp
    class a {
      int m1, m2;
    };
    ```
    *b.h*
    ```cpp
    #include "a.h"

    class b {
      a x;
    };
    ```
    *c.h*
    ```cpp
    #include "a.h"

    class c {
      a y;
    };
    ```
    *main.cpp*
    ```cpp
    #include "b.h"
    #include "c.h"

    int main() {
      b b1;
      c c1;
    }
    ```
  ],
  [
    *main.cpp (expanded)*
    ```cpp
    class a {
      int m1, m2;
    };

    class b {
      a x;
    };

    // There are multiple copies of class a
    class a {
      int m1, m2;
    };

    class c {
      a y;
    };

    int main() {
      b b1;
      c c1;
    }
    ```
  ],
)

=== Fix problem
#grid(
  columns: (1fr, 1fr),
  [
    *a.h*
    ```cpp
    #ifndef A_H
    #define A_H
    class a {
      int m1, m2;
    };
    #endif
    ```
    *b.h*
    ```cpp
    #include "a.h"

    class b {
      a x;
    };
    ```
    *c.h*
    ```cpp
    #include "a.h"

    class c {
      a y;
    };
    ```
  ],
  [
    *main.cpp (expanded)*
    ```cpp
    #ifndef A_H
    #define A_H
    class a {
      int m1, m2;
    };
    #endif

    class b {
      a x;
    };

    // class a here is taken out of
    // compilation because A_H is defined
    #ifndef A_H
    // #define A_H
    // class a {
    //   int m1, m2;
    // };
    #endif

    class c {
      a y;
    };

    int main() {
      b b1;
      c c1;
    }
    ```
  ],
)

=== Summary
*Major*
- #text(fill: purple)[Templating]: allow user to write a code that works with different data type
- #text(fill: green)[Constructor]: a function called when we create a variable
  - Default constructor
- #text(fill: orange)[Operator overloading]: for less-than and equality
- pass-by-ref vs pass-by-value

*Minor*
- Header file
- const
- List initialization

=== Exercise (no grader)
+ Modify `operator<` so that it compare _second_ before _first_
+ Modify `operator<` so that when we call `sort(v.begin(),v.end())` where `w` is a vector of our pair, it is sorted from _Max_ to _Min_
+ Write `operator!=` and `operator>=`

*Final version CP.h*
```cpp
#ifndef _CP_PAIR_INCLUDED_
#define _CP_PAIR_INCLUDED_

namespace CP {
  template <typename T1, typename T2>
  class pair {
    public:
      T1 first;
      T2 second;

      pair() : first(), second() {}

      pair(const T1 &a, const T2 &b) : first(a), second(b) { }

      bool operator==(const pair<T1,T2> &other) {
        return (first == other.first && second == other.second);
      }


      // 1.
      bool operator<(const pair<T1,T2>& other) const {
        return ((second < other.second) ||
                (second == other.second && first < other.first));
      }

      // 2.
      bool operator<(const pair<T1,T2>& other) const {
        return ((first > other.first) ||
                (first == other.first && second > other.second));
      }

      // 3.
      bool operator!=(const pair<T1,T2>& other) const {
        return !(*this == other);
      }

      bool operator>=(const pair<T1,T2>& other) const {
        return !(*this < other);
      }

  };
}
#endif
```
