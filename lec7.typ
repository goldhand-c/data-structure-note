= Lecture 7

== Priority Queue
Queue with privilege

=== Intro
- Priority Queue is ...
  - A queue with priority
  - Item with high priority is promoted to the front of the queue
    - There is _no back of the queue_
  - Priority is defined by having more value
    - Comparison, by default, is to use `operator <`, i.e., if item `A < B` is `true`, then `B` _has higher priority_
    - We can have custom comparator
- Has the _same interface_ as stack

=== Example

For intuitive purpose only! This is not really how priority_queue work internally
```
push(10)
  < 10         >

push(30)
  < 30 10      >

push(20)
  < 30 20 10   >

pop()
  < 20 10      >

push(15)
  < 20 15 10   >
  |
 top
```


=== Basic
```
size_t       q.size()
bool         q.empty
void         q.push()
void         q.pop()
T            q.top()
* there is no q.back()
```

=== Limitation
- Same limitation as stack, queue
  - _no iterator_
    - No `begin(), end()`
    - Use `#include <queue>`
    - Can only access `top()` of the queue
    - If we wish to access all members, we have to pop it all
  - Do not call `top(), pop()` when the queue is empty
- The data type must be _comparable_ (similar to set and map)

== Class

=== Quick Summary
- Syntax
  - class declaration must end with `;`
  - Function definition can be outside of the class
  - Access modifier is `public:, private:, protected:`
  - Constructor is a function with the same name of the class with no return type
- Object is a variable (instantiation) of a class
  - When declared, a constructor is called

=== Example 1
```cpp
#include <iostream>
#include <string>
using namespace std;

class Student {
public:
  void setFullName(string name, string surname) {
    this->name = name;
    this->surname = surname;
  }
  string getFullName() {
    return "[" + name + " " + surname + "]";
  }
private:
  string name, surname;
};

int main() {
  Student a;
  Student b;
  a.setFullName("nattee", "niparnan");
  cout << a.getFullName() << endl;
  cout << b.getFullName() << endl;
}
```

Declaring class before writing functions

```cpp
class Student {
public:
  void setFullName(string name, string surname);
  string getFullName();
private:
  string name,surname;
};

void Student::setFullName(string name, string surname) {
  this->name = name;
  this->surname = surname;
}

string Student::getFullName() {
  return "[" + name + " " + surname + "]";
}
```

*Output*
```
[nattee niparnan]
[ ]
```

=== Example 2: Constructor
```cpp
#include <iostream>
#include <string>
using namespace std;

class Student {
public:
  Student(float score) {gpax = score;}
  void setFullName(string name, string surname) {
    this->name = name;
    this->surname = surname;
  }
  string getFullName() {return "[" + name + " " + surname + "]";}
  bool is1stHonor() {return gpax >= 3.6;}
private:
  string name, surname;
  float gpax;
};

int main() {
  Student a(2.95);
  a.setFullName("nattee", "niparnan");

  cout << a.getFullName() << endl;
  if (a.is1stHonor()) {cout << "YES" endl;} else {cout << "NO" << endl;}
  // Student b; // <-- cannot compile beacuse there is no default constructor
}
```

== Operator Overloading
How C++ has a function for each operator

=== Overview
- Let say we write `a + b` when `a` and `b` is an object of some classes
  - This can be considered the same as calling a function `plus(a,b)`
  - C++ allows us to write a function for many operator and use it as an operator
  - For example we can write a function `times(a,b)` and let it be used as `a * b`
- This is what we called operator overloading

Instead of writing
```cpp
Matrix multiply(Matrix a1, Matrix a2) {
  multiply(a, multiply(b,c))
}
```

We want to write
```cpp
Matrix a, b, c
a * (b * c)
```

=== Example
```cpp
#include <queue>
#include <iostream>
#include <string>

using namespace std;

// use operator + symbol that will be overloaded
string operator*(string & lhs, const int & rhs) {
  string result = "";
  for (int i=0; i<rhs; i++) {
    result = result + lhs;
  }
  return result;
}


int main() {
  string a = "abc ";
  cout << (a * 3) << endl; // this gives "abc abc abc "
}
```

- Function must be named operator followed by the operator that we will overload
- Some operator takes two parameters (such as `+, -, *, /, %`)
- Some takes one (such as `++, --, !, *, &`)

== Overloading less-than operator

=== Using with data structure that require sorting
- We have seen several data structure that requires comparability of the data, such as set, map and priority queue
- If we want to use our class with these data structure, we need to tell them how can we use them
- There are multiple ways to achieve this
  - Let us consider operator overloading

== Overloading `<`
- As stated earlier, set, map, and priority_queue use _operator_ `<` to compare two elements
- It does not work if we overload _operator_ `>`

```cpp
class Student {
public:
  Student(float score, string a, string b) {
    name = a;
    surname = b;
    gpax = score;
  }
  bool is1stHonor() {return gpax >= 3.6;}
  // not good, now our data is public
  string name, surname;
  float gpax;
  // overloading <
  bool operator<(const Student & other) const {
    return gpax < other.gpax;
  }
};

int main() {
  Student a(2.95,"nattee","niparnan");
  Student b(4.00,"attawith","sudsang");
  cout << (a < b) << endl; // 1
  priority_queue<Student> pq;
  pq.push(a);
  pq.push(b);
  cout << pq.top().name << endl; // attawith
}
```

== Custom Comparator

=== Why custom?
- By overloading _operator_ `<`, we have defined default ordering of that class
- What if we need another ordering, just for this _priority_queue_ only
  - For example, _Student_ is ordered by _gpax_ by default
  - What if we want our priority_queue to order by name instead, while keeping the _Student_ default ordering elsewhere
  - Better, can we have multiple priority_queue with different ordering?
- Can be done via comparator class

=== Example
```cpp
#include <iostream>
#include <string>
#include <queue>
using namespace std;

class Student {...};

// Comparator class use () overloading
class StudentByNameComparator {
public:
  bool operator()(const Student& lhs,
                  const Student& rhs) {
    return lhs.name < rhs.name;
  }
};

class GpaxThenName {
public:
  bool operator()(const Student& lhs,
                  const Student& rhs) {
    if (lhs.gpax == rhs.gpax)
      return lhs.name < rhs.name;
    return lhs.gpax < rhs.gpax;
  }
};

int main() {
  Student a(2.95,"nattee","niparnan");
  Student b(4.00,"attawith","sudsang");
  Student c(4.00,"vishnu","kotrajaras");
  cout << (a < b) << endl;  // 1
  StudentByNameComparator comp1;
  GpaxThenName comp2;

  cout << comp1(a,b) << endl; // 0; can use like function

  // Use 3 template parameters
  priority_queue<Student,          // class to compare
                 vector<Student>,  // vector of that class
                 StudentByNameComparator> pq(comp1); // comparator class
  pq.push(a);
  pq.push(b);
  cout << pq.top().name << endl;  // nattee

  priority_queue<Student,
                 vector<Student>,
                 GpaxThenName> pq2(comp2);
  pq2.push(a);
  pq2.push(b);
  pq2.push(c);
  cout << pq2.top().name << endl;  // vishnu
}
```

=== Another Method, lambda-function
```cpp
#include <iostream>
#include <string>
#include <queue>
using namespace std;

int main() {
  auto compare = [](const string& lhs, const string& rhs) {
    return lhs.size() < rhs.size();
  };

  cout << "Result of compare function = " << compare("xxx","z") << endl;

  priority_queue<string,vector<string>,decltype(compare)> pq(compare);
  pq.push("somchai");
  pq.push("z");
  pq.push("abc");
  while (pq.empty() == false) {
    cout << pq.top() << endl;
    pq.pop();
  }
}
```

*Output*
```
Result of compare function = 0
somchai
abc
z
```

== Priority Queue Template

=== Templating of priority_queue
- `priority_queue` requires 3 template parameters
- `priority_queue<T, Container = vector<T>, Compare = less<T>>`
- The first one is required (which is the type of the data)
- The _second_ and the _third_ is optional (it has default type)
  - _Second_ is the container (for now, just don't think about it)
  - _Third_ is the class for comparator (the class that we use to compare)
    - This one is default to `less<T>`

```cpp
#include <iostream>
#include <string>
#include <queue>
using namespace std;

int main() {
  less<int> x;    // comparator that checks a < b
  greater<int> y; // checks a > b

  int a = 10;
  int b = 3;
  cout << x(a,b) << endl;  // 0
  cout << y(a,b) << endl;  // 1
}
```

=== Using Comparator for set and map
- To use custom class with set and map, we need to do the same thing, let set and map know how to sort the data
  - Either make default ordering (overload `<`) in the custom class
  - Or use custom comparator when declare
- For set, the declaration is `set<T, Compare = less<T>>`
- For map, the declaration is `map<Key, T, Compare = less<Key>>`

=== Assignment
- Is any of `vector<int>`, `set<int>`, `map<int,string>`, `queue<bool>`, `stack<vector<int>>` comparable?
  - For any class that is "YES", how it is ordered?
  - For example, if `vector<int>` is comparable, how `{1,2,3}` is compared to `{1,2,3,4}` or `{2,3,4}`

*Answer*
- `vector<int>` compare each element from the left; `{2,3,4} > {1,2,3,4} > {1,2,3}`
- `set<int>` compare the maximum element () of each set, if equal then look the next max
- `map<int,string>` compare by Key set, then compare max of value set
- `queue<bool>` is not comparable
- `stack<vector<int>>` is not comparable

== Summary

=== Data Structure Summary
#table(
  columns: (auto, 1.5fr, 2fr, 2fr),
  align: (left, left, left, left),

  // Header
  table.header([*Data Structure*], [*Pro*], [*Cons*], [*Remark*]),

  // pair
  [`pair<T1,T2>`],
  table.cell(colspan: 2, align: center)[Nothings... It just a pair of two data type],
  [],

  // vector
  [`vector<T>`],
  [
    - Fast access `[ ]`
    - Fast append $cal(O)(1)$
  ],
  [
    - Slow find $cal(O)(N)$
    - Slow insert, Slow Erase $cal(O)(N)$
  ],
  [],

  // set
  [`set<T>`],
  table.cell(rowspan: 2)[
    - Fast find $cal(O)(log(N))$
    - Item is sorted
  ],
  table.cell(rowspan: 2)[
    - Slower to just append data than vector, stack, queue $cal(O)(log(N))$
    - Iterate is also slow
    - Takes lots of memory $cal(O)(log(N))$
  ],
  [Require comparator],

  // map
  [`map<Key,T>`],
  [
    - Associative data type
    - Also require comparator of Key_Type
  ],

  // stack
  [`stack<T>`],
  table.cell(rowspan: 2)[
    - Very fast push, pop $cal(O)(1)$
  ],
  table.cell(rowspan: 2)[
    - Very limited functionality but has special uses
  ],
  table.cell(rowspan: 3)[
    - No iterator
    - Order of data coming out depends on something (stack, queue depends on WHEN it is pushed, `pq` depends on value)
    - `pq` requires comparator
  ],

  // queue
  [`queue<T>`],

  // priority_queue
  [`priority_queue<T>`],
  [
    - Fast get max
    - Fast delete max
    - Data is sorted
    - Memory efficient
  ],
  [
    - Slower to just append data than vector, stack, queue
    - Very limited functionality
  ],
)

=== More Data Structure
- C++ has more data structure not really covered right now
  - `list` is a vector with faster `input` / `erase` but does not have fast access
  - `unordered_set`, `unordered_map` are set and map that the data is not sorted but is much faster
  - `deque` is a queue that can `push`, `pop` at both ends
  - `multiset`, `multimap` are set and map that allows duplicated entries
