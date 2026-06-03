= Lecture 13

== Priority Queue Simple Implementation
Featuring Binary Heap

=== Overview
- Simple implementation of `priority_queue`
- Quick intro to #text(fill: orange)[Graph] and #text(fill: green)[Tree]
- #text(fill: purple)[Binary Heap]
- `priority_queue` with #text(fill: purple)[Binary Heap]

=== priority_queue
- Queue by value
- Max-in-First-Out

```cpp
int main() {
  priority_queue<int> pq;
  pq.push(4);
  pq.push(20);
  pq.push(3);

  while (pq.empty() == false) {
    cout << pq.top() << endl;
    pq.pop();
  }
}
```

=== V0.1, priority_queue by vector
- Use #text(fill: purple)[vector] to store data
- `push` = simply `push_back`
- `top`, `pop` = find the max value and `return` / `erase`
- `max_element` returns iterator to max element

```cpp
namespace CP {
  template <typename T>
  class priority_queue {
    protected:
      std::vector<T> v;
    public:
      bool empty(); { return v.empty(); }
      bool size(); { return v.size(); }

      void push(const T &e) { v.push_back(e); }

      T top() { return *std::max_element(v.begin(), v.end()); }

      void pop() { v.erase(std::max_element(v.begin(), end())); }
  };
}
```

=== max_element
```cpp
iterator max_element(iterator first, iterator last) {
  if (first == last) return last;
  iterator largest = first;
  ++first;
  for (; first != last; ++first)
    if (*largest < *first)
      largest = first;
  return largest;
}
```

=== V0.1 complexities
#table(
  columns: 2,
  column-gutter: 16pt,
  stroke: none,
  [`push`], [$cal(O)(1)$ \*amortized],
  [`top()`], [$Theta(n)$],
  [`pop()`], [$Theta(n)$],
)

=== V0.2 faster pop, top (and push??)
- v0.1 has many drawbacks
  - Consecutive call of `top` is slow (it shouldn't)
  - Both `pop` and `top` works almost the same
- v0.2 focus on #text(fill: red)[slower `push`] while keeps #text(fill: green)[`pop`, `top` fast]
- Make the array #text(fill: purple)[sorted]
  - Max will be at the back
  - Fast `pop`, `top`

```cpp
namespace CP {
  template <typename T>
  class priority_queue {
    protected:
      std::vector<T> v;
    public:
      bool empty(); { return v.empty(); }
      bool size(); { return v.size(); }

      T& top() { return v[v.size()-1]; }

      void pop() { v.erase(v.end()-1); }

      void push(const T &e) {
        // do something
      }
  };
}
```

=== v0.2 push
- Maintain that the vector is sorted at every push

```cpp
void push(const T& e) {
  v.push_back(e);  // <-- 𝒪(1)
  sort(v.begin(), v.end());  // <-- 𝒪(n log(n))
}
```

```cpp
void push(const T& e) {
  auto it = v.begin();
  while (it < v.end() && *it <= e)  // <-- 𝒪(n)
    it++;
  v.insert(it,e);  // <-- 𝒪(n)
}  // Total of this program is Θ(n)
```

```cpp
void push(const T& e) {  // upper_bound is 𝒪(log(n))
  v.insert(std::upper_bound(v.begin(), v.end(), e), e);  // <-- 𝒪(n)
}
```

=== Which one is better?
- v0.1 fast `push`
- v0.2 fast `pop`, `top`
- Depends on which operation we use most often
- The real version works like v0.2, we maintain some #text(fill: green)[rules] of the data that is stored in the vector such that
  - We know where max is (for fast `pop`)
  - Much faster `push`, a little bit slower `pop`
  - Use structure called #text(fill: purple)[Binary Heap]

== Graph & Tree

#import "@preview/diagraph:0.3.7": raw-render

=== Graph
- Discrete Math Graph
- A math model that describe entities and connectivity between them

#align(center)[#scale(x: 65%, y: 65%)[
  #raw-render(
    ```dot
    digraph {
      rankdir="LR";
      edge [len=0.1,arrowhead=none];
      "Lak Song" -> "Bang Wa";
      "Bang Wa" -> "Tha Phra";
      "Bang Wa" -> "Sala Daeng";
      "Tha Phra" -> "Sala Daeng";
      "Tha Phra" -> "Mo Chit";
      "Sala Daeng" -> Siam;
      "Sala Daeng" -> Asok;
      "Mo Chit" -> Siam;
      "Mo Chit" -> Asok;
      Siam -> Asok;
      Asok -> Kheha;
    }
    ```,
  )
]]

=== Graph Model
- Graph consists of two things
  - #text(fill: blue)[Nodes (vertex, vertices)] are #text(fill: blue)[things] we want to connect
  - #text(fill: purple)[Edges] are pairs, each pair is a #text(fill: purple)[connectivity] between two nodes
- Graph $G = (V, E)$ where $V$ is a set of nodes and $E$ is a set of edges

$V = {"\"Mo Chit\"", "\"Siam\"", "\"Asok\"", "\"Sala Daeng\"", "\"Tha Phra\"", "\"Lak Song\"", "\"Bang Wa\"", "\"Kheha\""}$\
$E = {("\"Mo Chit\"", "\"Asok\""), ("\"Mo Chit\"", "\"Siam\""), ("\"Tha Phra\"", "\"Mo Chit\""), ("\"Sala Daeng\"", "\"Tha Phra\""), ...}$

=== Tree
- A special kind of graph
  - Has $N$ nodes and $N-1$ edges
  - Every nodes must be connected (we can start from any node and can walk through edge to reach any node)

#align(center)[#scale(x: 65%, y: 65%)[
  #raw-render(
    ```dot
    digraph {
      rankdir="LR";
      edge [len=0.1,arrowhead=none];
      1 -> 2;
      2 -> 3;
      3 -> 4;
    }
    ```,
  )
]]

$
  V & = {1, 2, 3, 4} \
  E & = {(1,2), (2,3), (3,4)}
$


=== Rooted Tree
- Tree where one node is defined as #text(fill: purple)[root]
- For an edge in a rooted tree, a node that is closer to the root is called #text(fill: green)[parent] while the other node is called #text(fill: green)[child]
- #text(fill: green)[Ancestor] of node $A$ = parent of parent ... of $A$
- #text(fill: blue)[Descendant] of node $A$ = child of child ... of $A$
- Root is usually drawn at the top and is considered as the #text(fill: orange)[starting point]
  - Root is at level 0 (depth 0)
  - Children of root are drawn at the same level at #text(fill: purple)[level 1] (depth 1)
  - Children of children of root are at #text(fill: purple)[level 2] (depth 2)

#block(sticky: true)[#v(-4em)]
#align(center)[#scale(x: 65%, y: 65%)[
  #raw-render(
    ```dot
    digraph {
      node[shape=rectangle];
      "Depth 0" -> "Depth 1" -> "Depth 2" -> "Depth 3"
      node[shape=circle];
      edge [len=0.1,arrowhead=none];
      A -> B;
      B -> D -> H;
      D -> I;
      D -> J;
      B -> E;
      A -> C -> F;
      C -> G -> K;
    }
    ```,
  )
]]
#v(-2em, weak: true)

=== Complete Binary Tree
- Binary Tree = a tree that every node has at most 2 children
- Complete tree = the tree must be filled with every possible node at every level (except the deepest level which must be filled as far to the left as possible)
  - Blank tree is considered a complete binary tree

#block(sticky: true)[#v(-4em)]
#grid(
  align: horizon,
  columns: (0.2fr, 1fr, 1.2fr, 0.5fr, 0.6fr),
  [
    #scale(x: 60%, y: 60%)[
      #raw-render(
        ```dot
        digraph {
          node[shape=circle];
          edge [len=0.1,arrowhead=none];
          1;
        }
        ```,
      )
    ]
  ],
  [
    #scale(x: 60%, y: 60%)[
      #raw-render(
        ```dot
        digraph {
          node[shape=circle];
          edge [len=0.1,arrowhead=none];
          1 -> 2 -> 4;
          2 -> 5;
          1 -> 3 -> 6;
          3 -> 7;
        }
        ```,
      )
    ]
  ],
  [
    #scale(x: 60%, y: 60%)[
      #raw-render(
        ```dot
        digraph {
          node[shape=circle];
          edge [len=0.1,arrowhead=none];
          1 -> 2;
          1 -> 3;
          1 -> 4;
        }
        ```,
      )
    ]
  ],
  [
    #scale(x: 60%, y: 60%)[
      #raw-render(
        ```dot
        digraph {
          node[shape=circle];
          edge [len=0.1,arrowhead=none];
          1 -> 2 -> 3;
        }
        ```,
      )
    ]
  ],
  [
    #scale(x: 60%, y: 60%)[
      #raw-render(
        ```dot
        digraph {
          node[shape=circle];
          edge [len=0.1,arrowhead=none];
          1 -> 2 -> 4;
          1 -> 3;
        }
        ```,
      )
    ]
  ],
)
#v(-2em, weak: true)
#h(1em) OK #h(8em) OK #h(9em) Not binary #h(2.5em) Not complete (at depth 1) #h(2.5em) OK

=== Exercise
- Draw a Complete Binary Tree that has 4, 5, 8, 10 nodes

Hint: The answer is unique (There are exactly 1 way to draw a complete binary tree of size k)

#block(sticky: true)[#v(-4em)]
#grid(
  align: (center + horizon),
  columns: (0.4fr, 0.48fr, 0.8fr, 0.9fr),
  [
    #scale(x: 60%, y: 60%)[
      #raw-render(
        ```dot
        digraph {
          node[shape=circle];
          edge [len=0.1,arrowhead=none];
          1 -> 2 -> 4;
          1 -> 3;
        }
        ```,
      )
    ]
  ],
  [
    #scale(x: 60%, y: 60%)[
      #raw-render(
        ```dot
        digraph {
          node[shape=circle];
          edge [len=0.1,arrowhead=none];
          1 -> 2 -> 4;
          2 -> 5;
          1 -> 3;
        }
        ```,
      )
    ]
  ],
  [
    #scale(x: 60%, y: 60%)[
      #raw-render(
        ```dot
        digraph {
          node[shape=circle];
          edge [len=0.1,arrowhead=none];
          1 -> 2 -> 4 -> 8;
          2 -> 5;
          1 -> 3 -> 6;
          3 -> 7;
        }
        ```,
      )
    ]
  ],
  [
    #scale(x: 60%, y: 60%)[
      #raw-render(
        ```dot
        digraph {
          node[shape=circle];
          edge [len=0.1,arrowhead=none];
          1 -> 2 -> 4 -> 8;
          4 -> 9;
          2 -> 5 -> 10;
          1 -> 3 -> 6;
          3 -> 7;
        }
        ```,
      )
    ]
  ],
)
#v(-2em, weak: true)

=== Special Property of a Complete Binary Tree
- There is exactly one way to go from any node to any node
- Maximum depth is $log_2 n$ where $n$ is the number of nodes
  - Because we require completeness, and we have 2 possible children

== Binary Heap
Use Complete Binary Tree to make `priority_queue`

#align(center)[#scale(x: 70%, y: 70%)[
  #raw-render(
    ```dot
    digraph {
      rankdir="LR";
      node[shape=rectangle];
      "Graph" -> "Tree" -> "Rooted Tree" -> "Complete Binary Tree" -> "Binary Heap"
    }
    ```,
  )
]]

=== Binary Heap
- We use #text(fill: green)[Complete Binary Tree] to store data
  - A #text(fill: orange)[value] is stored at the #text(fill: orange)[node]
- When data is modified (via `push` or `pop`), we must maintain these rules
  + Tree must always be #text(fill: purple)[Complete Binary Tree]
  + For any node, its #text(fill: purple)[value must be greater or equal that of its children]

#block(sticky: true)[#v(-4em)]
#align(center)[#scale(x: 65%, y: 65%)[
  #raw-render(
    ```dot
    digraph {
      node[shape=circle];
      edge [len=0.1,arrowhead=none];
      75 -> 50 -> 40 -> 35;
      40 -> 36;
      50 -> 3 -> 2;
      75 -> 65 -> 4;
      65 -> 10;
    }
    ```,
  )
]]
#v(-2em, weak: true)

=== Adding data to Binary Heap
- Maintain Binary Heapness
  - structure of data
  - value of data
- Structure rules says where the new nodes should be
  - Next to #text(fill: orange)[right-most child] of #text(fill: orange)[deepest level]
  - But if we put new data there, the #text(fill: red)[value rules might be broken]
    - Fix it

#v(2em, weak: true)
`push(60)`
#block(sticky: true)[#v(-5em)]
#align(center)[#scale(x: 65%, y: 65%)[
  #raw-render(
    ```dot
    digraph {
      node[shape=circle];
      edge [len=0.1,arrowhead=none];
      75 -> 50 -> 40 -> 35;
      40 -> 36;
      50 -> 3 -> 2;
      3 -> "+60";
      75 -> 65 -> 4;
      65 -> 10;
    }
    ```,
  )
]]
#v(-2em, weak: true)

=== Fix from adding a new node
- Fix:
  - Check where we just add a node, if value rules is broken, swap with parent
  - After swap, re-check with new parent
  - Kepp doing until correct or at root

#block(sticky: true)[#v(-4em)]
#align(center)[#scale(x: 65%, y: 65%)[
  #raw-render(
    ```dot
    digraph {
      node[shape=circle];
      edge [len=0.1,arrowhead=none];
      75 -> "*60" -> 40 -> 35;
      40 -> 36;
      "*60" -> "*50" -> 2;
      "*50" -> "*3";
      75 -> 65 -> 4;
      65 -> 10;
    }
    ```,
  )
]]
#v(-2em, weak: true)

See that: after each swap, the swapped nodes does not violate with #text(fill: green)[its new children]

=== Delete maximum data
- Similar to `push`, we will try to maintain structure first
- `delete` will remove root, find something to replace
  - Use the lowest, right-most node
- Value rules might be broken
  - Fix it

#block(sticky: true)[#v(-4em)]
#align(center)[#scale(x: 65%, y: 65%)[
  #raw-render(
    ```dot
    digraph {
      node[shape=circle];
      edge [len=0.1,arrowhead=none];
      "*3" -> 60 -> 40 -> 35;
      40 -> 36;
      60 -> 50 -> 2;
      "*3" -> 65 -> 4;
      65 -> 10;
    }
    ```,
  )
]]
#v(-2em, weak: true)

=== Fix from deleting root node
- Fix:
  - Start at replaced root, if value rules is broken, swap with maximum child
  - After swap, re-check with new children
    - Beware! There is a case where we might have only one child
  - Keep doing until correct or has no children

#block(sticky: true)[#v(-4em)]
#align(center)[#scale(x: 65%, y: 65%)[
  #raw-render(
    ```dot
    digraph {
      node[shape=circle];
      edge [len=0.1,arrowhead=none];
      "*65" -> 60 -> 40 -> 35;
      40 -> 36;
      60 -> 50 -> 2;
      "*65" -> "*10" -> 4;
      "*10" -> 3;
    }
    ```,
  )
]]
#v(-2em, weak: true)

=== Analysis
- How fast is `push`, `pop`
- `push`
  - Add to vector is $cal(O)(1)$ amortized
  - Fixing value rules is $cal(O)(h)$ where $h$ is the maximum number of depth of the tree (we call this value tree height)
  - Notice that tree height is $cal(O)(log(n))$
- `pop`
  - Fixing value rules is $cal(O)(h)$ where $h$ is the maximum number of tree height

== Push + Fix Up

=== How to store a tree?
- Use #text(fill: purple)[dynamic array]
  - Each node can be labelled from `0` to `n-1`
- #text(fill: green)[Root] is #text(fill: green)[at `0`]
- #text(fill: blue)[Left child] of node `i` is #text(fill: blue)[at `(i*2)+1`]
- #text(fill: blue)[Right child] of node `i` is #text(fill: blue)[at `(i*2)+2`]
- #text(fill: orange)[Parent] of node `i` is #text(fill: orange)[at `(i-1)/2`]

#block(sticky: true)[#v(-4em)]
#align(center)[#scale(x: 65%, y: 65%)[
  #raw-render(
    ```dot
    digraph {
      edge [len=0.1,arrowhead=none];
      "0: 75" -> "1: 50" -> "3: 40" -> "7: 35";
      "3: 40" -> "8: 36";
      "1: 50" -> "4: 3" -> "9: 2";
      "0: 75" -> "2: 13" -> "5: 1";
      "2: 13" -> "6: 10";
    }
    ```,
  )
]]
#v(-2em, weak: true)
```
                 0   1   2   3   4   5   6   7   8   9
Dynamic array: [75, 50, 13, 40,  3,  1, 10, 35, 36,  2]
```

=== Layout
```cpp
template <typename T, typename Comp = std::less<T>>
class priority_queue {
  protected:
    T *mData;
    size_t mCap;
    size_t mSize;
    Comp mLess;
    void expand(size_t capacity) {}  // Fix value rules
    void fixUp(size_t idx) {}
    void fixDown(size_t idx) {}
  public:
    // constructor
    priority_queue(priority_queue<T,Comp>& a);
    priority_queue(const Comp& c = Comp());
    priority_queue<T, Comp>& operator=(priority_queue<T,Comp> other);
    ~priority_queue();
    // capacity function
    bool empty() const;
    size_t size() const;
    // access
    const T& top();
    // modifier
    void push(const T& element);
    void pop();
};
```

=== Constructor
- Using #text(fill: purple)[list initialize]
- See that `mData` is dynamic array in the same way as vector
- `mLess` is something that is just either copied or default initialize
  - Will talk about it later

```cpp
priority_queue(const Comp& c = Comp()):
  mData( new T[1]() ),
  mCap( 1 ),
  mSize( 0 ),
  mLess( c )
{ }

priority_queue(priority_queue<T, Comp>& a) :
  mData(new T[a.mCap]()),
  mCap(a.mCap),
  mSize(a.mSize),
  mLess(a.mLess)
{
  for (size_t i = 0; i < a.mCap; i++) {
    mData[i] = a.mData[i];
  }
}
```

=== Destructor and Copy Assignment Operator
- Using standard copy-and-swap idiom

```cpp
~priority_queue() {
  delete [] mData;
}

priority_queue<T,Comp>& operator=(priority_queue<T,Comp> other) {
  using std::swap;
  swap(mSize,other.mSize);
  swap(mCap,other.mCap);
  swap(mData,other.mData);
  swap(mLess,other.mLess);
  return *this;
}
```

=== Push
- See that the #text(fill: orange)[right-most child of the deepest level] is at `mData[mSize-1]` and the new node should be at `mData[mSize]`
- We do the same thing as vector's `push_back`
- Then fix the value rule

```cpp
void expand(size_t capacity) {  // Same as CP::vector
  T *arr = new T[capacity]();
  for (size_t i = 0; i < mSize; i++) {
    arr[i] = mData[i];
  }
  delete [] mData;
  mData = arr;
  mCap = capacity;
}

void push(const T& element) {
  if (mSize + 1 > mCap)
    expand(mCap * 2);
  mData[mSize] = element;
  mSize++;
  fixUp(mSize-1);
}
```

=== Fix Up
- Instead of actual swap, we perform `insert` and `find` appropriate position at the same time
```cpp
void fixUp(size_t idx) {
  T tmp = mData[idx];
  while (idx > 0) {
    size_t p = (idx - 1) / 2;
    if ( tmp < mData[p] ) break;
    mData[idx] = mData[p]
    idx = p;
  }
  mData[idx] = tmp;
}
```

```
mData  p = /, idx = *, tmp = 60
   0   1   2   3   4   5   6   7   8   9  10
[ 75, 50, 13, 40, /3,  1, 10, 35, 36,  2,*60]

[ 75,/50, 13, 40, *3,  1, 10, 35, 36,  2,  3]

[/75,*50, 13, 40, 50,  1, 10, 35, 36,  2,  3]

tmp = 60 < 75 = mData[p] => break;mData[idx] = tmp;
[ 75, 60, 13, 40, 50,  1, 10, 35, 36,  2,  3]
```

=== mLess
- `priority_queue` allows a custom comparator
- Custom comparator $X$
  - We must be able to #text(fill: purple)[$X(a,b)$] where $X$ will comapre $a$ and $b$ and `return` `true` only when $a$ is less than $b$
  - $X$ is a #text(fill: green)[variable] that implement `operator()`

#v(1em)

- Initialize at constructor as variable `mLess` to be of type `Comp` in template
- Any comparison of our data (type `T`) must be done by `mLess`

```cpp
void fixUp(size_t idx) {
  T tmp = mData[idx];
  while (idx > 0) {
    size_t p = (idx - 1) / 2;
    if ( mLess(tmp, mData[p]) ) break;
    mData[idx] = mData[p]
    idx = p;
  }
  mData[idx] = tmp;
}
```

== Pop + FixDown

=== Pop
```cpp
void pop() {
  mData[0] = mData[mSize-1];
  mSize--;
  fixDown(0);
}

void fixDown(size_t idx) {
  T tmp = mData[idx];
  size_t c;
  while ((c = 2 * idx + 1) < mSize) {
    if ( c + 1 < mSize && mLess(mData[c], mData[c+1]) ) c++;
    if ( mLess(mData[c],tmp) ) break;
    mData[idx] = mData[c];
    idx = c;
  }
  mData[idx] = tmp;
}
```

- `while` loop checks if we have #text(fill: blue)[at least one child]
- `c` is the index of #text(fill: green)[highest value child]
  - Must consider the case where we have only one child
- Exercise: read the rest yourself

== Fast Construction

=== Construct PQ from n data
```cpp
priority_queue(std::vector<T> &v, const Comp& c = Comp()) :
    mData( new T[v.size()]() ), mCap( v.size() ), mSize( 0 ), mLess( c ) {
  for (size_t i = 0; i < mSize; i++) push(v[i]);  // n times and each log(n)
}
```

$"Total" &<= floor(log_2 1) + floor(log_2 2) + dots + floor(log_2 n)\
&<= floor(log_2(1 times 2 times 3 times dots.c times n)) = floor(log_2 n!)$\

#box([$floor(log_2 n!)$ is $cal(O)(n log n)$], stroke: 0.6pt, inset: .6em)

=== Better Method
```cpp
priority_queue(std::vector<T> &v, const Comp& c = Comp()) :
    mData( new T[v.size()]() ), mCap( v.size() ), mSize( 0 ), mLess( c )
{
  for (size_t i = 0; i < mSize; i++) mData[i] = v[i];
  for (int i = mSize/2-1; i > 0; i++) fixDown(i);
}
```

- Consider each node to be a binary heap
- Fix down from back to front

=== How fast?
#block(sticky: true)[#v(-8em)]
#align(center)[#scale(x: 52%, y: 52%)[
  #raw-render(
    ```dot
    digraph {
      node[shape=circle];
      edge [len=0.1,arrowhead=none];
      a -> b;
        b -> d;
          d -> h;
            h -> p;
            h -> q;
          d -> i;
            i -> r;
            i -> s;
        b -> e;
          e -> j;
            j -> t;
            j -> u;
          e -> k;
            k -> v;
            k -> w;
      a -> c;
        c -> f;
          f -> l;
            l -> x;
            l -> y;
          f -> m;
            m -> z;
            m -> 1;
        c -> g;
          g -> n;
            n -> 2;
            n -> 3;
          g -> o;
            o -> 4;
            o -> 5;
    }
    ```,
  )
]]
#v(-4em, weak: true)

- Binary Tree Property:
  - There are at most $2^k$ nodes at depth $k$
  - For a tree of height $h$, at depth $k$, fix down needed at most $h-k$ iterations

#let count = 5
#let nums = range(1, count + 1)
#grid(
  align: (left + horizon),
  columns: (1fr, 1fr),
  [
    Total nodes $= 31$\
    Tree height $= log_2(31) = 4$\
    #v(1.5em)
    #table(
      [
        Depth: $k$, Nodes: $2^k$, Max fix: $h-k$\
        Total $= sum_(k=0)^h k 2^(h-k)$],
    )
  ],
  [#table(
    columns: 3,
    table.header[Depth][Nodes][Max fix per node],
    ..{
      let rows = ()
      for n in range(5) {
        let nodes = calc.pow(2, n)
        let max = 4 - n
        rows.push(str(n))
        rows.push(str(nodes))
        rows.push(str(max))
      }
      rows
    },
  )],
)

$
  sum_(k=0)^h k 2^(h-k)
  = 2^h sum_(k=0)^h k 2^(-k)
  < 2^h underbrace(sum_(k=0)^oo k 2^(-k), "This is" 2)
  = 2^(h+1)
  = 2^(log_2 n + 1)
  = cal(O)(n)
$

=== Exercise
If we use different number of children per node, say $4$-ary heap, the same logic would still holds.
+ How to keep data in dynamic array?
+ Write the new functions `fixUp` and `fixDown`
+ Is it faster?? Consider any $n$-ary heap

#box(fill: yellow, inset: 5pt)[Will do this part later]
