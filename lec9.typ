= Lecture 9

== CP::vector
Our first "real" data structure

=== Intro
- Now we will create more complex data structure CP::vector
- It can store variable length array
  - Implemented as a dynamic array
- Can be accessed by `operator[]`
  - Additional operator to be overloaded
- We also have to create our own iterator
  - Implemented as a pointer

=== Key Idea
- Vector stored 3 things (3 member data)
  - #text(fill: orange)[mData]: A dynamic array, large enough space to store current data and might have reserved space
  - #text(fill: red)[mSize]: Number of data stored
  - #text(fill: green)[mCap]: Size of the dynamic array (maybe large than #text(fill: red)[mSize])
- If the dynamic array is full and more data is being added, we create a new dynamic array and relocate data to the new array
  - This is called #text(fill: blue)[expand]
  - Each #text(fill: blue)[expansion] takes very long time
- Dilemma
  - Large reserve = less often relocation but use more memory
  - Small reserve = more frequent relocation but less memory

=== Example
```
mSize  mCap       mData
  4     5    [10, 3, 1, 5, ]

push_back(9)

  5     5    [10, 3, 1, 5, 9]

push_back(4)

  6     10   [10, 3, 1, 5, 9, 4, , , , ]
```

=== How much reserve should we have?
- Whenever we need to relocate, we #text(fill: red)[double] the capacity that we currently have
- If we start with a vector with zero size and continuously add data one by one, for example by `push_back`
  - Each expansion will take time #text(fill: red)[equal] to #text(fill: green)[the number of data] when we relocate (this is very slow)
- By doubling the size every time we expand, we can show that on average, #text(fill: orange)[each addition of a data] (such as `push_back`, `insert`) #text(fill: purple)[takes constant time]!!!

== Pointer
How to implement a dynamic array (and also iterator)

=== Pointer & Memory
- Each variable is some block in computer memory
  - Programming language just map our #text(fill: green)[variable name] to that #text(fill: green)[block of memory]
  - Programming language works with the address of that block
- Pointer variable is a variable that stor #text(fill: red)[address of memory]
  - Pointer needs type i.e., address of int is not the same as address of bool
  - We can use operator `&` to ask for the #text(fill: purple)[address] of a #text(fill: blue)[variable]
  - We can use operator `*` to ask for the #text(fill: blue)[data] of an #text(fill: purple)[address]

=== Example
```cpp
int x, y;  // this is normal variable x and y
int *a;    // this is int pointer variable a
int *b;    // another int pointer

x = 10;    // say x is at address 3267
a = &x;    // a points to x
b = a;     // b also points to x
*b = 30;   // change the address value to 30
y = *b;    // set value of y to 30 (hard copy)

cout << &x << endl;  // 0x7ffee22885ac
cout << &y << endl;  // 0x7ffee22885a8  +4
cout << &a << endl;  // 0x7ffee22885a0  +8
cout << &b << endl;  // 0x7ffee2288598  +8
cout << sizeof(int) << endl;   // 4 bytes
cout << sizeof(*int) << endl;  // 8 bytes
```

=== Pointer Arithmetic
- Pointer can be added, subtracted by integer
  - It #text(fill: green)[moves the address by the size of the type] of the pointer
  - For example, when `X` is an int (which is 4 bytes) `X + 10` result in an address 40 bytes away from `X`
- Two pointers of the same type can be subtracted
  - The result is the address #text(fill: green)[difference divided by size of the type] of the pointer

```cpp
int main() {
  bool x, y, z;
  x = 1; y = 2; z = 3;
  bool *a, *b;

  a = &x;
  b = a+2;

  cout << "&x = " << &x << endl;  // &x = 0x6afed4
  cout << "&y = " << &y << endl;  // &y = 0x6afed8
  cout << "&z = " << &z << endl;  // &z = 0x6afedc
  cout << " a = " << a  << endl;  //  a = 0x6afed4
  cout << " b = " << b  << endl;  //  b = 0x6afedc
  cout << b-a << endl;            // 2
}
```

== Dynamic Array
- #text(fill: blue)[Dynamic Array] variable of type `T` is a #text(fill: purple)[pointer] to the #text(fill: blue)[starting address] of consecutive block of type `T`
- Let `A` be a dynamic array of int
  - `A[x]` refer to the $x^"th"$ block starting from `A`
- Static array works in the same way, that's why accessing `A[x]` is very fast for an array
  - It just refers to the address `A[x]` is `*(A + x * size_of(T))`

=== new and delete operator
- For a datatype `T`, `new T` _allocates_ a block with a size of `T` and then call a _constructor_ of `T`, return the address of that memory
- For a datatype `T`, `new T[n]` _allocates_ `n` blocks of `T` and then call a _constructor_ of `T` in each block, return the address of the first block
  - For example, we use `new int[10]` to create a dynamic int array of 10 elements
- For a pointer `X`, `delete X` calls the _destructor_ and then _de-allocates_ memory pointed by `X`
- For a dynamic array `X`, `delete [ ]` calls the _destructor_ of all blocks in the dynamic array and _de-allocates_ the memory allocated by `X`

=== Example
```cpp
class test {
public:
  // constructor
  test() : data() {cout << "created" << endl;}
  // destructor
  ~test() {cout << data << " destroyed " << endl;}
  int data;
};

int main() {
  test *a, *b;   // pointers of test

  a = new test;  // created new test pointed by a
  a->data = 10;  // (*a).data = 10
  cout << a->data << endl;  // 10
  delete a;      // destroyed

  b = new test[4];  // created 4x
  b[0].data = 10;
  b[1].data = 20;
  b[2].data = 30;
  b[3].data = 40;
  delete [] b;      // deleted 4x
}
```

== Memory Leak
- For everything, this is created by `new`, we must call `delete` on it
- If you do not, that memory is not deleted until all memory is used up

```cpp
#include <iostream>
using namespace std;

void leaked() {
  int *a;
  a = new int[2000];
}
int main() {
  for (int i=0; i<1000000; i++) {
    int *a;
    cout << i << endl;
    leaked();
  }
}
// terminate called after throwing an instance of 'std::bad_alloc'
```

=== Smart Pointer (NOT A SUBJECT OF THIS COURSE)
- A better way is to use C++ smart pointer `shared_ptr(T)`
- Smart pointer is a pointer that can delete itself when it go out of scope
- Similar concept to #text(fill: red)[Java Garbage Collection]
- Still possible to have memory leak


== vector.h

=== Version 0.1
- Start with vector that can do `push_back`, `pop_back`, and `[]`
- Also with custom constructor

```cpp
namespace CP {
template <typename T>
  class vector {
    protected:
      T *mData;
      size_t mCap;
      size_t mSize;

      void rangeCheck(int n) {...}
      void expand(size_t capacity) {...}
      void ensureCapacity(size_t capacity) {...}
    public:
      vector() {...}
      vector(size_t capacity) {...}
      ~vector() {...}
      // access
      T& at(in index) {...}
      T& operator[](int index) {...}
      // modifier
      void push_back(const T& element) {...}
      void pop_back() {...}
  };
}
```

=== Basic Constructor
```cpp
template <typename T>
class vector {
  protected:
    T *mData;
    size_t mCap;
    size_t mSize;

  public:
    vector() {
      int cap = 1;
      mData = new T[cap]();
      mCap = cap;
      mSize = 0;
    }

    vector(size_t cap) {
      mData = new T[cap]();
      mCap = cap;
      mSize = cap;
    }

vector<int> v;                        vector<int> w(5);

mSize  mCap  mData                    mSize  mCap     mData
  0     1     [ ]                       5     5    [0,0,0,0,0]
```

=== Destructor
- Since we `new mData`, we have to `delete` it
  - Or face a memory leak problem

```cpp
    ~vector() {
      delete [] mData;
    }
};
```

=== Object Life Cycle
- Normal object
  - Object is created (constructor called) when declared
  - Object is destroyed (destructor called) when go out of scope
- Object created by new (both `new T` or `new T[]`)
  Object is created when `new`
  Object is destroyed when `delete`

```cpp
class test {
public:
  // constructor
  test() : data() {cout << "created" << endl;}
  // destructor
  ~test() {cout << data << " destroyed " << endl;}
  int data;
};

int main() {
  cout << "-- Life cycle --" << endl;
  cout << "- normal cycle -" << endl;
  test u;
  u.data = 99;
  for (int i=0; i<5; i++) {
    test t;
    t.data = i*10;
  }
}
```

*Output*
```
-- Life cycle --
- normal cycle -
created       <-- u
created
0 destroyed
created
10 destroyed
created
20 destroyed
created
30 destroyed
created
40 destroyed
99 destroyed  <-- u
```

=== Accessing Data
- The return type is `T&` which is a reference
- Same deal as pass-by-refernce, this is called #text(fill: purple)[return-by-reference]
  - So we can do `v[i] = 30` or `v[i]++`
- What is returned is actually that variable
- Also notice the difference between `at()` and `operator[]`

```cpp
template <typename T>
class vector {
  protected:
    T *mData;
    size_t mCap;
    size_t mSize;

    void rangeCheck(int n) {
      if (n < 0 || (size_t)n >= mSize) {
        throw std::out_of_range("index out of range");
      }
    }

  public:
    T& at(int index) {
      rangeCheck(index);
      return mData[index];
    }

    T& operator[](int index) {
      return mData[index];  // return the variable
    }
};
```

=== Add, remove data
- `push_back` first check of we have reserved space
  - If not, we expand
- Then, the data is put to mData[mSize]
- Removing Data is done by just reduce the size
