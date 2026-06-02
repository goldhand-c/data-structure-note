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

```cpp
template <typename T>
class vector {
  protected:
    T *mData;
    size_t mCap;
    size_t mSize;
    void expand(size_t capacity) {
      T *arr = new T[capacity]();  // create a new dynamic array
      for (size_t i = 0; i < mySize; i++) {
        arr[i] = mData[i];  // move all data
      }
      delete [] mData;
      mData = arr;  // delete old data and point to new one
      mCap = capacity;
    }
    void ensureCapacity(size_t capacity) {
      if (capacity > mCap) {
        size_t s = (capacity > 2 * mCap) ? capacity : 2 * mCap;  // double the size
        expand(s);
      }
    }
  public:
    void push_back(const T& element) {
      ensureCapacity(mSize+1);
      mData[mSize++] = element;  // add size and put element
    }
    void pop_back() {
      mSize--;
    }
};
```

== Vector Constructors

=== Problem of v0.1
- Copy constructor and assignment operator is incorrect
  - It is auto generate to copy all variables (but not the data it points to)
- Rule of three in c++
  - Consider destructor, copy constructor, assignment operator
  - If any of them is written in the code, we mostly need all of them
- Since c++11, it's rule of four an a half

```cpp
int main() {
  CP::vector<int> w(5);

  for (int i=0; i<5; i++) w[i] = i*10;
  CP::vector<int> x(w);  // this creates shallow copy of w
  CP::vector<int> y = w;
  x[3] = -1;  // changes both w and y
  cout << y[3] << endl;  // -1
  cout << w[3] << endl;  // -1
}
```

=== v0.2, add small access functions
- `empty` and `size` also exists in other data structure
- `size_t` is non-negative integer type

```cpp
bool empty() const {
  return mSize == 0;
}

size_t size() const {
  return mSize;
}

size_t capacity() const {
  return mCap;
}
```

=== v0.2 adding copy constructor & assignment operator
```cpp
// copy constructor
vector(const vector<T>& a) {
  mData = new T[a.capacity()]();
  mCap = a.capacity();  // copies only value
  mSize = a.size();
  for (size_t i=0; i<a.size(); i++) {
    mData[i] = a[i];
  }
}

// copy assignment operator
vector<T>& operator=(vector<T> &other) {
  // protect against self-destruct
  if (mData != other.mData) {
    // delete current data
    delete [] mData;
    // copy the new data
    mData = new T[other.capacity()]();
    mCap = other.capacity();
    mSize = other.size();
    for (size_t i=0; i<a.size(); i++) {
      mData[i] = a[i];
    }
  }
}
```

=== Copy-and-swap
- Utilize written copy-constructor nd destructor
- Shorter code

```cpp
// copy assignment operator using copy-and-swap idiom
vector<T>& operator=(vector<T> other) {  // notice the pass-by-value!!!
  // other is copy-constructed which will be destruct at the end of this scope
  // we swap the content of this class to the other class and let it be destructed
  using std::swap;
  swap(this->mSize, other.mSize);
  swap(this->mCap, other.mCap);
  swap(this->mData, other.mData);
  return *this;
}
```

== Iterator, Insert, Erase, & Analysis

=== v0.3 Iterator and typedef keyword
```cpp
template <typename T>
class vector {

  protected:
    T *mData;
    size_t mCap;
    size_t mSize;
  protected:
    typedef T* iterator;  // let iterator be type name of T pointer

    // iterator
    iterator begin() {
      return &mData[0];
    }

    iterator end() {
      return begin()+mSize;
    }
}
```

- See that pointer works just like how `std::vector::iterator` works
- In fact, iterator is actually a pointer
- `typedef` keyword allows us to map a type name
  - `CP::vector<int>::iterator` is `int*`
  - `CP::vector<bool>::iterator` is `bool*`

=== insert
- `push_back` actually call `insert(end(), element)`
- Question: why we need `pos`?

```cpp
iterator insert(iterator it, const T& element) {
  size_t pos = it - begin();
  ensureCapacity(mSize+1);
  for (size_t i = mSize; i > pos; i--) {
    mData[i] = mData[i-1];
  }
  mData[pos] = element;
  mSize++;
  return begin()+pos;
}

void push_back(const T& element) {
  insert(end(), element);
}
```

=== erase
- See that both `insert` and `erase` also change `mSize`

```cpp
void erase(iterator it) {
  while((it+1)!=end()) {
    *it = *(it+1);
    it++;
  }
  mSize--;
}
```

=== Exercise
- Read the following function and see how it works in `vector.h`
  - `resize`, `clear`
  - non-stl function
    - `insert_by_pos`
    - `erase_by_pos`
    - `erase_by_value`
    - `constains`
    - `index_of`
- Read in #link("https://github.com/nattee/data-class/blob/master/stl-cp/vector.h")[#text(fill: blue)[here]]

#box(fill: yellow, inset: 5pt)[Will do this part later]

=== Analysis of how many data is copied by push_back
- When full, `push_back` have to move all data to a new dynamic array
- `ensureCapacity` double the size

#let count = 10
#let fib(n) = (
  if n <= 2 { 1 } else { fib(n - 1) + fib(n - 2) }
)

=== Size and Capa & Copy Count
- How much copy we need?

// ── layout constants ──────────────────────────────────────────
#let lm = 120pt    // left  margin inside page (room for y labels)
#let rm = 20pt    // right margin
#let tm = 20pt    // top   margin inside page (room for legend)
#let bm = 190pt    // bottom margin (room for x labels)

#let pw = 550.28pt - 20pt - 20pt - lm - rm   // plot width  ≈ 485pt
#let ph = 480pt - 20pt - 30pt - tm - bm    // plot height ≈ 345pt

#let x-max = 1024
#let y-max = 1200

// map data → page coords  (origin = bottom-left of plot area)
#let px(x) = lm + x / x-max * pw
#let py(y) = tm + ph - y / y-max * ph   // y=0 → bottom, y=y-max → top

// ── colours ───────────────────────────────────────────────────
#let col-bg = rgb("#1e1e2e")
#let col-grid = rgb("#45475a")
#let col-axis = rgb("#7f849c")
#let col-label = rgb("#888888")
#let col-size = rgb("#dbb054")   // yellow  – size
#let col-cap = rgb("#f38ba8")   // red     – capacity
#let col-copy = rgb("#89b4fa")   // blue    – #copy
#let col-border = rgb("#313244")

// ── helper: draw a line segment ───────────────────────────────
#let seg(x0, y0, x1, y1, col, thick: 2pt) = place(
  top + left,
  dx: x0,
  dy: y0,
  line(start: (0pt, 0pt), end: (x1 - x0, y1 - y0), stroke: (paint: col, thickness: thick, cap: "round")),
)

// ── data ──────────────────────────────────────────────────────
//  powers includes 0 as a sentinel for the first segment start
#let P = (0, 1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024)
//  capacity: in interval [P[i], P[i+1]) capacity = P[i+1]
//  copy:     cumulative copies; jumps by P[i+1] at x = P[i+1]

// ─────────────────────────────────────────────────────────────
//  DRAWING
// ─────────────────────────────────────────────────────────────
#figure(
  //#place(bottom + left, dx: 0pt, dy: 0pt)[
  box(width: 595.28pt, height: 256pt)[

    // ── background plot area ──────────────────────────────────────
    #place(top + left, dx: lm, dy: tm, rect(width: pw, height: ph, fill: rgb("#fefefe"), stroke: none))

    // ── horizontal grid lines + y-axis labels ─────────────────────
    #for ytick in (0, 200, 400, 600, 800, 1000, 1200) {
      // grid line
      place(top + left, dx: lm, dy: py(ytick), line(length: pw, stroke: (
        paint: col-grid,
        thickness: 0.5pt,
        dash: "dashed",
      )))
      // label
      place(top + left, dx: lm - 50pt, dy: py(ytick) - 6pt, align(right, box(width: 44pt, text(
        fill: col-label,
        size: 8.5pt,
      )[#ytick])))
    }

    // ── vertical grid lines at every power of 2 ───────────────────
    #for p in (1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024) {
      place(top + left, dx: px(p), dy: tm, line(angle: 90deg, length: ph, stroke: (
        paint: col-grid,
        thickness: 0.4pt,
        dash: "dashed",
      )))
    }

    // ── x-axis tick labels (all powers of 2) ─────────────────────
    #for p in (1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024) {
      place(top + left, dx: px(p) - 14pt, dy: tm + ph + 7pt, box(width: 28pt, align(center, text(
        fill: col-label,
        size: 7.5pt,
      )[#p])))
      // tick mark
      place(top + left, dx: px(p), dy: tm + ph, line(angle: 90deg, length: 4pt, stroke: (
        paint: col-axis,
        thickness: 1pt,
      )))
    }

    // ── axes ──────────────────────────────────────────────────────
    // x-axis
    #place(top + left, dx: lm, dy: tm + ph, line(length: pw, stroke: (paint: col-axis, thickness: 1.2pt)))
    // y-axis
    #place(top + left, dx: lm, dy: tm, line(angle: 90deg, length: ph, stroke: (paint: col-axis, thickness: 1.2pt)))

    // ── axis labels ───────────────────────────────────────────────
    // y-axis label (rotated)
    #place(top + left, dx: 75pt, dy: tm + ph / 2 - 25pt, rotate(-90deg, text(
      fill: col-label,
      size: 9pt,
      weight: "semibold",
    )[count]))
    // x-axis label
    #place(top + left, dx: lm + pw / 2 - 20pt, dy: tm + ph + 22pt, text(
      fill: col-label,
      size: 9pt,
      weight: "semibold",
    )[n (size)])

    // ── SIZE line (yellow diagonal, y = x) ───────────────────────
    #seg(px(0), py(0), px(1024), py(1024), col-size)

    // ── CAPACITY step function (red) ─────────────────────────────
    // Segments: for i in 0..10, interval [P[i], P[i+1]), cap = P[i+1]
    // Starting from i=0: [0,1) cap=1, [1,2) cap=2, etc.
    #for i in range(P.len() - 1) {
      let x0 = P.at(i)
      let x1 = P.at(i + 1)
      let cap = P.at(i + 1)
      // horizontal segment at height cap
      seg(px(x0), py(cap), px(x1), py(cap), col-cap)
      // vertical jump at x1 (if not last): from cap to 2*cap
      if i + 2 < P.len() {
        let cap-next = P.at(i + 2)
        seg(px(x1), py(cap-next), px(x1), py(cap), col-cap)
      }
    }

    // ── #COPY step function (blue) ────────────────────────────────
    // cumulative copies jump at each power of 2 (excluding 0)
    // At x = P[k] (k=1..11), cumulative += P[k]
    #let cum = 0
    #for k in range(1, P.len()) {
      let xjump = P.at(k)
      let xnext = if k + 1 < P.len() { P.at(k + 1) } else { 1024 }
      let cum-prev = cum
      cum = cum + xjump
      let cum-cur = cum

      // vertical jump at xjump
      seg(px(xjump), py(calc.min(cum-cur, y-max)), px(xjump), py(cum-prev), col-cap)
      seg(px(xjump), py(0), px(xjump), py(cum-prev), col-copy)
      // horizontal segment from xjump to xnext at cum-cur (if within y-max)
      if cum-cur <= y-max {
        seg(px(xjump), py(cum-cur), px(xnext), py(cum-cur), col-cap)
      }
    }
    // initial horizontal from 0 to 1 at y=0
    #seg(px(0), py(0), px(1), py(0), col-copy)

    // ── LEGEND (top-left inside plot area) ───────────────────────
    #place(top + left, dx: lm + 8pt, dy: tm + 8pt, box(
      fill: rgb("#ffffff"),
      stroke: (paint: col-border, thickness: 1pt),
      inset: (x: 10pt, y: 8pt),
      radius: 4pt,
    )[
      #set text(size: 9pt)
      #stack(
        dir: ltr,
        spacing: 18pt,
        // size
        stack(dir: ltr, spacing: 5pt, line(length: 22pt, stroke: (paint: col-size, thickness: 2.5pt)), text(
          fill: col-size,
        )[size]),
        // capacity
        stack(dir: ltr, spacing: 5pt, line(length: 22pt, stroke: (paint: col-cap, thickness: 2.5pt)), text(
          fill: col-cap,
        )[capacity]),
        // #copy
        stack(dir: ltr, spacing: 5pt, line(length: 22pt, stroke: (paint: col-copy, thickness: 2.5pt)), text(
          fill: col-copy,
        )[\#copy]),
      )
    ])

  ], // end box
  // ] // end place
)
