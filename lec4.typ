= Lecture 4

== Vector Iterator

=== Iterator
- Iterator is a _pointer to position_
- First element is `begin()`
- The one _after_ the last element is `end()`
- For insert, valid position is from `begin()` to `end()`, inclusive
- For erase, valid position is from `begin()` up to _before_ `end()`
- Different vector, different iterator
  - `v1.end()` is not the same as `v2.end()`

=== Iterator Arithmetic
- We can add by integer to an iterator
- We can subtract two iterators of the same type
- We can use increment (`++`) and decrement (`--`)

```cpp
#include <iostream>
#include <vector>
using namespace std;

int main() {
  vector<int>   v1 = {0, 10, 20, 30, 40, 50, 60, 70, 80};
  vector<float> v2 = {0.2, -4, 0.13, 3.14, 2.73};

  vector<int>::iterator it1 = v1.begin() + 3; // 30
  vector<float>::iterator it2 = v2.end();     // after 2.73

  // getting value at iterator by using "*" operator
  cout << *it1 << endl;     // 30
  cout << *(it2-1) << endl; // 2.73
  cout << *it1+2 << endl;   // 32

  // iterator arithmetics
  vector<int>::iterator it3 = it1 + 2;
  cout << "data at it3: " << *it3 << endl; // 50
  cout << "different of it3,it1: " << (it3 - it1) << endl; // 2

  vector<float>::iterator it4 = v2.end();
  it4--;
  cout << "data of it4: " << *it4 << endl; // 2.73

  // this cannot be done
  // cout << (it2 - it1) << endl;
}
```

=== Iterator All Elements by Iterator
```cpp
#include <iostream>
#include <vector>
using namespace std;

int main() {
  vector<int>   v1 = {0, 10, 20, 30, 40, 50, 60, 70, 80};
  vector<float> v2 = {0.2, -4, 0.13, 3.14, 2.73};

  cout << "----v1----" << endl;
  auto it = v1.begin();
  while (it < v1.end()) ) { // should use != in other iterator types
    cout << it - v1.begin() << ": " << *it << endl;
    it++;
  }

  cout << "---v2---" << endl;
  for (auto it = v2.begin(); it < v2.end(); it++) {
    cout << it - v2.begin() << ": " << *it << endl;
  }
}
```

- We can compare iterator
  - Beware!! Iterator of some data structure does not support `>` or `<` comparator
  - But for vectors, it's ok
- We can use auto keyword to automatically define a type of a variable

== Iterator Invalidate

=== Some Functions that Use Iterators
```cpp
#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

int main() {
  vector<int>   v1 = {3,0,1,2,4,-3,9,8};
  vector<float> v2 = {10.2, -4, 0.13, 3.14, 2.73};

  auto it1 = min_element(v1.begin(),v1.end());
  auto it2 = max_element(v2.begin()+2,v2.end());

  cout << *it1 << endl; // -3
  cout << *it2 << endl; // 3.14

}
```

- `min_element` and `max_element` get the iterator of min, max element

=== New Idiom that Iterate All Elements
- Shorter syntax for loop
- Can use reference operator (`&`)

```cpp
#include <iostream>
#include <vector>
#include <algorithm>
#include <string>
using namespace std;

int main() {
  vector<string> v1 = {"somchai", "somying", "somsak"};

  // range-based for loop
  for (string x : v1) {
    // x is a copy of each element in v1
    cout << x << ", ";
  }

  // using reference
  // x is THE element of v1, meaning we can modify it
  for (auto &x : v1) { x.replace(0,4,"--"); }
  for (auto &x : v1) { cout << x << " ";} // --hai --ing --ak
  cout << endl;
}
```

=== Iterator Invalidation
```cpp
#include <iostream>
#include <vector>
using namespace std;

int main() {
  vector<int> v1 = {10,20};

  auto = v1.end()-1; // this points to 20
  // we resize (enlarge) v1, now [it] is invalidated
  v1.resize(10);

  // this might not crash but it actually points to somewhere not in v1
  cout << *it << endl;

  // this will crash the program
  // v1.insert(it,99);
  for (auto &x: v1) {cout << x << " ";}
}
```

- Some operation on the data structure _invalidate_ existing iterators
  - For vector, this includes _addition_ and _deletion_ of element (including _resize_)

== Set

- Storing distinct data of same type
  - The data type must be _comparable_, i.e., we can tell if a is more or less than be
- Somewhat slow insert
- Fast look up
- Fast erase
- Iterator starts from "minimum element" and goes in increasing value direction
  - Can be used to (somewhat) fast storing

=== Basic
- Notice that `s` does not include duplicate elements
- Also see that when we iterate, member is sorted
  - This is distinct characteristic of set

```cpp
#include <iostream>
#include <set>
using namespace std;

int main() {
  set<int> s = {4,1,3,2,1,1,3,4};

  cout << "Size of s is " << s.size() << endl; // 4

  s.insert(10);
  s.insert(5);
  s.erase(3);

  cout << "member of s: "; // 1 2 4 5 10
  for (auto it = s.begin(); it != s.end(); it++) {
    cout << *it << " ";
  }
}
```

=== Somewhat Slow Insert, Iterate but Fast Find
- We will see this in the detail around last part of this course
  - For now, please believe that
    - If there are $N$ elements in the set
    - Insert takes time directly proportional to $log(N)$
    - Each `it++` or `it--` takes times directly proportional to $log(N)$
    - Each find takes time directly proportional to $log(N)$

== Set Iterator

=== Demos Comparing Vector & Set

- Insert
  - Vector is faster that set
- Find random number
  - Set is much faster than vector

=== Set Iterator
- We cannot do `s.begin() + x`
  - Because, going to the next element (which is the _successor_) in set is not as fast as vector, c++ forbids `begin() + x`
    - alternatively, you can use ```cpp auto it = s.begin(); for (int i = 0; i < 0; i++) {it++;} ```
  - We cannot _compare by `>` or `<`_
- We can still use `it++` or `it--` to go to the next or previous (_successor_ or _predecessor_) or x

```cpp
#include <iostream>
#include <set>
using namespace std;

int main() {
  set< pair<string,int> > s = { {"somchai",5}, {"abc",6}, {"abcd",-3}, {"somchai",-4},
    {"z",0}, {"z",-1}, {"z",9} };

  for (auto &x : s) {
    cout << x.first << "," << x.second << endl;
  }

  cout << "-- find --" << endl;
  auto it = s.find({"z",-1});
  cout << (*it).first << "," << (*it).second << endl;
  it--;
  it--;
  cout << it->first << "," << it->second << endl;
  it++;
  cout << it->first << "," << it->second << endl;
}
```

=== Additional Function
- `set.lower_bound`
- `set.upper_bound`
- `set.count`

== std::map
Associative data structure with same property as set

=== Map
- Is very similar to Python's `dict` in usage
- Is internally implemented as a set with "pair" data type
  - _Same properties, same limitations_ as set but more convenience to use as associative data structure
- Associative (mapping) between a _Key Type_ and a _Mapped Type_

=== Basic
```cpp
#include <iostream>
#include <map>
using namespace std;

int main() {
  // map between "Key Type" string and "Mapped Type" int
  map<string,int> m;
  m["somchai"] = 10;
  m["somying"] = -5;
  cout << "Size = " << m.size() << endl; // 2

  // accessing unseen key create a map with default value
  cout << "m[\"xxx\"] = " << m["xxx"] << endl; // 0
  // each element is a pair of key type and mapped type
  for (auto it = m.begin(); it != m.end(); it++) {
    cout << it->first << " is mapped to " << it->second << endl;
  } // somchai: 10, somying: -5

  // this will create mapping "abc" to 0 first and then increase it
  m["abc"]++;
  cout << "now size = " << m.size() << endl; // 4
  for (auto &x : m) {
    cout << x.first << " is mapped to " << x.second << endl;
  } // abc: 1, somchai: 10, somying: -5, xxx: 0
}
```

=== Checking If Map Has This Key?
- Use `find()`

```cpp
#include <iostream>
#include <map>
using namespace std;

int main() {
  map<int,string> m;
  m[1] = "somchai";
  m[99] = "nattee";

  int k = 99;
  map<int,string>::iterator it;
  if ((it = m.find()) != m.end()) {
    cout << "Key " << it->first << " is mapped to " << it->second << endl;
  } else {
    cout << "Key " << k << " does not exist in m." << endl;
  }

  // this is not the correct way to check if key exists why??
  if (m[k] != "") {
    cout << "exists" << endl;
  } else {
    cout << "does not exists" << endl;
  }
}
```

=== Requirement of std::set and std::map
- Set data type and map key type must be comparable
  - We must be able to compare _order_ of two elements
- Type that we can use directly
  - int, bool, float, string, double, char, ... and most of other numerical data type
  - Pair can also be used if both the types of first and second are comparable
    - Pair compare first then second

=== Practice Reading C++ Docs
- Both map and set has _insert_ and _erase_ function
- What is the return value of both function of each data structure?
  - For `set<int> s`, can we do `s.erase(20)`
  - For `map<string,bool> m`, can we do `m.erase("Somchai")`??
- If we wish to erase element from index `3` to index `4096` in a vector
  - Is there any function from vector that we can easily use?

== Pair-Sum Problem
- Pair Sum
  - Given an array of integers, out task is to find whether there exists a pair of elements in the array such that their summation equal to _X_
- Input:
  - Array of integers (our main array); this is a large array
  - M values of _X_,  for each value _X_, we have to determine if a pair whose sum equal to _X_ exists.
- Output:
  - For each value of _X_, print "YES" if we found such pair; print "NO" otherwise


*Answer*
```cpp
#include <iostream>
#include <array>
#include <algorithm>
#include <cmath>

using namespace std;

bool check(int a[], int n, int X);

int main() {
    int a[15] = {323, 232, 138, 230, 437, 176, 127, 111, 329, 1, 296, 12, 3, 2, 6};
    int n = sizeof(a) / sizeof(a[0]);
    int X = 10000;

    cout << check(a,n,X);
}

bool check(int a[], int n, int X) {
    for (int i=0; i<(pow(2,n)); i++) {
        int t = X;
        for (int j=0; j<n; j++) {
            if (i / ((int) pow(2,j+1)) % 2 == 0) {
                t -= a[j];
            }

            if (0 == t) {
                cout << "YES" << endl;
                return true;
            }
            if (0 > t) {break;}
        }
    }
    cout << "NO" << endl;
    return false;
} // My stupid solution where I brute force every possible combinations
```
