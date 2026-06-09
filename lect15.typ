= Lecture 15

== Binary Tree
Practicing Pointer & Recursive

=== Overview
- This is a basic for the next data structure, Binary Search and AVL Tree
- Focus on using Node and Pointer
- Focus on using recursive programming
- Some applications using just Binary Tree
- There is no data in `std` that is Binary Tree

#import "@preview/diagraph:0.3.7": raw-render

=== Binary Tree & Node
#grid(
  columns: (0.5fr, 1fr, 1fr),
  [
    #block(sticky: true)[#v(-4em)]
    #align(center)[#scale(x: 65%, y: 65%)[
      #raw-render(
        ```dot
        digraph {
          node[shape=circle];
          edge [len=0.1,arrowhead=none];
          12 -> 3 -> 4 -> 5;
          12 -> 2;
          4 -> 6;
        }
        ```,
      )
    ]]
  ],
  [
    #block(sticky: true)[#v(-5em)]
    #align(center)[#scale(x: 65%, y: 65%)[
      #raw-render(
        ```dot
        digraph {
          node[shape=ellipse];
          root;
          node [shape=rectangle]
          edge [len=0.1,arrowhead=none];
          root -> "[left, 10, right]";
          "[left, 10, right]" -> "[NULL, 10, right]";
          "[left, 10, right]" -> "[NULL, 10, NULL]";
          "[NULL, 10, right]" -> "NULL";
          "[NULL, 10, right]" -> " [left, 10, right] ";
          " [left, 10, right] " -> " [NULL, 10, NULL] ";
          " [left, 10, right] " -> "  [NULL, 10, NULL]  ";
        }
        ```,
      )
    ]]
  ],
  [
    #v(2em)
    - A rooted tree where each node have at most two children
    - Tree Node is very similar to a linked list node
  ],
)
#v(-3em, weak: true)

```
node
  left data right
  NULL  10  NULL

```

```cpp
class node {
  public:
    ValueT data;
    node *left, *right;
    node() :
      data( ValueT() ), left( NULL ), right( NULL ) { }
    node(const ValueT& data, node* left, node* right) :
      data( data ), left( left ), right( right ) { }
};
```
=== Node with parent link
```cpp
class node {
  public:
    ValueT data;
    node *left, *right, *parent;
    node() :
      data( ValueT() ), left( NULL ), right( NULL ), parent( NULL ) { }
    node(const ValueT& data, node* left, node* right, node* parent) :
      data( data ), left( left ), right( right ), parent( parent ) { }
};
```

- Sometimes, we need a link to parent
- Root is the only node that parent is `NULL`

== String Encoding

=== Huffman Coding: Example Application of Tree
- David Huffman proposed this as his term project in Robert Fano's class (co-worker of Claude Shannon) which beats Shannon-Fano encoding
- Encoding = associate meaning to a representation
- ASCII Code
  - Fix length encoding
  - Each char = 8 bits

=== Variable Length Encoding
#grid(
  columns: (1fr, 1fr),
  [
    #v(1em)
    _Never gonna give you up\
    Never gonna let you down\
    Never gonna run around and desert you_
  ],
  [
    #v(1em)
    16 different characters\
    Fix-length needs $4 times 86 = 344$ bits\
    Variable Length need 327 bits
  ],
)

#table(
  columns: 16,
  align: right + top,

  // Row 1: Characters
  [n], [e], [o], [u], [r], [a], [v], [g], [d], [y], [t], [w], [s], [p], [l], [i],

  // Row 2: Frequencies
  [14], [11], [9], [7], [7], [6], [5], [5], [5], [4], [3], [2], [2], [2], [2], [2],

  // Row 3: Fixed-length binary representations (4-bit)
  [`0000`],
  [`0001`],
  [`0010`],
  [`0011`],
  [`0100`],
  [`0101`],
  [`0110`],
  [`0111`],
  [`1000`],
  [`1001`],
  [`1010`],
  [`1011`],
  [`1100`],
  [`1101`],
  [`1110`],
  [`1111`],

  // Row 4: Variable-length binary codes (Huffman / prefix codes)
  [`11`],
  [`010`],
  [`011`],
  [`0001`],
  [`0011`],
  [`0000`],
  [`1011`],
  [`1010`],
  [`1000`],
  [`0010`\ `1`],
  [`1001`\ `1`],
  [`1001`\ `01`],
  [`0010`\ `001`],
  [`0010`\ `01`],
  [`1001`\ `00`],
  [`0010`\ `000`],
)

Encoding "Never"\
Fix-length #h(3.15em) #text(fill: red)[`0000`]#text(fill: blue)[`0001`]#text(fill: green)[`0110`]#text(fill: blue)[`0001`]#text(fill: purple)[`0100`]\
Variable-length #h(1em) #text(fill: red)[`11`]#text(fill: blue)[`010`]#text(fill: green)[`1011`]#text(fill: blue)[`010`]#text(fill: purple)[`0011`]

== Huffman Coding

=== Problem Statement
- Input: a string
- Output: encoding of each character in the string such that
  - The total length of encoding is minimum
  - The encoding of each character is _not ambiguous_
    - Any character encoding is not a prefix of any other character

=== Tree Encoding
#grid(
  columns: 2,
  column-gutter: 10pt,
  [
    - Using a #text(fill: green)[tree] to represent encoding
    - Each character is represented at #text(fill: red)[leaf nodes]
      - #text(fill: red)[Leaf node] is a node without children
    - Encode by start at the root and #text(fill: orange)[walk toward leaf nodes]
      - The path gives the encoding
      - Going to left child equal to `0`
      - Going to right child equal to `1`
    - Guaranteed to be non-ambiguous

    ```

    a = 010
    b = 011
    c = 1
    ```],
  [
    #block(sticky: true)[#v(-5em)]
    #align(center)[#scale(x: 65%, y: 65%)[
      #raw-render(
        ```dot
        digraph {
          node[shape=circle];
          edge [len=0.1,arrowhead=none];
          "" -> " " -> "  " -> a;
          "  " -> b;
          "" -> c;
        }
        ```,
      )
    ]]
  ],
)
#v(-2em, weak: true)

=== Huffman Tree
- Find 2 min nodes
- Create a new node with those two nodes as children, set freq equal to summation
- Repeat until only one node left

#block(sticky: true)[#v(-8em)]
#align(center)[#scale(x: 65%, y: 65%)[
  #raw-render(
    ```dot
    digraph HuffmanTree {
        nodesep=0.02;
        ranksep=0.3;
        splines=line;
        node [shape=box, style="rounded", fontname="Arial",fontsize=14];

        // --- INTERNAL NODES ---
        N70 [label="70"];
        N41 [label="41"];
        N29 [label="29"];
        N23 [label="23"];
        N18 [label="18"];
        N16 [label="16"];
        N11 [label="11"];
        N12 [label="12"];
        d [label="d:4"];
        N8_left [label="8"];
        N8_right [label="8"];
        N6  [label="6"];
        N4 [label="4"];
        N3  [label="3"];
        N2_left [label="2"];
        N2_right [label="2"];

        // --- LEAF NODES ---
        a [label="a:5"];
        u [label="u:6"];
        i [label="i:1"];
        s [label="s:1"];
        p [label="p:1"];
        y [label="y:3"];
        r [label="r:6"];
        e [label="e:10"];
        o [label="o:8"];
        l [label="l:1"];
        w [label="w:1"];
        t [label="t:2"];
        g [label="g:4"];
        v [label="v:4"];
        n [label="n:13"];

        // --- CORRECT TREE STRUCTURE RELATIONSHIPS ---
        N70 -> N41 [label="0"];
        N41 -> N23 [label="0"];
        N23 -> N11 [label="0"];
        N11 -> a [label="0"];
        N11 -> u [label="1"];
        N23 -> N12 [label="1"];
        N12 -> N6 [label="0"];
        N6 -> N3 [label="0"];
        N3 -> N2_left [label="0"];
        N3 -> p [label="1"];
        N2_left -> i [label="0"];
        N2_left -> s [label="1"];
        N6 -> y [label="1"];
        N12 -> r [label="1"];
        N41 -> N18 [label="1"];
        N18 -> e [label="0"];
        N18 -> o [label="1"];
        N70 -> N29 [label="1"];
        N29 -> N16 [label="0"];
        N16 -> N8_left [label="0"];
        N8_left -> d [label="0"];
        N8_left -> N4 [label="1"];
        N4 -> N2_right [label="0"];
        N4 -> t [label="1"];
        N2_right -> l [label="0"];
        N2_right -> w [label="1"];
        N16 -> N8_right [label="1"];
        N8_right -> g [label="0"];
        N8_right -> v [label="1"];
        N29 -> n [label="1"];

        // --- STABLE HORIZONTAL LEVEL ALIGNMENT ---
        { rank=min; N70; }
        { rank=same; N41; }
        { rank=same; N23; N29; }
        { rank=same; N12; N16; }
        { rank=same; N6; N8_left; }
        { rank=same; N3; N4; }
        { rank=same; N11; N2_left; N18; N2_right; N8_right; }
        { rank=same; a; u; i; s; p; y; r; e; o; d; l; w; t; g; v; n; }
    }
    ```,
  )
]]
#v(-5em, weak: true)

== Huffman Tree

=== Huffman Tree Node
- Instead of data, we have both character and frequency
- Since we have to pick two nodes with minimum freq, we overload `operator<` to do so and use `priority_queue`

=== Huffman Code: Node
```cpp
class huffman_tree {
  protected:
    class huffman_node {
      public:
        char letter;
        int freq;
        huffman_node *left, *right;
        huffman_node() : letter('*'), freq(0), left(NULL), right(NULL) {}
        huffman_node(char letter, int freq, huffman_node *left, huffman_node *right) :
          letter(letter), freq(freq), left(left), right(right) {}

        bool is_leaf() { return left == NULL && right == NULL; }
    };

    class node_comparator {
      public:
        bool operator()(const huffman_node *a, huffman_node *b) {
          return a->freq > b->freq;
        }
    };
};
```

=== Huffman Code: Build Tree
```cpp
class huffman_tree {
  protected:
    huffman_node *root;
    void build_tree(vector<huffman_node*> data) {
      priority_queue<huffman_node*, vector<huffman_node*>, node_comparator> pq;
      for (auto &x : data) pq.push(x);
      while (pq.size > 1) {
        huffman_node *right = pq.top(); pq.pop();
        huffman_node *left = pq.top(); pq.pop();
        pq.push(new huffman_node('*', left->freq+right->freq, left, right));
      }
      root = pq.top();
    }
  public:
    huffman_tree(string s) {
      map<char, int> count;
      for (auto &c : s) {
        count[c]++;  // word count
      vector<huffman_node*> nodes;
      for (auto &x : count)
        nodes.push_back(new huffman_node(x.first, x.second, NULL, NULL));
      build_tree(nodes);
      }
    }
};
```

== Recursive Programming
Calling itself

=== Recursive
- A function that call itself
- Must have some input, usually via function argument
- The function must check a condition for execution
  - Result in either #text(fill: red)[terminating case] where the function won't call itself
  - or #text(fill: green)[recursion case] where the function will call itself #text(fill: blue)[with different parameters]

```cpp
// calculate sum 0..n
int recur1(int n) {
  if (n <= 0) {
    // terminating case
    return 0;
  } else {
    // recursion case
    return recur1(n-1) + n;
  }
}
```

=== Why recursion?
- Much simpler code
  - When the task is right
  - Recursion is natural for several mathematical model that is recursi
- Comparing to a normal loop, recursion has the same growth rate but recursion might take more time because function call is costlier than a loop

=== More Example
#grid(
  columns: (1fr, 1fr),
  align: horizon,
  row-gutter: 10pt,
  [
    ```cpp
    void print_range1(int step, int goal) {
      if (step < goal) {
        std::cout << step << "";
        print_range1(step+1, goal);
      }
    }
    ```
  ],
  [
    - Terminating Case do nothing
    - Which is the output of `print_range1(0,5)` and `print_range2(0,5)`
  ],

  [
    ```cpp
    void print_range2(int step, int goal) {
      if (step < goal) {
        print_range2(step+1, goal);
        std::cout << step << "";
      }
    }
    ```
  ],
  [
    + `0 1 2 3 4 5`
    + `0 1 2 3 4`
    + `5 4 3 2 1 0`
    + `4 3 2 1 0`
  ],
)

=== Binary Tree Recursive Definition
- A Binary Tree is
  - A tree with no nodes (root is `NULL`)
  - A tree with a root
    - Both children of the root must be a binary tree
    - Each child is called left-subtree and right-subtree
- Since binary tree can be defined recursively, operation on a binary tree can be naturallly written as a recursion

=== Subtree
- For any node
  - its left (or right) child and all of the child's descendants is called left-subtree (or right-subtree)

#block(sticky: true)[#v(-5em)]
#align(center)[#scale(x: 65%, y: 65%)[
  #raw-render(
    ```dot
    digraph G {
      node[shape=circle,style=filled,fillcolor=white];
      edge [len=0.1,arrowhead=none];

      // Node outside the group
      12 -> 3 -> 4 -> 5;
      4 -> 6;
      12 -> 2;

      // Subgraph name MUST start with "cluster_"
      subgraph cluster_process_1 {
          label = "Left-subtree of 12";  // Text label for the cluster
          color = blue;                   // Border color
          style = filled;                 // Allows background color fill
          fillcolor = "#abf7b1";          // Background color

          // Nodes belonging to this group
          3; 4; 5; 6;
        }
    }

    ```,
  )
]]
#v(-2em, weak: true)

== Recursion on Binary Tree

=== Tree Size by Recursion
- An empty tree has 0 nodes
- A tree with a root has 1 node (#text(fill: purple)[the root])
  - Plus the size of #text(fill: red)[its two subtrees]
- Easily written as #text(fill: green)[recursive]

```cpp
class node {
  public:
    int data;
    node *left, *right;
};

int get_size(node* n) {
  if (n == NULL) return 0;
  return 1 + get_size(n->left) + get_size(n->right);
}
```

#block(sticky: true)[#v(-5em)]
#align(center)[#scale(x: 65%, y: 65%)[
  #raw-render(
    ```dot
    digraph G {
      rankdir=TB;
      splines=line;
      node[shape=box];
      root;
      node[shape=circle,style=filled,fillcolor=white];
      edge [len=0.1,arrowhead=none];
      { rank=same; root; 12; }

      // Node outside the group
      root -> 12 [label="6=1+4+1"];
      12 -> 3 [label="4=1+0+3"];
      3 -> 4 [label="3=1+1+1"];
      4 -> 5 [label="1=1+0+0"];
      4 -> 6 [label="1=1+0+0"];
      12 -> 2 [label="1=1+0+0"];
    }

    ```,
  )
]]
#v(-2em, weak: true)

=== Tree Height
- Height of a tree is the number of link we have to go to reach it deepest children
- Empty tree has height `-1`
- Height of a tree is `1 + max` of height of its children

```cpp
class node {
  public:
    int data;
    node *left, *right;
};

int get_height(node* n) {
  if (n == NULL) return 0;
  return 1 + std::max(get_height(n->left),
                      get_height(n->right));
}
```

=== Tree Copy
```cpp
class node {
  public:
    int data;
    node *left, *right;
    node() : data(0), left(NULL), right(NULL);
    node(int data, node *left, node *right)
      : data(data), left(left), right(right);
};

node* copy(node *n) {
  if (n == NULL) return NULL;
  node *lc = copy(n->left);
  node *rc = copy(n->right);
  node *result = new node(n->data, lc, rc);
}
```

=== Walk over a tree
- Visiting all nodes (and maybe do something)

#grid(
  columns: (1fr, 1fr),
  [
    ```cpp
    // Preorder traversal
    void preorder(node *n) {
      if (n == NULL) return;
      std::cout << n->data << " ";
      preorder(n->left);
      preorder(n->right);
    }

    // Inorder traversal
    void inorder(node *n) {
      if (n == NULL) return;
      inorder(n->left);
      std::cout << n->data << " ";
      inorder(n->right);
    }

    // Postorder traversal
    void postorder(node *n) {
      if (n == NULL) return;
      postorder(n->left);
      postorder(n->right);
      std::cout << n->data << " ";
    }
    ```
  ],
  [
    #block(sticky: true)[#v(-5em)]
    #align(center)[#scale(x: 65%, y: 65%)[
      #raw-render(
        ```dot
        digraph G {
          node[shape=square]
          a;
          node[shape=circle,style=filled,fillcolor=white];
          edge [len=0.1,arrowhead=none];
          { rank=same; a; 12; }
          a -> 12 [minlen=2,arrowhead=normal];
          12 -> 3 -> 4 -> 5;
          4 -> 6;
          12 -> 2;
        }

        ```,
      )
    ]]
    #v(-4em)
    #block(inset: (x: 3em))[
      What is the result of
      - `preorder(a)`
        - `12 3 4 5 6 2 `
      - `inorder(a)`
        - `5 4 6 3 12 2 `
      - `postorder(a)`
        - `5 6 4 3 2 12 `
    ]
  ],
)

=== Huffman Tree: Encoding
```cpp
class huffman_tree {
  protected:
    class huffman_node { };
    class node_comparator { };
    huffman_node *root;
  public:
    void print(huffman_node *n, string s) {
      if (n->is_leaf()) {
        cout << n->letter << ": " << s << endl;
      } else {
        print(n->left,s+"0");
        print(n->right,s+"1");
      }
    }

    void print() {
      print(root,"");
    }
};
```

- Recursive printing
- Use `s` to store path

```cpp
class huffman_tree {
  protected:
    class huffman_node { };
    class node_comparator { };
    huffman_node *root;

    void delete_node(huffman_node *n) {
      if (n == NULL) return;
      delete_node(n->left);
      delete_node(n->right);
      delete n;
    }

  public:

    ~huffman_tree() {
      delete_node(root);
    }
};
```

- Recursive delete node
- Use postorder traversal
- Can we use inorder or preorder?
