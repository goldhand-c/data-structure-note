= Lecture 10

== Stack

=== Intro
- Now we will create less complex data structure `CP::stack`
- Just like a vector without `iterator, insert, erase, resize, at end operator[]`
  - Add `top()` which is just a shorthand of looking at the last element
- That's it, really

=== Key Idea
- The data is stored in the same way as a vector
  - The first element of `mData` is the bottom of stack while the last element is the top of the stack
- We just take `vector.h` and remove unnecessary function

```
  |   |   stack
  |   |
  | A |   mSize  mCap     mData
  | X |     4     5    [A, B, X, A]
  | B |
  | A |
  |___|
```

=== stack.h
```cpp
namespace CP {
  template <typename T>
  class stack {
    protected:
      T *mData;
      size_t mCap;
      size_t mSize;
      void expand(size_t capacity) {...}
      void ensureCapacity(size_t capacity) {...}
    public:
      // constructor
      stack(const stack<T>& a) {...}
      stack() {...}
      stack<T>& operator= {...}
      ~stack() {...}
      // capacity operation
      bool empty() const {...}
      size_t size() const {...}
      // access
      const T& top() const {
        return mData[mSize-1];
      }
      // modifier
      void push(const T& operator) {...}  // This is push_back
      void pop() {...}  // This is pop_back
  };
}
```

=== Speed of each operation
- All read operation always take constant time
  - `size()`, `top()` simply return something that is directly accessible
- All modify operation also take constant time
  - `push()` is constant on average (same as `push_back` of vector)
  - `pop()` is always constant

=== Stack by Vector
- Instead of writing our own function, there is another way to write a stack
- We simply use #text(fill: purple)[vector] as our sole data member
- Benefit: #text(fill: blue)[code reuse]
- Drawback: #text(fill: green)[almost none] except that we need one more layer of function call

```cpp
namespace CP {
  template <typename T>
  class stack {
    protected:
      vector<T> v;
    public:
      // default constructor
      stack() : v() { }
      // capacity function
      bool empty() const { return v.empty(); }
      size_t size() const { return v.size(); }
      // access
      const T& top() const { return v.back(); }
      // modifier
      void push(const T& element) { v.push_back(element); }
      void pop() { v.pop_back(); }
  };
}
```
