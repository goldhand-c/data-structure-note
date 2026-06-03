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

*V0.1 complexities*
#table(
  columns: 2,
  column-gutter: 16pt,
  stroke: none,
  [`push`], [$cal(O)(1)$ \*amortized],
  [`top()`], [$Theta(n)$],
  [`pop()`], [$Theta(n)$],
)

===
