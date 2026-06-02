= Lecture 11

== CP::queue
Will the circle be unbroken?

=== Intro
- Queue, unlike stack, require more sophisticated technique to achieve fast performance
- We start by writing a simple class that just work (slowly)
- Then we try to improve it

=== Key Idea
- Just like stack, we will use the same format as vector, using dynamic array to store data
- However we have to somehow manage how we works with `front()` and `back()` of the queue

=== v0.1 simple implementation of the queue
- To illustrate this idea, we will use a #text(fill: purple)[vector] as our data member
- `push(e)` is simply `v.push_back(e)`, this is fast
- `front()` is `v[0]`, `back()` is `v[v.size()-1]`, this is also fast
- `pop()` is `v.erase(v.begin())`, this is slow (always proportional to `v.size()`)
  - Unlike `std::queue` which has very fast `pop()`

```cpp
namespace CP {
  template <typename T>
  class queue {
    protected:
      std::vector<T> v;
    public:
      // default constructor
      queue() : v() { }
      // capacity function
      bool empty() const { return v.empty(); }
      size_t size() const { return v.size(); }
      // access
      const T& front() const { return v[0]; }
      const T& back() const { return v[v.size()-1]; }
      // modifier
      void push(const T& element) { v.push_back(element); }
      void pop() { v.erase(v.begin()); }
  };
}
```

=== v0.1 example
```
CP::queue<int> q;    q  v
                        mSize  mCap  mData
                          0     1      ---->  [ ]
q.push(10);          q  v
                        mSize  mCap  mData
                          1     1      ---->  [10]
q.push(20);          q  v
                        mSize  mCap  mData
                          2     2      ---->  [10, 20]
q.push(30);          q  v
                        mSize  mCap  mData
                          3     4      ---->  [10, 20, 30, ]
q.pop();             q  v                         /   /
                        mSize  mCap  mData       /   /
                          2     4      ---->  [20, 30, , ]
```

=== v0.2 faster queue
- Add more data member `mFront`, initialized as `0`
- `push(e)` is simply `v.push_back(e)`, this is fast
- `front()` is `v[mFront]`, `back()` is `v[v.size()-1]`, this is also fast
- `pop()` is `mFront++`, this is fast
  - However, we don't really remove anything when `pop`

```cpp
#include <vector>

namespace CP {
  template <typename T>
  class queue {
    protected:
      std::vector<T> v;
      int mFront;
    public:
      // constructor
      queue() : v(), mFront() {}
      // capacity function
      bool empty() const { return v.empty(); }
      size_t size() const { return v.size() - mFront; }
      // access
      const T& front() const { return v[mFront]; }
      const T& back() { return v[v.size()-1]; }
      // modifier
      void push(const T& element) { v.push_back(element); }
      void pop() { mFront++; }
  };
}
```

=== v0.2 example
```
CP::queue<int> q;    q          v
                        mFront  mSize  mCap  mData
                          0       0     1      ---->  [ ]
q.push(10);          q          v
                        mFront  mSize  mCap  mData
                          0       1     1      ---->  [10]
q.push(20);          q          v
                        mFront  mSize  mCap  mData
                          0       2     2      ---->  [10, 20]
q.push(30);          q          v
                        mFront  mSize  mCap  mData
                          0       3     4      ---->  [10, 20, 30, ]
q.pop();             q          v
                        mFront  mSize  mCap  mData
                          1       3     4      ---->  [10, 20, 30, ]
```

=== Problem with v0.2
- Fast but #text(fill: purple)[use too many space]
- Queue grows according to #text(fill: orange)[how many time push is called]
  - regardless of how many `pop` is called
- The data stored in the vector can be #text(fill: red)[much larger] than the actual data in the queue
- Does not really work in real world

```cpp
for (int i=0; i<1000000; i++) {
  q.push(i);
  q.pop();
}
std::cout << q.size() << std::endl;
```

== Circular Queue

=== Final Idea
```
  mFront  mSize  mCap  mData             *
    2       2     4      ---->  [  ,   , 30, 40]
  q.push(50);
  mFront  mSize  mCap  mData             *
    2       3     4      ---->  [50,   , 30, 40]
  q.push(60);
  mFront  mSize  mCap  mData             *
    2       4     4      ---->  [50, 60, 30, 40]
  q.pop();
  mFront  mSize  mCap  mData                 *
    3       3     4      ---->  [50, 60,   , 40]
  q.push(99);
  mFront  mSize  mCap  mData                 *
    3       4     4      ---->  [50, 60, 99, 40]
  q.push(1);                      \   \   \
  mFront  mSize  mCap  mData     *  \   \   \
    0       5     4      ---->  [40, 50, 60, 99,  1,   ,   ,   ]
```

- We take v0.2 and #text(fill: green)[reuse] the area at the beginning of `mData`
  - Expand when necessary
  - Re-arrange when expand

=== Circular Queue
- We can think of `mData` to be circular
  - End of the last element of the `mData` is connected to the first element
- Consider $i^"th"$ element
  - the next element is `(i+1) % mCap`
  - The previous element is `(i-1+mCap) % mCap`
  - Next `k` element is `(i+k) % mCap`

== Circular Queue Implementation

=== queue.h
```cpp
namespace CP {
  template <typename T>
  class queue {
    protected:
      T *mData;
      size_t mCap;
      size_t mSize;
      size_t mFront;
      void expand(size_t capacity) {...}
      void ensureCapacity(size_t capacity) {...}
    public:
      // constructor - almost the same but have to take care of mFront
      queue(const queue<T>& a) {...}
      queue() {...}
      queue<T>& operator=(queue<T> other) {...}
      ~queue() {...}
      // capacity function - same as vector
      bool empty() const {...}
      size_t size() const {...}
      // access - circular queue implementation
      const T& front() const {...}
      const T& back() const {...}
      // modifier
      void push(const T& element) {...}
      void pop() {...}
  };
}
```

=== Ctor, Dtor, copy
```cpp
template <typename T>
class queue {
  protected:
    T *mData;  size_t mCap;  size_t mSize;  size_t mFront;
  public:
    // default constructor
    queue() : mData(new T[1]()), mCap(1),
              mSize(0), mFront(0) { }
    // copy constructor
    queue(const queue<T>& a) : mData(new T[a.mCap]()), mCap(a.mCap),
                               mSize(a.mSize), mFront(a.mFront) {
      for (size_t i = 0; i < a.mCap; i++) {
        mData[i] = a.mData[i];
      }
    }
    // copy assignment operator
    queue<T>& operator=(queue<T> other) {
      using std::swap;
      swap(mSize, other.mSize);
      swap(mCap, other.mCap);
      swap(mData, other.mData);
      swap(mFront, other.mFront);
      return *this;
    }
    ~queue() {
      delete [] mData;
    }
};
```

=== front(), back(), pop()
Continue at _vid 52 5.48_
