= Lecture 14

== Linked List
Faster insert and erase but slower access

=== Overview
- Vector takes #text(fill: red)[$cal(O)(n)$] in `insert` / `erase` at position specified by an iterator
  - But it is very fast to access any member, #text(fill: blue)[$cal(O)(1)$]
- List gives better performance on `insert` / `erase` as #text(fill: blue)[$cal(O)(1)$], providing that we have iterator to the position of insertion / erase
- Achieved by storing data into a #text(fill: orange)[node] and each #text(fill: orange)[node] use a #text(fill: orange)[pointer] to identify the #text(fill: orange)[next element]
  - Access to any elements #text(fill: red)[is $cal(O)(n)$], if we don't have an iterator to that element
- #text(fill: purple)[Use more memory] than vector

=== List vs Vector
#table(
  columns: 2,
  table.header[*List*][*Vector*],
  [
    - Allocate each data separately
      - Each data points to where is the next data
      - Very fast `insert` / `erase` (just change some pointer)
      - Very slow access because we don't know where $k$-th element is
  ],
  [
    - Allocate data as a consecutive block
      - Very fast to access any element
      - Very slow `insert` / `erase` requires every element after point of insertion
  ],
)

=== v0.1 node
- Simple object that stores a #text(fill: green)[data] and a #text(fill: orange)[link to another node]
- #text(fill: purple)[NULL] is a special value for any pointer that points to nowhere
  - Draw as a ground

```cpp
template <typename T>
class node {
  public:
    T data;
    node *next;
    node() :
      data( T() ), next( NULL ) { }

    node(const T& data, node* next) {
      data( T(data) ), next( next ) { }
    }
};
```

=== Pointer to Node
- Working with linked list needs a pointer to a node

```cpp
int main() {
  CP::node<int> *p = NULL;
  p = new CP::node<int>(10, NULL);
  CP::node<int> *q;
  q = new CP::node<int>(20, NULL);
  p->next = q;
  q->next = new CP::node<int>(30, NULL);
}
```

```
 p ───────► [ 10 | next ] ──► [ 20 | next ] ──► [ 30 | NULL ]
                                      ▲
 q ──────────────────────────┘
```

What is the result of?
```cpp
p = p->next->next;  // p points to [30, NULL]
q = p;              // q points to [30, NULL]
q = q->next;        // q points to NULL
```

```
 p ───────────────────┐
                             ▼
[ 10 ] ──► [ 20 ] ──► [ 30 | NULL ]

 q ──► NULL
```

=== v0.1 Simple (Singly) Linked List
```cpp
template <typename T>
class list {
  protected:
    class node {
      public:
        T data;
        node *next;
        node() :
          data( T() ), next( NULL ) { }

        node(const T& data, node* next) {
          data( T(data) ), next( next ) { }
        }
    };
  protected:
    node *mFirst;
    size_t mSize;
  public:
    list() : mFirst( NULL ), mSize( 0 ) { }
    ~list() { clear(); }
    // ... more function
};
```

- Node is a inner class

=== Insertion
```

Linked List                                   x
mSize mFirst     node                         ▼
  [ 4,  ]  -► [20, next] -► [ 3, next] -► [16, next] -► [77, NULL]

  d -► [99, NULL]
```

- To insert a value `99` before value `16`, let `x` be a pointer that point to the node of `16`
  + Create a `new node d` containing a data to be inserted
  + Change pointer #text(fill: orange)[of a node] #text(fill: purple)[before `x`] (which points to `x`) to point to `d` instead
  + Make pointer of `d` points to `x`

```cpp
CP::node<int> *x = mFirst->next->next;
CP::node<int> *d = new CP::node<int>(99, NULL);
mFirst->next->next = d;
d->next = x;
```

```

                                           x
mSize mFirst     node                      ▼
  [ 4,  ]  -► [20, next] -► [ 3, d] -► [16, next] -► [77, NULL]
                                 ▼         ▲
                          d --> [99, x] ---|
```

=== Erase
- To delete a value of `16`, in the node pointed by `x`
  + Change pointer #text(fill: orange)[of a node] #text(fill: purple)[before `x`] (which points to `x`) to point to the node that `x` points to instead
  + Don't forget to `delete x`

```cpp
CP::node<int> *x = mFirst->next->next;
mFirst->next->next = x->next;
delete x;
```

```
                                              x
mSize mFirst     node                         ▼
  [ 4,  ]  -► [20, next] -► [ 3, next]                  [77, NULL]
                                  |_______________________▲
```

== Doubly Linked List

=== Problem with SLL
- `erase` / `insert` at iterator `X` is hard
  - If we have an iterator point to `X`, we #text(fill: purple)[cannot] easily go to the #text(fill: purple)[node before] `X`
  - Cannot go backward
    - Need to start from `mFirst` and move on
- Adding data to the end takes long time
  - We have to get iterator that points to the last element (which is #text(fill: red)[$cal(O)(n)$])

=== Finding node before X
```cpp
node *p = mFirst;
while (p != NULL && p->next != x) p = p->next;
```

=== v0.2 Doubly Linked List
- Each node has 2 pointers
  - `next` and `prev`
- Can now move forward and backward
- Now, if `X` is a pointer to a node, we can easily go to #text(fill: orange)[node before `X`] and then `erase` or `insert`

```
                                          x
mSize mFirst        node    |------▼      ▼     |------▼
  [ 4,  ]  -► [NULL, 20, next]    [prev, 16, next]    [prev, 77, NULL]
                            ▲______|            ▲______|
```

=== Insert in Doubly Linked List
```cpp
CP::node<int> *tmp =
  new CP::node<int> (99, NULL, NULL);
tmp->next = x;
tmp->prev = x.prev;
x->prev->next = tmp;
x->prev = tmp;
```
```
                                          x
mSize mFirst        node                  ▼     |------▼
  [ 4,  ]  -► [NULL, 20, next]    [prev, 16, next]    [prev, 77, NULL]
                          | ▲          ▲ |      ▲______|
                          ▼ |          | ▼
                  tmp -► [prev , 99, next]
```

=== Erase in Doubly List
```cpp
x->prev->next = x->next;
x->next->prev = x->prev;
delete x;
```

Note: When we refer to a pointer, `x` is the variable itself, but the value of `x` is the destination address it is pointing to.
Say `x` holds a node containing ```cpp [x->prev, 16, x->next]```.
In this set up, ```cpp x->prev->next``` represents the next pointer inside the node before `x`.
If we write ```cpp x->prev->next = x->next;```, it means that the previous node's next pointer now stores the destination of the node after `x`.
In other words, it successfully skips `x` from the sequence.

```
                                          x
mSize mFirst        node    |-------------▼------------▼
  [ 4,  ]  -► [NULL, 20, next]                        [prev, 77, NULL]
                            ▲__________________________|
```

== Circular Linked List

=== Problem Solved
- `erase` / `insert` at iterator `X` is now #text(fill: blue)[easy]
- But, adding data at the end (`push_back`) is still hard
  - Need to get `X` to point to the last element
  - `push_back` is popular in real world
  - Right now we have only `push_back` (fast addition to the first)
- Also some minor issue about the #text(fill: green)[code cleanliness]
  - `insert` / `erase` the first / last node

=== v0.3 Circular Linked List
- Use `mLast` instead of `mFirst`
- Fast access to both first and last element

```cpp
CP::node<int> *first = mLast->next;
```

```

  /------------------------------------------------------------\
  \-► [20, next] -► [3, next] -► [16, next] -► [77, next] --/
                                                        ▲
                                                        |
                                                   mSize mLast
                                                     [ 4,  ]
```

=== v0.4 Circular Doubly Linked List
- Special linking to last element
  - Fast access to both first and last element
  - Can now easily insert at the end

```cpp
CP::node<int> *last = mFirst->prev;
```

```
                |---------------------------------------------------\
mSize mFirst    ▼   node    |------▼            |------▼            /
  [ 4,  ]  -► [prev, 20, next]    [prev, 16, next]    [prev, 77, next]
                /           ▲______|            ▲______|            ▲
                \---------------------------------------------------|
```

== Linked List with Header

=== Minor Problem
- Code is #text(fill: red)[not really clean] because of the first element (or the last element)
- Consider `insert` at the first node and insert at the second node of Doubly Linked List
  - Assume we have a pointer to that node

```cpp
// assume thta s points to the second node
CP::node<int> *tmp =
  new CP::node<int>(99,NULL,NULL);
tmp->next = s;
tmp->prev = s->prev;
s->prev->next = tmp;
s->prev = tmp;

// assume that f points to the first node
CP::node<int> *tmp =
  new CP::node<int>(99,NULL,NULL);
tmp->next = f;
tmp->prev = f->prev;
mFirst = tmp;  // Because first node is different
f->prev = tmp;
```

=== Special First Node Problem
- First node (and last node) is #text(fill: red)[different from other nodes] in both singly or doubly linked list
- For circular singly and circular doubly, each node look the same #text(fill: orange)[but we also have to adjust `mFirst`] (or `mLast`)
- This affects both `insert` and `erase`
- Also need to deal #text(fill: red)[when `mFirst` is `NULL`] (when `mSize == 0`)

```cpp
// circular doubly linked list
void push_front(const T& e) {
  if (mSize == 0) {
    mFirst = new node(e, NULL, NULL);
    mFirst->next = mFirst;
    mFirst->prev = mFirst;
  } else {
    node* tmp =
      new node(e, mFirst->prev, mFirst);
    mFirst->prev->next = tmp;
    mFirst->prev = tmp;
    mFirst = tmp;
  }
}
```

=== Another Example
- Remove for circular doubly linked list
- Remove is to find and then `erase`

```cpp
// circular doubly linked list
void remove(const &T e) {
  node *p = mFirst;
  for (size_t i = 0; i < mSize; i++, p = p->next) {
    if (p->data == e) {
      p->next->prev = p->prev;
      p->prev->next = p->next;
      if (p == mFirst) {
        mFirst = p->next;
      }
      delete p;
      mSize--;
      break;
    }
  }
  if (mSize == 0) mFirst = NULL;
}
```

=== Linked List with Header
- Add a special node that will not be used to stored data

=== Simpler Code with Header
```cpp
void push_front(const T& e) {
  node* f = mFirst->next;
  node* tmp = new node(e, f, mFirst);
  mFirst->next = tmp;
  f->prev = tmp;
}

void remove(const T& e) {
  node *p = mFirst->next;
  while (p != mHeader && p->data != e)
    p = p->next;
  if (p != mHeader) {
    p->next->prev = p->prev;
    p->prev->next = p->next;
    mSize--;
  }
}
```

- Header simplifies code
  - Because `mFirst` always points to the header (`mFirst` never is `NULL`)


=== Variant Summary
- #text(fill: blue)[Circular] makes accessing first and last element fast
- #text(fill: orange)[Doubly] makes accessing previous element fast
  - Also making `erase` at node `p` easy if we have pointer to `p`
  - Need more space for `prev` pointer
- #text(fill: red)[Header] makes code simpler
  - Need more space for header node

=== Final Version
- `CP::list` is "#text(fill: blue)[circular] #text(fill: orange)[doubly] linked list #text(fill: red)[with header]"
  - #text(fill: green)[Simple code] for `insert` / `erase`
  - Use #text(fill: red)[most space] (two pointers per node, need header node)
  - Can `push_back`, `pop_back`, `push_front`, `pop_front`
- Also need custom iterator class
  - #text(fill: purple)[Iterator] just store a pointer to a node
  - We cannot directly use a pointer to a node (`node*`) because we need to override some operator (`--`, `++`, and something else)

== CP::list

=== Layout
- #text(fill: purple)[Inner class] is a class inside another class
  - #text(fill: purple)[Inner class] can access any members of #text(fill: orange)[outer class]
  - #text(fill: orange)[Outer class] cannot access `protected` or `private` of the #text(fill: purple)[inner class]
- #text(fill: blue)[Friend class] allows other class to access

```cpp
template <typename T>
class list {
  protected:
    class node {
      friend class list;
      public:
        T data;
        node *prev, *next;
        // some functions
    };
    class list_iterator {
      friend class list;
      protected:
        node* ptr;
      public:
        // some functions && operators
    };
  public:
    typedef list_iterator iterator;
  protected:
    node *mHeader; // pointer to a header node
    size_t mSize;
  public:
    // functions
};
```

=== Doubly Linked List Node
```cpp
class node {
  friend class list;
  public:
    T data;
    node *prev;
    node *next;

    node() :
      data( T() ), prev( this ), next( this ) { }
    node(const T& data, node* prev, node* next) :
      data( T(data) ), prev( prev ), next( next ) { }
};
```

=== Constructor
```cpp
  // default constructor
  list() : mHeader( new node() ), mSize( 0 ) { }

  // copy constructor
  list(list<T>& a) : mHeader( new node() ), mSize( 0 ) {
    for (iterator it = a,begin(); it != a.end(); it++) {
      push_back(*it);
    }
  }

  list<T>& operator=(list<T> other) {
    using std::swap;
    swap(this->mHeader, other.mHeader);
    swap(this->mSize, other.mSize);
    return *this;
  }

  ~this() {
    clear();
    delete mHeader;
  }
```

=== Small functions
```cpp
  // capacity function
  bool empty() const { return mSize == 0; }
  size_t size() const { return mSize; }

  // access
  T& front() { return mHeader->next->data; }
  T& back() { return mHeader->prev->data; }

  // modifier
  void push_back(const T& element) {
    insert(end(), element);
  }
  void push_front(const T& element) {
    insert(begin(), element);
  }
  void pop_back() {
    erase(iterator(mHeader->prev));
  }
  void pop_front() {
    erase(begin());
  }
```

- Task is delegated to `insert` and `erase`
- Need iterator

=== Iterator
```cpp
class list_iterator {
  friend class list;
  protected:
    node* ptr;
  public:

  list_iterator() : ptr( NULL ) { }
  list_iterator(node *a) : ptr(a) { }

  list_iterator& operator++() {
    ptr = ptr->next;
    return (*this);
  }

  list_iterator& operator--() {
    ptr = ptr->prev;
    return (*this);
  }
```

- Has custom constructor that takes node pointer

```cpp
  list_iterator& operator++(int) {
    list_iterator tmp(*this);
    operator++();
    return tmp;
  }

  list_iterator& operator--(int) {
    list_iterator tmp(*this);
    operator--();
    return tmp;
  }
```

- `operator++()` is an operator for #text(fill: orange)[`++it`]
- `operator++(int)` is a syntax for #text(fill: purple)[`it++`]
- `operator++(int)` delegates to `operator++()`
- Same for `operator--()`

```cpp
  T& operator*() { return ptr->data; }
  T* operator->() { return &(ptr->data); }

  bool operator==(const list_iterator& other) {
    return other.ptr == ptr;
  }

  bool operator!=(const list_iterator& other) {
    return other.ptr != ptr;
  }
};
```

=== Other small functions
```cpp
iterator begin() {
  return iterator(mHeader->next);
}

iterator end() {
  return iterator(mHeader);
}

void clear() {
  while (mSize > 0) erase(begin());
}
```

```
               |--------------------------------------------------\
mSize mFirst   ▼  mHeader  |-------▼          |-------▼           /
  [ 2,  ]  -► [prev,  , next]    [prev, 4, next]    [prev, 32, next]
               /     ▲     ▲-------|     ▲    ▲-------|           ▲
               \-----|-------------------|------------------------|
                   end()              begin()
```

=== Insert & Erase
```cpp
iterator insert(iterator it, const T& element) {
  node *n = new node(element, it.ptr->prev, it.ptr);
  it.ptr->prev->next = n;
  it.ptr->prev = n;
  mSize++;
  return iterator(n);
}

iterator erase(iterator it) {
  iterator tmp(it.ptr->next);
  it.ptr->prev->next = it.ptr->next;
  it.ptr->next->prev = it.ptr->prev;
  delete it.ptr;
  mSize--;
  return tmp;
}
```

- Header make `insert` / `erase` very simple
