= Lecture 17
#import "@preview/diagraph:0.3.7": raw-render

== AVL Tree

=== หัวข้อ
- นิยามต้นไม้เอวีแอล
- การวิเคราะห์ความสูงของต้นไม้เอวีแอล
- การปรับต้นไม้เอวีแอลให้สูงสมดุล
- กระบวนการหมุนปม

=== ต้นไม้เอวีแอล
- AVL = Binary Search Tree + กฎความสูงสมดุล
- ต้นไม้ย่อยทุกต้นต้องเป็นไปตามกฎ $|h_L - h_R| <= 1$
- AVL: Adelson-Velskii and Landis

=== ตัวอย่างต้นไม้เอวีแอล
ต้นไม้ว่าง (null) สูง $-1$

#text(size: 3em)[
  add image for 17-1
]



== AVL Balance Rule

=== ต้นไม้ค้นหาแบบทวิภาคเอวีแอล
//
#block(sticky: true)[#v(-22em)]
#align(center)[#scale(x: 15%, y: 30%)[
  #raw-render(
    ```dot
    digraph BST {
        node [shape=diamond, style=filled, fillcolor=gray, label=""];
        edge [arrowhead=none];

        0; 1; 2; 3; 4; 5; 6; 7; 8; 9;
        10; 11; 12; 13; 14; 15; 16; 17; 18; 19;
        20; 21; 22; 23; 24; 25; 26; 27; 28; 29;
        30; 31; 32; 33; 34; 35; 36; 37; 38; 39;
        40; 41; 42; 43; 44; 45; 46; 47; 48; 49;
        50; 51; 52; 53; 54; 55; 56; 57; 58; 59;
        60; 61; 62; 63; 64; 65; 66; 67; 68; 69;
        70; 71; 72; 73; 74; 75; 76; 77; 78; 79;
        80; 81; 82; 83; 84; 85; 86; 87; 88; 89;
        90; 91; 92; 93; 94; 95; 96; 97; 98; 99;
        100; 101; 102; 103;

        0 -> 1; 0 -> 2;
        1 -> 3;
        2 -> 4; 2 -> 5;
        3 -> 6; 3 -> 7;
        4 -> 8;
        5 -> 9; 5 -> 10;
        6 -> 11;
        7 -> 12; 7 -> 13;
        8 -> 14; 8 -> 15;
        9 -> 16;
        10 -> 17; 10 -> 18;
        11 -> 19; 11 -> 20;
        12 -> 21;
        13 -> 22; 13 -> 23;
        14 -> 24;
        15 -> 25; 15 -> 26;
        16 -> 27; 16 -> 28;
        17 -> 29;
        18 -> 30; 18 -> 31;
        19 -> 32;
        20 -> 33; 20 -> 34;
        21 -> 35; 21 -> 36;
        22 -> 37;
        23 -> 38; 23 -> 39;
        24 -> 40;
        25 -> 41; 25 -> 42;
        26 -> 43;
        27 -> 44; 27 -> 45;
        28 -> 46; 28 -> 47;
        29 -> 48;
        30 -> 49; 30 -> 50;
        31 -> 51;
        32 -> 52; 32 -> 53;
        33 -> 54;
        34 -> 55; 34 -> 56;
        35 -> 57; 35 -> 58;
        36 -> 59;
        37 -> 60; 37 -> 61;
        38 -> 62;
        39 -> 63; 39 -> 64;
        40 -> 65; 40 -> 66;
        41 -> 67;
        42 -> 68; 42 -> 69;
        43 -> 70;
        44 -> 71; 44 -> 72;
        45 -> 73;
        46 -> 74; 46 -> 75;
        47 -> 76; 47 -> 77;
        48 -> 78;
        49 -> 79; 49 -> 80;
        50 -> 81;
        51 -> 82; 51 -> 83;
        52 -> 84;
        53 -> 85; 53 -> 86;
        54 -> 87; 54 -> 88;
        55 -> 89;
        56 -> 90; 56 -> 91;
        57 -> 92;
        58 -> 93; 58 -> 94;
        59 -> 95; 59 -> 96;
        60 -> 97;
        61 -> 98; 61 -> 99;
        62 -> 100;
        63 -> 101; 63 -> 102;
        64 -> 103;
    }
    ```,
  )
]]
#v(-20em)

#align(center)[*ต้นไม้ค้นหาแบบทวิภาคที่สร้างจากข้อมูลสุ่ม 100 ตัว*]

#block(sticky: true)[#v(-14em)]
#align(center)[#scale(x: 15%, y: 30%)[
  #raw-render(
    ```dot
    digraph AVL {
        node [shape=diamond, style=filled, fillcolor=gray, label=""];
        edge [arrowhead=none];

        0;
        1; 2;
        3; 4; 5; 6;
        7; 8; 9; 10; 11; 12; 13; 14;
        15; 16; 17; 18; 19; 20; 21; 22; 23; 24; 25; 26; 27; 28; 29; 30;
        31; 32; 33; 34; 35; 36; 37; 38; 39; 40; 41; 42; 43; 44; 45; 46;
        47; 48; 49; 50; 51; 52; 53; 54; 55; 56; 57; 58; 59; 60; 61; 62;
        63; 64; 65; 66; 67; 68; 69; 70; 71; 72; 73; 74; 75; 76; 77; 78;
        79; 80; 81; 82; 83; 84; 85; 86; 87; 88; 89; 90; 91; 92; 93; 94;
        95; 96; 97; 98; 99; 100; 101; 102;

        0 -> 1; 0 -> 2;

        1 -> 3; 1 -> 4;
        2 -> 5; 2 -> 6;

        3 -> 7;  3 -> 8;
        4 -> 9;  4 -> 10;
        5 -> 11; 5 -> 12;
        6 -> 13; 6 -> 14;

        7  -> 15; 7  -> 16;
        8  -> 17; 8  -> 18;
        9  -> 19; 9  -> 20;
        10 -> 21; 10 -> 22;
        11 -> 23; 11 -> 24;
        12 -> 25; 12 -> 26;
        13 -> 27; 13 -> 28;
        14 -> 29; 14 -> 30;

        15 -> 31; 15 -> 32;
        16 -> 33; 16 -> 34;
        17 -> 35; 17 -> 36;
        18 -> 37; 18 -> 38;
        19 -> 39; 19 -> 40;
        20 -> 41; 20 -> 42;
        21 -> 43; 21 -> 44;
        22 -> 45; 22 -> 46;
        23 -> 47; 23 -> 48;
        24 -> 49; 24 -> 50;
        25 -> 51; 25 -> 52;
        26 -> 53; 26 -> 54;
        27 -> 55; 27 -> 56;
        28 -> 57; 28 -> 58;
        29 -> 59; 29 -> 60;
        30 -> 61; 30 -> 62;

        31 -> 63; 31 -> 64;
        32 -> 65; 32 -> 66;
        33 -> 67; 33 -> 68;
        34 -> 69; 34 -> 70;
        35 -> 71; 35 -> 72;
        36 -> 73; 36 -> 74;
        37 -> 75; 37 -> 76;
        38 -> 77; 38 -> 78;
        39 -> 79; 39 -> 80;
        40 -> 81; 40 -> 82;
        41 -> 83; 41 -> 84;
        42 -> 85; 42 -> 86;
        43 -> 87; 43 -> 88;
        44 -> 89; 44 -> 90;
        45 -> 91; 45 -> 92;
        46 -> 93; 46 -> 94;
        47 -> 95; 47 -> 96;
        48 -> 97; 48 -> 98;
        49 -> 99; 49 -> 100;
        50 -> 101; 50 -> 102;
    }
    ```,
  )
]]
#v(-15em)

#align(center)[*ต้นไม้เอวีแอลที่สร้างจากข้อมูลสุ่ม 100 ตัว*]

=== ต้นไม้เอวีแอลสูงเท่าใด ?
- ให้ $F_n$ คือต้นไม้เอวีแอลซึ่งสูง $h$ ที่มีจำนวนปมน้อยสุด

#block(breakable: false)[
  #grid(
    align: center + top,
    columns: (1.2fr, 1.6fr, 1.9fr, 4fr, 5.5fr),
    $F_0$, $F_1$, $F_2$, $F_3$, $F_4$,
    [
      #block(sticky: true)[#v(-1em)]
      #align(center)[#scale(x: 40%, y: 40%)[
        #raw-render(
          ```dot
          digraph G {
            node[shape=circle];
            edge [len=0.1,arrowhead=none];
            ""
          }
          ```,
        )
      ]]
    ],
    [
      #block(sticky: true)[#v(-3.2em)]
      #align(center)[#scale(x: 40%, y: 40%)[
        #raw-render(
          ```dot
          digraph G {
            node[shape=circle];
            edge [len=0.1,arrowhead=none];
            "" -> " ";
            "" -> x [style=invis];
            x [style=invis,label=""];
          }
          ```,
        )
      ]]
    ],
    [
      #block(sticky: true)[#v(-5.4em)]
      #align(center)[#scale(x: 40%, y: 40%)[
        #raw-render(
          ```dot
          digraph G {
            node[shape=circle];
            edge [len=0.1,arrowhead=none];
            "" -> " ";
            "" -> y [style=invis];
            y [style=invis,label=""];
            "" -> "  ";
            "  " -> "   ";
            "  " -> x [style=invis];
            x [style=invis,label=""];
          }
          ```,
        )
      ]]
    ],
    [
      #block(sticky: true)[#v(-7.5em)]
      #align(center)[#scale(x: 40%, y: 40%)[
        #raw-render(
          ```dot
          digraph G {
            node[shape=circle];
            edge [len=0.1,arrowhead=none];
            "" -> " ";
            "" -> y [style=invis];
            y [style=invis,label=""];
            " " -> "  ";
            " " -> x [style=invis];
            x [style=invis,label=""];
            "" -> "   ";
            "   " -> "    ";
            "   " -> z [style=invis];
            z [style=invis,label=""];
            "   " -> "     ";
            "     " -> "      ";
            "     " -> w [style=invis];
            w [style=invis,label=""];
          }
          ```,
        )
      ]]
    ],
    [
      #block(sticky: true)[#v(-9.7em)]
      #align(center)[#scale(x: 40%, y: 40%)[
        #raw-render(
          ```dot
          digraph G {
            node[shape=circle,label=""];
            edge [len=0.1,arrowhead=none];
            r -> a;
            a -> b;
            a -> h [style=invis];
            h [style=invis];
            a -> c;
            c -> d;
            c -> i [style=invis];
            i [style=invis];
            r -> f [style=invis];
            f [style=invis];
            r -> g [style=invis];
            g [style=invis];
            r -> "";
            "" -> " ";
            "" -> y [style=invis];
            y [style=invis,label=""];
            " " -> "  ";
            " " -> x [style=invis];
            x [style=invis,label=""];
            "" -> "   ";
            "   " -> "    ";
            "   " -> z [style=invis];
            z [style=invis,label=""];
            "   " -> "     ";
            "     " -> "      ";
            "     " -> w [style=invis];
            w [style=invis,label=""];
          }
          ```,
        )
      ]]
    ],
  )
]
#v(-9.5em)

$
  |F_h| = 1 + |F_(h-1)| + |F_(h-2)|\
  "Fibonacci Tree"
$

=== ความสูงของต้นไม้ฟิโบนักชี
$
  |F_h| & = 1 + |F_(h-1)| + |F_(h-2)| \
    n_h & = 1 + n_(h-1) + n_(h-2) #h(1.5em) h >= 2, #h(1.5em) n_0 = 1, #h(1.5em) n_1 = 2 \
    n_h & = alpha_1 phi.alt^h + alpha_2 hat(phi.alt)^h - 1, #h(1.5em) phi.alt = 1.618..., #h(1.5em) hat(phi.alt) = -0.618 \
    n_h & approx alpha_1 phi.alt^h \
      h & approx 1 / (log_2 phi.alt) (log_2 n_h) \
      h & approx 1.44(log_2 n_h)
$

สรุป: ต้นไม้เอวีแอลที่มี $n$ ปม สูงไม่เกิน $1.44 log_2 n$

== AVL Rotation

=== ทำอย่างไรให้เป็นไปตามกฎของ AVL
- การเพิ่ม/ลบข้อมูลทำเหมือน BSTree
- แต่หลังการเพิ่ม/ลบ อาจทำให้ผิดกฎสูงสมดุล
- ถ้าผิดกฎต้องปรับต้นไม้

#grid(
  columns: (1fr, 0.2fr, 1fr),
  [
    #block(sticky: true)[#v(-6.5em)]
    #align(center)[#scale(x: 65%, y: 65%)[
      #raw-render(
        ```dot
        digraph G {
          node[shape=circle];
          edge [len=0.1,arrowhead=none];
          2 -> 1 -> 0;
          2 -> 5 -> 3;
          5 -> 6 -> 8 -> 9;
        }
        ```,
      )
    ]]
  ],
  [
    #v(10em)
    #text(size: 1.5em)[
      $
        ==>
      $
    ]
  ],
  [
    #block(sticky: true)[#v(-5em)]
    #align(center)[#scale(x: 65%, y: 65%)[
      #raw-render(
        ```dot
        digraph G {
          node[shape=circle];
          edge [len=0.1,arrowhead=none];
          2 -> 1 -> 0;
          2 -> 5 -> 3;
          5 -> 8 -> 6;
          8 -> 9;
        }
        ```,
      )
    ]]
  ],
)
#v(-5em)

=== map_avl
```cpp
template <typename KeyT,
          typename MappedT,
          typename CompareT = std::less<KeyT> >
class map_avl {
  protected:
    class node {
      friend class map_bst;
      ...
    };

    class tree_iterator {  // เหมือน map_bst
      ...
    };
  public:
    ...
};
```

=== node
```cpp
class node {
  friend class map_avl;
  protected:
    ValueT data;
    node *left;
    node *right;
    node *parent;
    int   height;  // แต่ละปมมีความสูงกำกับ

    node() :
      data( ValueT() ), left( NULL ), right( NULL ),
      parent( NULL ), height(0) { }

    node(const ValueT& data, node* left,
         node* right, node* parent) : data(data),
         left(left), right(right), parent(parent) {
      set_height();
    }

    int get_height(node *n) {  // ไม่ oo ?
      return (n == NULL ? -1 : n->height);
    }
    void set_height() {
      int hL = get_height(this->left);
      int hR = get_height(this->right);
      height = 1 + (hL > hR ? hL : hR);
    }
    int balance_value() {
      return get_height(this->right) -
             get_height(this->left);
    }

    void set_left(node *n) {
      this->left = n;
      if (n != NULL) this->left->parent = this;
    }
    void set_right(node *n) {
      this->right = n;
      if (n != NULL) this->right->parent = this;
    }
};
```

=== การหมุนปม
- การปรับต้นไม้อาศัยการหมุน (rotation)

#grid(
  align: center,
  columns: (1fr, 0.2fr, 1fr),
  [
    #block(sticky: true)[#v(-2.5em)]
    #align(center)[#scale(x: 65%, y: 65%)[
      #raw-render(
        ```dot
        digraph G {
          node[shape=circle];
          edge [len=0.1,arrowhead=none];
          r [shape=square];
          r -> 20 [minlen=2,arrowhead=normal];
          { rank=same; r; 20; }
          20 -> 10 [style=bold];
          10 -> 5;
          10 -> 15 [style=bold];
          20 -> 99;
          5 [shape=house];
          15 [shape=house];
          99 [shape=house];
        }
        ```,
      )
    ]]
  ],
  [
    #v(7.5em)
    #text(size: 1.5em)[
      $
        <==>
      $
    ]
  ],
  [
    #block(sticky: true)[#v(-2.5em)]
    #align(center)[#scale(x: 65%, y: 65%)[
      #raw-render(
        ```dot
        digraph G {
          node[shape=circle];
          edge [len=0.1,arrowhead=none];
          r [shape=square];
          r -> 10 [minlen=2,arrowhead=normal];
          { rank=same; r; 10; }
          10 -> 5;
          10 -> 20 -> 15 [style=bold];
          20 -> 99;
          5 [shape=house];
          15 [shape=house];
          99 [shape=house];
        }
        ```,
      )
    ]]
  ],

  [
    `rotate_left_child(r)`\
    $h_r = max(2+5, 2+15, 1+99)$
  ],
  [],
  [
    `rotate_right_child(r)`\
    $h_r = max(1+5, 2+15, 2+99)$
  ],
)

== CP::map_avl

=== rotate_left_child(r)
```cpp
node *rotate_left_child(node *r) {
  node *new_root = r->left;
  r->set_left(new_root->right);
  new_root->set_right(r);

  new_root->right->set_height();
  new_root->set_height();
  return new_root;
}
```

=== rotate_right_child(r)
```cpp
node *rotate_right_child(node *r) {
  node *new_root = r->right;
  r->set_right(new_root->left);
  new_root->set_left(r);

  new_root->left->set_height();
  new_root->set_height();
  return new_root;
}
```

=== insert และ erase ใช้ rebalance
```cpp
node* insert(const ValueT& val, node *r, node * &ptr) {
  ... // same as insert in map_bst

  r = rebalance(r);  // เพิ่มตามปกติ แล้วค่อยปรับ
  return r;
}

node *erase(const KeyT &key, node *r) {
  ... // same as erase in map_bst

  r = rebalance(r);  // ลบตามปกติ แล้วค่อยปรับ
  return r;
}
```

rebalance
+ `r` เอียงซ้ายมากไป และ `x` (ลูกซ้าย) เอียงซ้าย $=>$ `rotate_left_child(r)`
  - Pls add image
+ `r` เอียงขวามากไป และ `x` (ลูกขวา) เอียงขวา $=>$ `rotate_right_child(r)`
+ `r` เอียงซ้ายมากไป และ `x` (ลูกซ้าย) เอียงขวา $=>$ `rotate_right_child(r->left)  rotate_left_child(r)`
+ `r` เอียงขวามากไป และ `x` (ลูกขวา) เอียงซ้าย $=>$ `rotate_left_child(r->right)  rotate_right_child(r)`

```cpp
node *rebalance(node *r) {
  if (r == NULL) return r;
  int balance = r->balance_value();
  if (balance == -2) {
    if (r->left->balance_value() == 1)  // case 3
      r->set_left(rotate_right_child(r->left));
    r = rotate_left_child(r);
  } else if (balance == 2) {
    if (r->right->balance_value() == -1)  // case 4
      r->set_right(rotate_left_child(r->right));
    r = rotate_right_child(r);
  }
  r->set_height();
  return r;
}
```

=== ตัวอย่าง
#block(breakable: false)[
  ```
      1, 2, 3, 6, 8, 4, 15, 14

    1   1      1          2        2          2            2
         \      \\       / \      / \        / \          / \
          2      2   => 1   3    1   3      1   3     => 1   6
                  \                   \          \\         / \
                   3                   6          6        3   8
                                                   \
                                                    8
      2          2              3            3
     / \        / \\           / \          / \
    1   6   => 1   3     =>   2   6        2   6
      // \          \        /   / \      /   / \
      3   8          6      1   4   8    1   4   8
       \            / \                           \
        4          4   8                           15

        3               3                  3
       / \             / \                / \
      2   6      =>   2   6         =>   2   6
     /   / \         /   / \            /   / \
    1   4   8       1   4   8          1   4   14
             \               \\               /  \
              15              14             8    15
            //                  \
           14                    15
  ```
]

=== สรุป
- ต้นไม้เอวีแอลคือต้นไม้ค้นหาที่ถูกควบคุมความสูง
- ผลต่างความสูงของลูกสองข้างห้ามเกินหนึ่ง
- พิสูจน์ได้ว่า $floor(log_2 n) <= h < 1.44 log_2 n$
- แต่ละปมเก็บความสูงไว้ตรวจสอบ
- ถ้าหลังเพิ่ม/ลดข้อมูลแล้วผิดกฎ ให้ปรับต้นไม้
- การปรับต้นไม้อาศัยการหมุนปม
- เวลาการทำงานของการเพิ่ม ลง และค้นหาเป็น $cal(O)(log n)$


=== ความสูงของต้นไม้ AVL
#grid(
  columns: (1fr, 1fr),
  [
    ```cpp
    class node {
      friend class map_avl;
      protected:
        ValueT data;   // int, int 8
        node  *left;   // 4
        node *right;   // 4
        node *parent;  // 4
        int   height;  // 4
    }
    ```
  ],
  [
    ```cpp
    class node {
      friend class map_avl;
      protected:
        ValueT data;
        node  *left;
        node *right;
        node *parent;
        unsigned char  height;  // 1
    }
    ```
  ],
)

=== นอกเรื่อง
- `std::map` ใช้ Red Black Tree
- self-balanced tree มี AVL, Red Black, Splay



// #block(sticky: true)[#v(-1em)]
// #align(center)[#scale(x: 65%, y: 65%)[
//   #raw-render(
//     ```dot
//     digraph G {
//       node[shape=circle];
//       edge [len=0.1,arrowhead=none];
//       ""
//     }
//     ```,
//   )
// ]]
// #v(-8em)
