#import "@preview/cetz:0.3.4": canvas, draw, tree
= Lecture 6

== Queue

- Just like a normal queue in real life.
  - First-in-First-Out data structure
  - One way in (`back` of queue), one way out (`front` of queue)
  - `push` = add data to the back of the queue
  - `pop` = remove data from the head of the queue

=== Basic
```cpp
#include <iostream>
#include <queue>
#include <vector>

using namespace std;

int main() {
  queue<int> q;
  q.push(1);
  q.push(2);
  q.push(3);
  while (q.empty() == false) {
    cout << q.front() << endl;
    q.pop();
  }
  cout << "-- emaple 2 --" << endl;
  queue<vector<int>> q2;
  vector<int> v1 = {1,2,3};
  vector<int> v2 = {99,88,-1};
  q2.push( v1 );
  q2.push( v2 );
  cout << q2.back()[1] << endl;
  cout << q2.front().size() << endl;
  auto x = q2.front();
  q2.pop();
  cout << x[0] << endl;
}
```

```cpp
size_t     q.size()
bool       q.empty()
void       q.push(T data)
void       q.pop()
T          q.front()
T          q.back()
```

=== Limitation
- Same limitation as stack
  - No iterator
    - No `begin()`, `end()`
    - Can only access front and back of the queue
    - If we wish to access all members, we have to pop it all
  - Do not call `front()`, `back()`, `pop()` when the queue is empty

== Radix Sort
Queue Application: Fast sorting with no comparison

=== Overview
- Put all data in an array
- For each digit $X$, from LSD to MSD
  - PUT TO QUEUE step: Sort by digit $X$ by putting all of data from the array into $B$ queues
    - $B$ is the base of the number
    - For example, for a base 10 number, we will have `Queue[0]` to `Queue[9]`
    - Put into the queue labelled with that digit
  - GET FROM QUEUE step: Start form queue $0$ to queue $B-1$, remove data from the queue and put back to the array

=== Example
Input ` 115  15  42  305  21  8  403`

*Round 1 (digit 0), from queue*
```
  (0)    (1)    (2)    (3)    (4)    (5)    (6)    (7)    (8)    (9)
                                     305
                                      15
          21     42    463           115                    8
```

$=>$ ` 21  42  463  115  15  305  8`

Data is now sorted by the last digits, bacause we pop from queue 0 to 9

*Round 2 (digit 1), from queue*
```
  (0)    (1)    (2)    (3)    (4)    (5)    (6)    (7)    (8)    (9)
    8     15
  305    115     21            42           463
```

$=>$ ` 305  8  115  15  21  42  463`

Data is now sorted by last two digits, because we goes from queue 0 to 9, which is grouped by digit 1 and the data in each queue is sorted by the last digit.

*Round 3 (digit 2), from queue*
```
  (0)    (1)    (2)    (3)    (4)    (5)    (6)    (7)    (8)    (9)
   42
   21
   15
    8    115           305    463
```

$=>$ ` 8  15  21  42  115  305  463`

=== Code
```cpp
#define base 10

int getDigit(int v, int k) {
  // return the kth digit of v (MSD is digit 0)
  int i;
  for (int i=0; i<k; i++) v /= base;
  return v % base;
}

// d = number of digits
void radixSort(vector<int> &data, int d) {
  queue<int> q[base];
  for (int k=0; k<dl k++) {
    for (auto &x : data) {
      q[getDigit(x,k)].push(x);
    for (int i=0,j=0; i<base; i++) {
      while(!q[i].empty()) {
        data[j++] = q[i].front(); q[i].pop();
      }
    }
    }
  }
}
```

== Breadth First Search
Queue Application: Gotta generate 'em all

=== The Problem
- Given a positive integer $X$
- Start with a number $1$, find a sequence of arithmetics operations, either "`* 3`", or "`/ 2`" that makes $1$ into $X$
  - the `/ 2` is integer division, e.g., `5 / 3 = 1` (not 1.6666)
  - The sequence must be as short as possible
- Example
  - `10 = 1 * 3 * 3 * 3 * 3 / 2 / 2 / 2`
  - `31 = 1 * 3 * 3 * 3 * 3 * 3 / 2 / 2 / 2 / 2 / 2 * 3 * 3 / 2`

=== The Idea
- Generate all possible sequences
  - Start with length $1, 2, 3, ...$ until we find one that gives $X$
- This is called an _exhaustsive search_ algorithm
  - Systematically enumerate all possible somethings

=== Tree Structure (Search Tree)
- A structure to illustrate _search_ algorithm
- Divide into steps
  - Start with _intial solution_
  - For each possible outcome (called a _state_) of each step, _generate all_ proper possible _next step_
    - Also, check if the current step is what we needed
- Written as a diagram of _node_ and _edge_

=== Enumerate
#let data = (
  [#align(center)[Fried Rice \ (Initial)]],
  (
    [Fried fish],
    [Tomyum],
    [Hot pot],
    [Curry],
    [Liang],
  ),
  (
    [Steamed fish],
    [Tomyum],
    [Hot pot],
    [Curry],
    [Liang],
  ),
)

#canvas({
  import draw: *

  set-style(content: (padding: .2), fill: gray.lighten(70%), stroke: gray.lighten(70%))

  tree.tree(
    data,
    spread: 2,
    grow: 1.5,
    draw-node: (node, ..) => {
      circle((), radius: .5, stroke: none)
      content((), node.content)
    },
    draw-edge: (from, to, ..) => {
      line((a: from, number: .6, b: to), (a: to, number: .6, b: from), mark: (end: ">"))
    },
    name: "tree",
  )

  // // Draw a "custom" connection between two nodes
  // let (a, b) = ("tree.0-0-0", "tree.0-1-0",)
  // line((a, .6, b), (b, .6, a), mark: (end: ">", start: ">"))
})

=== Back to Our Problem
- Start with 1
- Each step is either `* 3` or `/ 2`
- Issue: might get repeated number
  - Solution: if we have found it, do not generate new step

#let data = (
  [1],
  (
    [0],
  ),
  (
    [3],
    [#strike[1]],
    (
      [9],
      (
        [4],
        (
          [2],
          [#strike[1]],
          [6],
        ),
        (
          [12],
          [#strike[6]],
          [*36*],
        ),
      ),
      (
        [27],
        [13],
        [81],
      ),
    ),
  ),
)

#canvas({
  import draw: *

  set-style(content: (padding: .2), fill: gray.lighten(70%), stroke: gray.lighten(70%))

  tree.tree(
    data,
    spread: 2,
    grow: 1.4,
    draw-node: (node, ..) => {
      circle((), radius: .45, stroke: none)
      content((), node.content)
    },
    draw-edge: (from, to, ..) => {
      line((a: from, number: .6, b: to), (a: to, number: .6, b: from), mark: (end: ">"))
    },
    name: "tree",
  )
})

== M3D2 Code

=== Code
- Queue makes ordering of how we pick a state to enumerate
- From top to bottom and left to right
```cpp
void m3d2(int target) {
  map<int, int> prev;
  queue<int> q;
  int v = 1;
  q.push(1); prev[1] = -1;
  while (!q.empty()) {
    v = q.front(); q.pop();
    if (v == target) break;
    int v2 = v/2;
    int v3 = v*3;
    if (prev[v2] == 0) {q.push(v2); prev[v2] = v;}
    if (prev[v3] == 0) {q.push(v3); prev[v3] = v;}
  }
  if (v == target) showSolution(v, prev);
}
```

=== Display Solution
#table(
  columns: (12%, 5%, 5%, 5%, 5%, 5%, 5%, 5%, 5%, 5%, 5%, 5%, 5%, 5%),
  align: center,
  [`x`], [`0`], [`1`], [`2`], [`3`], [`4`], [`6`], [`9`], [`12`], [`13`], [`27`], [`36`], [`39`], [`40`],
  [`prev[x]`], [`1`], [`-1`], [`4`], [`1`], [`9`], [`2`], [`3`], [`4`], [`27`], [`9`], [`12`], [`13`], [`81`],
)

=== showSolution
```cpp
void showSolution(int v, map<int,int>& prev) {
  string out = "";
  while (prev[v] != -1) {
    if (prev[v] * 3 == v) {
      out = "x3" + out;
    } else {
      out = "/2" + out;
    }
    v = prev[v];
  }
  out = "1" + out;
  cout << out << endl;
}
```

$=>$ ` 36 = 1 * 3 * 3 / 2 * 3 * 3`
