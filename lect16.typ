= Lecture 16
#import "@preview/diagraph:0.3.7": raw-render

== Binary Search Tree
Binary Tree with value condition

=== Overview
- We add additional #text(fill: purple)[value constraint] to a Binary Tree
- The constraint make finding data in the tree much faster
  - #text(fill: green)[$cal(O)(h)$] where $h$ is the height of the tree
  - The tree is expected to have $h$ be in #text(fill: green)[$cal(O)(lg n)$], but this is not always true
  - The next tree (AVL tree) will add more constraint so that we can guarantee that #text(fill: green)[$h = cal(O)(log n)$]
- Using the same approach as a binary heap, maintain the constraint during modification

=== Binary Search Tree
#grid(
  columns: (2.5fr, 1fr),
  [
    - Structure rule: must be a Binary Tree
    - Value rule: for any node #text(fill: green)[`x`]
      - data in #text(fill: red)[left-subtree] must be #text(fill: orange)[less than] the data in #text(fill: green)[`x`]
      - data in #text(fill: purple)[right-subtree] must be #text(fill: blue)[more than] the data in #text(fill: green)[`x`]
    - Recursive Definition
      - An #text(fill: green)[empty tree] is a Binary Search Tree (BST)
      - A node `X` is a BST when
        - Its subtrees (if any) must be BST and
        - If #text(fill: red)[left-subtree] exists, #text(fill: green)[`X->data`] must be more than `X->left->data`
        - If #text(fill: purple)[right-subtree] exists, #text(fill: green)[`X->data`] must be less than `X->right->data`
  ],
  [
    #block(sticky: true)[#v(-1em)]
    #align(center)[#scale(x: 65%, y: 65%)[
      #raw-render(
        ```dot
        digraph G {
          node[shape=circle,style=filled,fillcolor=white];
          edge [len=0.1,arrowhead=none];
          5 -> 4;
          5 -> 6;
        }

        ```,
      )
    ]]
  ],
)

=== Finding Value in BST
- Value rules make finding fast
- To find #text(fill: green)[`e`], start from root
  - If the current node is not #text(fill: green)[`e`],
    - search in left-subtree if #text(fill: green)[`e`] is #text(fill: orange)[less] than the #text(fill: green)[current node]
    - search in right-subtree if #text(fill: green)[`e`] is #text(fill: blue)[more] than the #text(fill: green)[current node]
  - Keep going until we find #text(fill: green)[`e`] or reach #text(fill: purple)[`NULL`]
- Other operation is also depends on `find`

#block(sticky: true)[#v(-8em)]
#align(center)[#scale(x: 65%, y: 65%)[
  #raw-render(
    ```dot
    digraph G {
      node[shape=box];
      a [label="Find 9"];
      node[shape=circle,style=filled,fillcolor=white];
      a -> 45 [label="9 is less than 45, search left-subtree"];
      { rank=same; a; 45; }
      edge [len=0.1,arrowhead=none];
      splines=line;
      45 -> 2 [arrowhead=normal,label="9 is more than 2, search right-subtree"];
      2 -> 0 -> 1;
      2 -> 20 [arrowhead=normal, label="9 is less than 20, search left-subtree"];
      20 -> 9 [arrowhead=normal,label="Found!"];
      20 -> 21;
      9 -> 3;
      9 -> 14;
      45 -> 55 -> 49 -> 48 -> 46;
      49 -> 53 -> 50 -> 52;
      55 -> 70 -> 56;
      70 -> 88;
    }

    ```,
  )
]]
#v(-8em)

== Insert && Erase with 0, 1 child

=== Find Node
```cpp
node* find_node(const ValueT& k, node* r, node* &parent) {
  node *ptr = r;
  while (ptr != NULL) {
    int cmp == compare(k, ptr->data);  // return -1 if a < b, 1 if a > b, 0 if equal
    if (cmp == 0) return ptr;
    parent = ptr;
    ptr = cmp < 0 ? ptr->left : ptr->right;
  }
  return NULL;
}
```

=== Insert
- Assumption: Data in BST is unique
- #text(fill: green)[`insert(e)`] by find #text(fill: green)[`e`]
  - If #text(fill: green)[`e`] is found, don't add any node
  - If #text(fill: green)[`e`] is not in BST, find must reach #text(fill: purple)[`NULL`] somewhere, that #text(fill: purple)[`NULL`] is where to put #text(fill: green)[`e`]
- Both structure and value constraints are satisfied

=== Erase
- #text(fill: green)[`erase(e)`] first have to find #text(fill: green)[`e`] as well
- If not found, do nothing
- If found at node #text(fill: orange)[`X`], there are #text(fill: orange)[3 cases] depend on the number of children of `e`
  - If has #text(fill: red)[no child], just simply `delete` #text(fill: orange)[`X`]
  - If has #text(fill: purple)[one child], have parent of `X` #text(fill: blue)[points] (using the same link) #text(fill: blue)[to the child of] #text(fill: orange)[`X`] instead
  - If has #text(fill: orange)[two children], pick either #text(fill: blue)[successor] or #text(fill: red)[predecessor] of #text(fill: green)[`e`]
    - Assume we choose #text(fill: blue)[successor `p`] (must be in right-subtree), replace #text(fill: orange)[`X`] with #text(fill: blue)[`p`] and #text(fill: green)[`erase(p)`] from right subtree

== Erase with 2 children

=== Erase node with 2 children
- Replace by #text(fill: blue)[successor] (or #text(fill: red)[predecessor]) preserves value rules
  - #text(fill: blue)[Successor] is the minimum in the #text(fill: purple)[right-subtree]
  - #text(fill: red)[Predecessor] is the maximum in the #text(fill: orange)[left-subtree]
- Both exists (because the node has both subtrees)

#grid(
  columns: 2,
  [
    #block(sticky: true)[#v(-4em)]
    #align(center)[#scale(x: 65%, y: 65%)[
      #raw-render(
        ```dot
        digraph G {
          node[shape=box];
          a [label="Erase 49"];
          node[shape=circle,style=filled,fillcolor=white];
          a -> 49;
          { rank=same; a; 49; }
          { rank=same; 50; b; }
          edge [len=0.1,arrowhead=none];
          splines=line;
          49 -> 48 -> 46;
          48 -> x1 [style=invis];
          x1 [style=invis,label=""];
          49 -> x [style=invis];
          x [style=invis,label=""];
          49 -> 53;
          53 -> 50;
          53 -> b [style=invis];
          b [style=invis,label="◀ Successor"];
          50 -> x3 [style=invis];
          x3 [style=invis,label=""];
          50 -> 52;
        }

        ```,
      )
    ]]
  ],
  [
    #block(sticky: true)[#v(-4.2em)]
    #align(center)[#scale(x: 65%, y: 65%)[
      #raw-render(
        ```dot
        digraph G {
          node[shape=circle,style=filled,fillcolor=white];
          { rank=same; 52; b; }
          edge [len=0.1,arrowhead=none];
          splines=line;
          50 -> 48 -> 46;
          48 -> x1 [style=invis];
          x1 [style=invis,label=""];
          50 -> x [style=invis];
          x [style=invis,label=""];
          50 -> 53;
          53 -> 52;
          53 -> b [style=invis];
          b [style=invis,label="◀ Removed 50"];
          52 -> x3 [style=invis];
          x3 [style=invis,label=""];
        }

        ```,
      )
    ]]
  ],
)
#v(-5em)

== Find min max

=== Finding Successor and Predecessor
#grid(
  columns: (1fr, 1fr),
  row-gutter: 1.5em,
  [
    - If a tree has #text(fill: orange)[left-subtree], `min` is the min of #text(fill: orange)[left-subtree]
      - If not, `min` is the root
  ],
  [
    - If a tree has #text(fill: purple)[right-subtree], `max` is the max of #text(fill: purple)[right-subtree]
      - If not, `max` is the root
  ],

  [
    ```cpp
    node* find_min_node(node* r) {
      // r must not be NULL
      node *min = r;
      while (min->left != NULL) {
        min = min->left;
      }
      return min;
    }
    ```
  ],
  [
    ```cpp
    node* find_max_node(node* r) {
      // r must not be NULL
      node *max = r;
      while (max->right != NULL) {
        max = max->right;
      }
      return max;
    }
    ```
  ],
)

=== Finding Successor and Predecessor (recursive)
#grid(
  columns: (1fr, 1fr),
  [
    ```cpp
    node* find_min_node(node* r) {
      // r must not be NULL
      if (r->left == NULL) return r;
      return find_min_node(r->left);
    }
    ```
  ],
  [
    ```cpp
    node* find_max_node(node* r) {
      // r must not be NULL
      if (r->right == NULL) return r;
      return find_max_node(r->right);
    }
    ```
  ],
)

=== Complexity Analysis
- `insert`, `erase` depends on #text(fill: blue)[`find`], #text(fill: blue)[`find_min`] (or #text(fill: blue)[`find_max`])
- All finds start from root and in the worst case reach the leaf
  - Hence, #text(fill: purple)[$cal(O)(h)$]
- Height of the tree can be in the range from #text(fill: green)[$lg n$] to #text(fill: green)[$n$]
- For #text(fill: red)[$1,000,000$] nodes, it's in the range of #text(fill: red)[$[20,999999]$]
  - #text(fill: purple)[$cal(O)(h)$] is, right now, #text(fill: red)[$cal(O)(n)$]
  - Will be fixed by AVL tree

== CP::map_bst (insert)
Using Binary Search Tree to create associated data structure

=== Layout
- Need node class
- Also need iterator class
- Template has two types
  - Key Type and Mapped Type
  - ValueType is `pair<KeyType, MappedType>`
- Also need custom comparator

```cpp
template <typename KeyT,
          typename MappedT,
          typename CompareT = std::less<KeyT> >
class map_bst {
  protected:
    typedef std::pair<KeyT,MappedT> ValueT;
    class node {
      friend class map_bst;
      protected:
        ValueT data;
        node  *left;
        node  *right;
        node  *parent;
    };
    class tree_iterator {
      protected:
        node* ptr;
      public:
    };
    node    *mRoot;
    CompareT mLess;
    size_t   mSize;
  public:
    typedef tree_iterator iterator;
};
```

=== Node class
- Data stores both the key type and mapped type (as a pair)
- Map finds by key

```cpp
class node {
  friend class map_bst;
  protected:
    ValueT data;
    node  *left;
    node  *right;
    node  *parent;

  node() :
    data( ValueT() ), left( NULL ), right( NULL ), parent( NULL ) { }

  node(const ValueT& data, node* left, node* right, node* parent) :
    data( data ), left( left ), right( right ), parent( parent ) { }
};
```

=== Ctors, Dtor
```cpp
map_bst(const map_bst<KeyT, MappedT, CompareT> & other) :
  mLess(other.mLess), mSize(other.mSize)
{ mRoot = copy(other.mRoot, NULL); }  // recursive copy

map_bst(const CompareT& c = CompareT() ) :
  mRoot(NULL), mLess(c), mSize(0)
{ }

map_bst<KeyT, MappedT, CompareT>& operator=(map_bst<KeyT, MappedT, CompareT> other) {
  using std::swap;
  swap(this->mRoot, other.mRoot);
  swap(this->mLess, other.mLess);
  swap(this->mSize, other.mSize);
  return *this;
}

~map_bst() {
  clear();  // recursive delete
}
```

=== Actual Find
```cpp
iterator find(const KeyT &key) {
  node *parent;
  node *ptr = find_node(key, mRoot, mParent);
  return ptr == NULL ? end() : iterator(ptr);
}
```
- Find by Key
```cpp
int compare(const KeyT& k1, const KeyT& k2) {
  if (mLess(k1, k2)) return -1;
  if (mLess(k2, k1)) return 1;
  return 0;
}

node* find_node(const KeyT& k, node* r, node* &parent) {  // modify parent pointer
  node *ptr = r;
  while (ptr != NULL) {
    int cmp = compare(k, ptr->data.first);
    if (cmp == 0) return ptr;
    parent = ptr;
    ptr = cmp < 0 ? ptr->left : ptr->right;
  }
  return NULL;
}
```

=== Insert
- `insert` returns pair of iterator and insert result

```cpp
std::pair<iterator, bool> insert(const ValueT& val) {
  node *parent = NULL;
  node ptr* = find_node(val.first, mRoot, parent);
  bool not_found = (ptr==NULL);
  if (not_found) {
    ptr = new node(val, NULL, NULL, parent);
    child_link(parent, val.first) = ptr;
    mSize++;
  }
  return std::make_pair(iterator(ptr), not_found);
}
```

`child_link` returns a reference (the variable) to the pointer of the appropriate child of the parent with respect to #text(fill: blue)[`k`]

```cpp
node* &child_link(node* parent, const KeyT& k) {
  if (parent == NULL) return mRoot;
  return mLess(k, parent->data.first) ?
          parent->left : parent->right;
}
```

== CP::map_bst (erase and iterator)

=== Erase
- Handle multiple cases

```cpp
size_t erase(const KeyT &key) {
  if (mRoot == NULL) return 0;  // empty tree
  node *parent = NULL;
  node *ptr = find_node(key, mRoot, parent);
  if (ptr == NULL) return 0;  // not found
  if (ptr->left != NULL && ptr-> != NULL) {
    // have two children => erase min
    node *min = find_min_node(ptr->right);  // successor
    // remove min like case 0 or 1 child
    node * &link = child_link(min->parent, min->data.first);
    link = (min->left == NULL) ? min->right : min->left;
    if (link != NULL) link->parent = min->parent;
    // swap min with ptr
    std::swap(ptr->data.first, min->data.first);
    std::swap(ptr->data.second, min->data.second);
    ptr = min;  // we are going to delete this node instead
  } else {
    // case 0 or 1 child => erase ptr
    node * &link = child_link(ptr->parent, key); // find the pointer that holds ptr
    link = (ptr->left == NULL) ? ptr->right : ptr->left;  // replace it with ptr child
    if (link != NULL) link->parent = ptr->parent;  // if child exists, update parent
  }
  delete ptr;
  mSize--;
  return 1;
}
```

=== Operator[]
```cpp
MappedT& operator[](const KeyT& key) {
  node *parent = NULL;
  node *ptr = find_node(key, mRoot, parent);
  if (ptr == NULL) {
    ptr = new node(std::make_pair(key, MappedT()), NULL, NULL, parent);
    child_link(parent, key) = ptr;
    mSize++;
  }
  return ptr->data.second;
}
```

- Find node
- If not exists, create one with default `MappedTypeReturn MappedType` of the node

=== Iterator
- Just like linked list, we need a class for iterator
  - Because we need custom `operator++`, `--` (and some more)
- Iterator class just store a #text(fill: orange)[pointer to a node]

```cpp
class tree_iterator {
  protected:
    node* ptr;

  public:
    tree_iterator() : ptr( NULL ) { }
    tree_iterator(node *a) : ptr(a) { }
    // more functions below
};
```

=== Other Functions
```cpp
tree_iterator operator++(int) {  // ++it
  tree_iterator tmp(*this);
  operator++();
  return tmp;
}

tree_iterator operator--(int) {  // --it
  tree_iterator tmp(*this);
  operator--();
  return tmp;
}

ValueT& operator*() { return ptr->data; }
ValueT* operator->() { return &(ptr->data); }
bool    operator==(const tree_iterator& other)
  { return other.ptr == ptr; }
bool    operator!=(const tree_iterator& other)
  { return other.ptr != other }
```

=== Operator++
- Find #text(fill: blue)[successor] of #text(fill: green)[`x`], easy if #text(fill: green)[`x`] have #text(fill: purple)[right-subtree]
  - Just find #text(fill: orange)[min] of #text(fill: purple)[right-subtree]
- If not, we have to go up (go toward root) until we find one that is #text(fill: blue)[more] than `x`
  - This is always the closest #text(fill: orange)[ancestor] of #text(fill: green)[`x`] that has #text(fill: green)[`x`] in its #text(fill: red)[left-subtree]

```cpp
tree_iterator& operator++() {
  if (ptr->right == NULL) {
    node *parent = ptr->parent;
    while (parent != NULL &&
           parent->right == ptr) {
      ptr = parent;
      parent = ptr->parent;
    }
    ptr = parent;
  } else {
    ptr = ptr->right;
    while (ptr->left != NULL)
      ptr = ptr->left;
  }
  return (*this);
}
```

=== Summary
- Binary Search Tree relies on #text(fill: blue)[Value Constraint] to make `find` fast
  - Possible to be slow (will be fixed later)
- Erase requires `find_min`, `find_max`
- `CP::map_bst` uses pair to store #text(fill: orange)[`KeyT`] and #text(fill: orange)[`MappedT`]
  - `find` uses `key`
- #text(fill: red)[Iterator] is just a pointer
  - Have a problem of #text(fill: purple)[`operator--`] at #text(fill: purple)[`end()`] (will be fixed later)
