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

#for i in range(15) {
  [.\ ]
}

== Linked List with Header

== CP::list
