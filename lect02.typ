= Lecture 2

== Array & Vector

=== Array
- Two types: Static and Dynamic
- Raw Data
- Fast random access
- Static = size cannot be changes
- Dynamic = can change size

```cpp
#include <iostream>
#include <vector>
#include <algorithm>

using namespace std;

int main() {
  vector<int> a = {2,3};
  vector<bool> b = {true,false,true};

  a.push_back(10);
  a.push_back(20);

  a.insert( a.begin(), 99);
  a.insert( a.end(), -5);

  sort(a.begin(),a.end());

  cout << "a is ";
  for (size_t i = 0; i < a.size(); i++) {
    cout << a[i] << " ";
  }
  cout << endl;

  cout << "b is ";
  for (size_t i = 0; i < b.size(); i++) {
    cout << b[i] << " ";
  }
  cout << endl;
}
```

== Word Count Problem

```cpp
#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <set>
#include <algorithm>
#include "Tokenizer.h"

using namespace std;

void printUniqueWords1(string filename);
void printUniqueWords2(string filename);
void printUniqueWords3(string filename);
void printUniqueWords4(string filename);
void printWord(string filename);

int main() {
  string filename = "test.txt";
  printWord(filename);
  printUniqueWords1(filename);
  printUniqueWords2(filename);
  printUniqueWords3(filename);
  printUniqueWords4(filename);
  return 0;
}

bool search(string words[], int n, string w) {
  for (int i = 0; i < n; i++) {
    if (words[i] == w) return true;
    n++;
  }
  return false;
}

void printWord(string filename) {
  int n = 0;

  Tokenizer tokenizer(filename);
  while(tokenizer.hasNext()) {
    string token = tokenizer.next();
    n++;
  }
  tokenizer.close();
  cout << "A total of " << n << " words" << endl;
}

void printUniqueWords1(string filename) { // wastes too much memory
  string words[100000];
  int n = 0;

  Tokenizer tokenizer(filename);
  while(tokenizer.hasNext()) {
    string token = tokenizer.next();
    if (!search(words,n,token)) words[n++] = token;
  }
  tokenizer.close();
  cout << "A total of " << n << " words" << endl;
}
```

== Dynamic Array

```cpp
void printUniqueWords2(string filename) { // expandable array; wastes time
  int cap = 1;
  string *words;
  words = new string[cap];
  int n = 0;
  Tokenizer tokenizer(filename);
  while(tokenizer.hasNext()) {
    string token = tokenizer.next();
    if (!search(words,n,token)) {
      if (n == cap) {
        string *a = new string[2*cap];
        for (int i=0; i<n; i++) a[i] = words[i];
        delete[] words;
        words = a;
        cap *= 2;
      }
      words[n++] = token;
    }
  }
  tokenizer.close();
  cout << "A total of " << n << " words" << endl;
}
```

== Word Count by Vector & Set

=== Vector

```cpp
void printUniqueWords3(string filename) { // slow find time
  vector<string> words;
  Tokenizer tokenizer(filename);
  while(tokenizer.hasNext()) {
    string token = tokenizer.next();
    if (words.end() = find(words.begin(), words.end(), token))
      words.push_back(token);
  }
  tokenizer.close();
  cout << "A total of " << n << " words" << endl;
}
```

=== Set
```cpp
void printUniqueWords4(string filename) { // quick find existence
  set<string> words;
  Tokenizer tokenizer(filename);
  while(tokenizer.hasNext()) {
    string token = tokenizer.next();
    // if (words.end() == find(words.begin(), words.end(), token)) // slow find
    if (words.end() == word.find(token)) // if can't find then return word.end()
      words.insert(token);
  }
  tokenizer.close();
  cout << "A total of " << n << " words" << endl;
}
```
