= Lecture 3

== std::pair

=== Basic
```cpp
#include <iostream>

int main() {
  std::pair<int,float> x;
  std::pair<int,float> y;

  x.first = 10;
  x.second = 20.65;

  std::cout << x.first << " "; // 10
  std::cout << x.second << std::endl; // 20.65

  y = x;

  std::cout << y.first << std::endl; // 10
  std::cout << y.second + 20 << std::cout; // 40.65
}
```

Pair reserves 2 spaces in RAM for `first` and `second` elements.
When you use `y = x`, it copies values of `x` to `y`. You need to build template by specifying data types in a pair.

=== Initialize
```cpp
#include <iostream>

int main() {
  // default constructor
  std::pair<std::string,bool> p; // default of that type: {"", false}
  std::cout << "default [" << p.first "] [" << p.second << "]" << std::endl;

  // initialize by { }
  std::pair<std::string,bool> p1 = { "somchai", true };

  // create pair without specifying type by "make_pair"
  std::pair<bool,int> p2;
  p2 = std::make_pair(false,10);

  std::pair<bool,int> p3(p2); // must be same type p3 = p2

  // more complex pair
  std::pair< std::pair<float,int>, std::string >  p4 = { {20.5, -3}, "abc"};
  std::cout << p4.first.first << " " << p4.first.second << " " << p4.second << std::endl; // 20.5 -3 abc
}
```

=== Array inside Pair
```cpp
#include <iostream>

int main() {
    std::pair<std::string*,std::pair<int, float>> p;

    p.first = new std::string[5];
    p.first[0] = "a";
    p.first[1] = "b";
    p.first[2] = "c";

    p.second = std::make_pair(10,1.5);

    std::cout << p.first[0] << " " << p.second.first << " " << p.second.second;
}
```

== Template
- Template allows "same code, different data types"
- `std::pair` is a "class template"
  - In generic term, pair is defined as `pair<T1, T2>`
- To use `std::pair`, we must supply "Type information" to the template what `T1` and `T2` should be.

=== STD and Namespace
- The "Fullname" of `cout` is `std::cout`
- `std` is a namespace
- We need to use fullname
  - Too lazy? use "`using`" keywords

```cpp
#include <iostream>

// this tells C++ that when we say cout, we mean std::cout;
using std::cout;

int main() {
  // we still need to use std::endl
  cout << "Yes" << std::endl;
}
```

```cpp

#include <iostream>

// this tells C++ that when we say something that is does not understand, C++ should try to use std as its namespace

// this is VERY BAD PRACTICE in real world.
// 10/10 not recommend
// ... but it's ok for this class
using namespace std;

int main() {
  cout << "Yes" << endl;
}
```

== std::vector
A linear storage of a single data type

=== Basic
```cpp
#include <iostream>
#include <vector>

using namespace std;

int main() {
  vector<int> v1;
  cout << "Size of v1 is " << v1.size() << endl; // 0

  vector<int> v2 = {2,3,4};

  cout << v2[1] << endl; // 3
  v1 = v2;
  v1[0] = 20;

  cout << v1[0] << ", " << v1[1] << v1[2] << endl; // 20, 3, 4

  v1.push_back(99);
  cout << v1.size() << endl;
}
```
- Vector starts with empty element
- Use `size()` to get the number of element
- Use `empty()` to check if a vector has any element

=== Initialize
- With specific size
- With specific size and starting value
```cpp
#include <iostream>
#include <vector>

using namespace std;

void print_vector(vector<float> v) {
  for (size_t i = 0; i < v.size(); i++) {
    cout << v[i] << " ";
  }
  cout << endl;
}

int main() {
  vector<float> v1(10); // size = 10
  print_vector(v1);

  vector<float> v2(5,3.55); // size = 5, default = 3.55
  print_vector(v2);

  vector<float> v3(v2);
  print_vector(v3);
}
```

== Vector Access & Overflow Problem

=== Access

```cpp
#include <iostream>
#include <vector>

using namespace std;

int main() {
  vector<float> v1(2);
  vector<float> v2(2);

  cout << "-- v1 --" << endl;
  for (int i = 0; i < 7; i++) {
    v1[i] = i; // this automatically assigns value
    cout << i << ": " << v1[i] << endl; // print nonsense if out of range
  }
  cout << "-- v2 --" << endl;
  for (int i = 0; i < 7; i++) {
    cout << i << ": " << v2[i] << endl; // print "4 5 6" due to buffer overflow (take space of v1)
  }
  cout << "using at" << endl;
  v2.at(1) = 99;
  // this will cause exception 'std::out_of_range'
  for (int i = 0; i < 7; i++) {
    cout << ": " << v2.at(i) << endl;
  }
}
```

- Operator `[]` won't check for 'out-of-range'
  - Reading, writing beyond size is undefined
  - Might crash
  - Grader will give 'x'
- at `()` will check bound
  - But slower

You should be careful of using spaces, it can access illegal memories and cause weird behaviors.

== Modifying Vector

=== Resizing
- Resize change the size
  - Enlarge will fill with default

```cpp
#include <iostream>
#include <vector>

using namespace std;

void print(vector<int> v) {
  cout << "Size of V is " << v.size() << ":";
  for (int i = 0; i < v.size(); i++) cout << v[i] << ", ";
  cout << endl;
}

int main() {
  vector<int> v(3,10);
  print(v); // 10,10,10,
  v.resize(6);
  print(v); // 10,10,10,0,0,0,
  v.resize(1);
  print(v); // 10,
  v.resize(7);
  print(v); // 10,0,0,0,0,0,0
}
```

=== Modify
- `pop_back`
  - Erase last element
- `insert(position,value)`
- `erase(position)`
- Careful!
  - Both insert and erase position must be valid
  - If not vald, it can crash

```cpp
#include <iostream>
#include <vector>

using namespace std;

void print(vector<int> v) {
  cout << "Size of V is " << v.size() << ": ";
  for (int i = 0; i < v.size(); i++) cout << v[i] << ", ";
  cout << endl;
}

int main() {
  vector<int> v(3,8); // v.begin() is called iterator
  v.insert( v.begin(), 1);   // 1, 8, 8, 8
  v.insert( v.begin()+3, 2); // 1, 8, 8, 2, 8
  v.insert( v.end(), 3);     // 1, 8, 8, 2, 8, 3
  print(v);
  v.erase(v.begin());         // 8, 8, 2, 8, 3
  v.erase(v.begin()+2);      // 8, 8, 8, 3
  print(v);
  v.pop_back();              // 8, 8, 8
  print(v);
}
```

== std::find & std::sort

=== Find
- `find(a,b,c)`
  - `a` and `b` are position (iterator)
  - find `c` from `a` to _before_ `b`
  - if not found `return b`
- Must `#include <algorithm>`

```cpp
#include <iostream>
#include <vector>
#include <algorithm>

using namespace std;

int main() {
  vector<int> v = {9,-1,3,7,5,2,1,4};

  int x = 5;
  if ( find(v.begin(), v.end(), x) != v.end() ) {
    cout << "found" << endl;
  } else {
    cout << "not found" << endl;
  }

  if (find(v.begin(), v.begin()+3, 3) != v.begin()+3) cout << "FOUND" << endl;

  // How many "YES" will be printed? (CHEAT QUESTION)
  if (find(v.begin()  , v.begin()+2, x) != v.end()) cout << "YES" << endl; // YES
  if (find(v.begin()  , v.begin()+4, x) != v.end()) cout << "YES" << endl; // YES
  if (find(v.begin()+4, v.begin()+2, x) != v.end()) cout << "YES" << endl; // YES
  if (find(v.begin()+4, v.begin()+8, x) != v.end()) cout << "YES" << endl; // YES
  // First 3 can't even give v.end(), last did find so it gave that position instead
}
```

=== Sort
```cpp
#include <iostream>
#include <vector>
#include <algorithm>

using namespace std;

void print(vector<int> v) {
  cout << "Size of V is " << v.size() << ": ";
  for (int i = 0; i < v.size(); i++) cout << v[i] << ", ";
  cout << endl;
}

int main() {
  vector<int> v = {9,-1,3,7,5,2,1,4};

  print(v);  // 9, -1, 3, 7, 5, 2, 1, 4,
  sort(v.begin()+2, v.begin()+6);
  print(v);  // 9, -1, 2, 3, 5, 7, 1, 4,
}
```

=== Functions that Work with Vector
- `sort`
- `find`
- `min_element`
- `max_element`
- `lower_bound`
- `upper_bound`
Need to use _iterator_
