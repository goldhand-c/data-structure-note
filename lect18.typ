= Lecture 18

== Hash Table

=== *หัวข้อ*
- การใช้ตารางเก็บข้อมูลด้วยฟังก์ชันดัชนี
- การเก็บข้อมูลแบบแยกกันโยง
- ฟังก์ชันแฮช
- กลวิธีการเขียนฟังก์ชันแฮช
- การแฮชใน C++
- การกำหนดเลขที่อยู่เปิด
- การเกาะกลุ่มของข้อมูล

=== *ใช้ฟังก์ชันดัชนีคำนวณตำแหน่ง*
- `key` ของข้อมูลคือส่วนของข้อมูลที่ใช้ในการค้น
- มีตารางซึ่งแต่ละช่องเป็นที่เก็บข้อมูล
- หา `f(key)` เพื่อแปลง `key` ไปเป็น `index` ของตาราง
- ฟังก์ชันดัชนีหาไม่ยาก ถ้าจองตารางขนาดใหญ่

=== *ฟังก์ชันดัชนีนั้นหายาก*
- เมื่อต้องเก็บอย่างประหยัด
- เมื่อต้องประกันว่าไม่เกิดการ "ชน"

=== *เปลี่ยนกลยุทธ์*: *อนุญาตให้ชนกันได้*
- จะได้เก็บข้อมูลในตารางที่ไม่ใหญ่มาก
- แต่ต้องหาวิธีแก้ไขปัญหาการชน ที่ทำงานได้เร็ว ๆ
  #align(center)[Separate Chaining]#v(.8em)
- จัดเก็บข้อมูลที่ชนกันไว้ในรายการเดียวกัน

```
0 [ ] --▶ < 14, 7 >
1 [ ] --▶ < 22, 1 >
2 [ ] --‖
3 [ ] --▶ < 3, 38 >          h(x)= x % 7
4 [ ] --▶ < 46 >
5 [ ] --▶ < 40 >
6 [ ] --▶ < 6, 13, 27, 20 >
```

=== *การกระจายข้อมูล*
#grid(
  align: (left, center),
  columns: (1fr, 1fr),
  row-gutter: 12pt,
  [
    - ถ้าข้อมูลกระจายทั่วตาราง
      - แต่ละช่องเก็บรายการยาว $approx lambda$
      - ถ้า $lambda$ น้อย ค้นหาได้เร็ว
    - ถ้าไม่กระจาย
      - มีบางรายการยาวเกิน $lambda$ มาก
      - การค้นหาช้าเหมือนเก็บด้วย list
  ],
  [
    load factor\
    $ lambda = n \/ m $
    $n =$ ปริมาณข้อมูล\
    $m =$ ขนาดของตาราง
  ],

  [
    #text(size: 8pt)[
      ```
      0 [ ] --‖
      1 [ ] --▶ < 401, 321, 105, 185, 129 >
      2 [ ] --‖
      3 [ ] --‖
      4 [ ] --‖
      5 [ ] --▶ < 180, 260, 60, 252, 92, 764,
      6 [ ] --‖              4, 76, 28, 108 >
      7 [ ] --‖
                    h(x) = x % 8
      ```
    ]
  ],
  [
    #text(size: 8pt)[
      ```
                h(x) = x % 10
        0 [ ] --▶ < 180, 260, 80 >
        1 [ ] --▶ < 401, 321 >
        2 [ ] --▶ < 252, 92 >
        3 [ ] --‖
        4 [ ] --▶ < 764, 4 >
        5 [ ] --▶ < 105, 185 >
        6 [ ] --▶ < 76 >
        7 [ ] --‖
        8 [ ] --▶ < 28, 108 >
        9 [ ] --▶ < 129 >
      ```
    ]
  ],
)

== Hash Function

=== *ฟังก์ชันแฮช* (Hash Function)
- #link("www.webster.com")
  - #text(fill: red)[hash]: to chop (as meat and potatoes) into small pieces
- สอ เศถบุตร
  - สับ แหลก นำมาโขลกเข้าด้วยกัน

=== *ตัวอย่างฟังก์ชันแฮช*
```cpp
size_t h1(size_t x) {
  return (2654435769U * x) >> 22;
}

size_t h2(size_t x) {
  x = ~x + (x << 15);
  x ^= (x >> 11);
  x += (x << 3);
  x ^= (x >> 5);
  x += (x << 10);
  x ^= (x >> 16);
  return x & 0x3FF;
}
```

#table(
  columns: 9,
  align: right,
  table.header[`x`][`1`][`2`][`3`][`4`][`5`][`6`][`7`][`8`],
  [`h1(x)`], [`632`], [`241`], [`874`], [`483`], [`92`], [`725`], [`334`], [`966`],
  [`h2(x)`], [`500`], [`1001`], [`507`], [`978`], [`486`], [`1014`], [`403`], [`933`],
)

=== *การวิเคราะห์เลขโดด* (Digit Analysis)
- คัดเลือกเลขโดดบางหลักของคีย์มาพิจารณา
- มั่นใจว่าที่ตัดไปไม่ทำให้เกิดความเอนเอียงในการกระจายของคีย์
- เช่น
  - รหัสนิสิตวิศวฯ ป.ตรี มีรูปแบบ: `xx3xxxxx21`
  - ก็ตัดเลข `3` และ `21` ออกจากการพิจารณา
  - $"k" = 4830109521$
  - $"k1" = floor("k" \/ 100)$ #text(fill: rgb("#6A737D"))[`         // k1 = 48301095`]
  - $"k2" = floor("k1" \/ 100)$ #text(fill: rgb("#6A737D"))[`        // k2 = 48`]
  - $"k3" = "k2"*10^5 + "k1"%10^5$ #h(.2em) #text(fill: rgb("#6A737D"))[` // k3 = 4801095`]

=== *การคูณ* (Multiplicative Hashing)
- คูณคีย์ด้วยจำนวนจริง $A$ ที่มีค่าระหว่าง $(0,1)$
- นำเศษมาคูณกับขนาดของตาราง ($m = 2^p$)

$
  h(x) = floor(m((x A - floor(x A))))
$

=== *การคูณ*: Fibonacci Hashing
- ถ้า $A = "golden ratio" 0.6180339887$ จะแยกคีย์ที่มีค่าใกล้กันออกจากกันได้ดี

```cpp
size_t multHash(size_t x, size_t p) {
  size_t s = 2654435769U;  // 0.6180339887*2^32
  size_t hash = (s * x);
  return (hash >> (32-p));
}

for (size_t i = 0; i < 10; i++) {
  cout << multHash(i, 10) << ", ";
}

0, 632, 241, 874, 483, 92, 725, 334, 966
```

=== *การพับ* (Folding)
- แบ่งคีย์ออกเป็นส่วน ๆ แล้วนำมา "รวม" กัน
- "รวม" $equiv$ บวก, xor, ...

=== *การหาร* (Modulus Hashing)
- `h(x) = x % p`
- ไม่ควรเลือก
  - $p = 10^q$ เพราะเลือกเฉพาะ $q$ หลักขวา ถ้าคีย์เป็นหลักสิบ
  - $p = 2^q$ เพราะเลือกเฉพาะ $q$ บิตขวา
  - $p$ ที่มีค่าน้อย ๆ เป็นตัวประกอบ
    - ถ้า $c$ คือตัวประกอบร่วมของ $p$ และ $x$
    - ค่า $x % p$ จะเป็นจำนวนเท่าของ $c$
    - ถ้า $c$ มีค่าน้อย ๆ จะมีคีย์จำนวนมากที่ได้ $x % p$ มีค่าเป็นจำนวนเท่าของตัวประกอบนั้น ซึ่งไม่กระจาย
  - โดยทั่วไปเลือก $p$ ที่เป็นจำนวนเฉพาะ

=== c++11 std::unordered_map
```cpp
#include <iostream>
#include <unordered_map>

using namespace std;

int main() {
  unordered_map<string, int> facultyCode;
  facultyCode["engineering"] = 21;
  facultyCode["accounting" ] = 26;
  facultyCode["science"    ] = 23;

  cout << facultyCode["engineering"]   << endl;
  cout << facultyCode["science"]       << endl;
  cout << facultyCode["communication"] << endl;

  return 0;
}
```

=== c++11 std::hash
```cpp
#include <functional>
using namespace std;
int main() {
  hash<string> hStr;
  hash<float>  hFloat;
  hash<int>    hInt;

  cout << hStr("C++")  << endl;  // 2262514926
  cout << hFloat(1.2f) << endl;  // 2462087341
  cout << hInt(123)    << endl;  // 123

  return 0;
}

cout << hash<string>()("C++") << endl;
cout << hash<float>()(1.2f)   << endl;
cout << hash<int>()(123)      << endl;
```

=== *อยากใช้* Book *เป็นคีย์*
```cpp
class Book {
public:
  string title;
  int    edition;
  double price;

  Book(string title, int ed = 1, double price = 199.0) :
    title(title), edition(ed), price(price)
  {}
  ...
};
```

=== *เขียน* Hasher class, Equal class
```cpp
class BookHasher {
public:
  size_t operator()(const Book& b) const {
    return hash<string>()(b.title) ^ hash<int>()(b.edition);
  }
};

class BookEqual {
public:
  bool operator()(const Book& b1, const Book b2) const {
    return b1.title==b2.title && b1.edition==b2.edition;
  }
};

unordered_map<Book,string,BookHasher,BookEqual> m;
m[Book("Data Structures", 1, 200)] = "reserved";
m[Book("Algorithm",       5, 200)] = "available";

Book b1("Data Structures, 1");
Book b2("algorithm", 5);

cout << m[b1] << endl;  // "reserved"
cout << m[b2] << endl;  // ""
```

=== *ปฏิทรรศน์วันเกิด* (Birthday Paradox)
- ต้องมีคนในห้องกี่คนขึ้นไป จึงจะเกิดโอกาสเกินครึ่งที่จะมีคนเกิดวันเดียวกันสองคนขึ้นไป

1 คน โอกาสที่มีวันเกิดไม่ซ้ำกัน $= (366/366)$

2 คน โอกาสที่มีวันเกิดไม่ซ้ำกัน $= (366/366)(365/366)$

3 คน โอกาสที่มีวันเกิดไม่ซ้ำกัน $= (366/366)(365/366)(364/366)$

`k` คน โอกาสที่มีวันเกิดไม่ซ้ำกัน $= (366/366)(365/366)(364/366) dots.c ((366-k+1)/366)$

#v(2em, weak: true)
$
  1 - (366/366)(365/366)(364/366) dots.c ((366-k+1)/366) > 0.5
$

#align(center)[#image("images/Birthday_paradox_approximation.svg", width: 67%)]

== CP::unordered_map

=== `CP::unordered_map<KeyT, MappedT>`
```cpp
bucket count = 10
[ ] -▶ [ * , * ] <-- bucket size = 2
[ ] -▶ [ * , * ]
[ ] -▶ [ * , * ]
[ ] -▶ [ * ,(*)] -▶ pair<key, mappedValue>
[ ] -▶ [ * , * ]
[ ] -▶ [ * , * ]
[ ] -▶ [ ] <-- bucket size = 0
[ ] -▶ [ ]
[ ] -▶ [ * , * , * ]
[ ] -▶ [ * , * , * ]
 ▲       ▲ vector< ValueT > = BucketT
 |
 vector< vector< ValueT > > = vector< BucketT >

 typedef pair<KeyT, MappedT> ValueT;
 typedef vector< ValueT >    BucketT;
```

=== Constructors
```cpp
template <typename KeyT,
          typename MappedT,
          typename HasherT = std::hash<KeyT>,
          typename EqualT = std::equal_to<KeyT> >
class unordered_map {
  protected:
    typedef std::pair<KeyT, MappedT>  ValueT;
    typedef std::vector<ValueT>       BucketT;
    ...

    std::vector<BucketT> mBuckets;
    size_t               mSize;
    HasherT              mHasher;  // ใช้ในการเปรียบเทียบ ระหว่างการค้น Key
    EqualT               mEqual;   // hash function เพื่อคำนวณตำแหน่ง bucket
    float                mMaxLoadFactor;
    ...

    unordered_map() :
      mBuckets( std::vector<BucketT>(11) ), mSize(0),
      mHasher( HasherT() ), mEqual( EqualT() ),
      mMaxLoadFactor(1.0)
    { }

    unordered_map(const
      unordered_map<KeyT,MappedT,HasherT,EqualT> &other) :
        mBuckets(other.mBuckets), mSize(other.mSize),
        mHasher(other.mHasher), mEqual(other.mEqual),
        mMaxLoadFactor(other.mMaxLoadFactor)
    { }

    unordered_map<KeyT,MappedT,HasherT,EqualT>&
      operator=(unordered_map<KeyT,MappedT,HasherT,EqualT> other) {
        using std::swap;
        swap(this->mBuckets,       other.mBuckets);
        swap(this->mSize,          other.mSize);
        swap(this->mHasher,        other.mHasher);
        swap(this->mEqual,         other.mEqual);
        swap(this->mMaxLoadFactor, other.mMaxLoadFactor);
        return *this;
    }
}
```

=== Functions
```cpp
template < ... >
class unordered_map {
public:
  bool    empty()                  { return mSize == 0; }
  size_t  size()                   { return mSize; }
  size_t  bucket_count()           { return mBuckets.size(); }
  size_t  bucket_size(size_t n)    { return mBuckets[n].size(); }
  float   load_factor()            { return (float)mSize/mBuckets.size(); }
  float   max_load_factor()        { return mMaxLoadFactor; }
  void    max_load_factor(float z) {...}

  iterator begin()      {...}
  iterator end()        {...}

  MappedT& operator[](const KeyT& key) {...}
  void     clear()                     {...}
  void     rehash(size_t n)            {...}
  size_t   erase(const KeyT &key)      {...}
  pair<iterator,bool> insert(const ValueT& val) {...}
}
```

=== operator`[]`
```cpp
size_t hash_to_bucket(const KeyT& key) {
  return mHasher(key) % mBuckets.size();
}

ValueIterator find_in_bucket(BucketT& b, const KeyT& key) {
  for (ValueIterator it = begin(); it != b.end(); it++) {
    if (mEqual(it->first, key)) return it;
  }
  return b.end();
}

ValueIterator insert_to_bucket(const ValueT& val, size_t& bi) {
  if ( ตารางแน่นเกินไป ) { ปรับตาราง }
  ++mSize;
  return mBuckets[bi].insert(mBuckets[bi].end(), val);
}  // ผลการ insert ใน vector คือ iterator ไปยังข้อมูลที่ถูกเพิ่มใหม่

MappedT& operator[](const KeyT& key) {
  size_t        bi = hash_to_bucket(key);
  ValueIterator it = find_in_bucket(mBuckets[bi], key);

  // ถ้าหาไม่พบ ต้องเพิ่ม pair(key, ค่า default ของ mapped value)
  if (it == mBuckets[bi].end()) {
    it = insert_to_bucket(make_pair(key, MappedT()), bi);
  }

  return it->second;
}
```

=== erase
```cpp
size_t erase(const KeyT & key) {
  size_t        bi = hash_to_bucket(key);
  ValueIterator it = find_in_bucket(mBuckets[bi], key);
  if (it == mBuckets[bi].end()) {
    return 0;  // erase 0 element
  } else {
    mBuckets[bi].erase(it);
    mSize--;
    return 1;  // erase 1 element
  }
}
```

ผลของการ `erase` คือ จำนวนข้อมูลที่ถูกลบ
- `0` คือ ไม่พบ  ไม่มีการลบเกิดขึ้น
- `1` คือ พบ key มีการลบ pair ของ key และ mapped value ของ key นั้น

=== insert
```cpp
pair<iterator, bool> insert(const ValueT& val) {
  pair<iterator, bool> result;
  const KeyT&  key = val.first;
  size_t        bi = hash_to_bucket(key);
  ValueIterator it = find_in_bucket(mBuckets[bi], key);
  result.second = false;
  if (it == mBuckets[bi].end()) {
    it = insert_to_bucket(val, bi);  // bi อาจเปลี่ยน ถ้ามีการปรับตาราง
    result.second = true;
  }
  result.first = iterator(it,  // iterator ของ unordered_map
                          mBuckets.begin() + bi,
                          mBuckets.end());
  return result;
}
```

`val` คือ `pair(key, mappedValue)`

=== clear
```cpp
void clear() {
  for (vector<BucketT>::iterator it = mBuckets.begin();
       it != mBuckets.end();
       ++it) {
    (*it).clear();
  }
  mSize = 0;
}

void clear() {
  for (BucketT & bucket : mBuckets) {  // for each bucket in mBuckets
    bucket.clear();
  }
  mSize = 0;
}
```

=== destructor
```cpp
class unordered_map {
  ...
  ~unordered_map() {
    clear();
  }
  ...
};
```

=== Rehashing
ถ้าฟังก์ชันแฮชกระจายดี การลบและค้นใช้เวลา $cal(O)(lambda)$\
ถ้าควบคุม $lambda$ ไม่ให้เกินค่าคงตัว $k$ การลบและค้นใช้เวลาคงตัว

=== *ถ้า* "*แน่น*" *เกิน ต้อง* rehash
```cpp
void rehash(size_t m) {
  if ( m <= mBuckets.size() &&
      load_factor() <= max_load_factor() ) return;
  m = std::max(m, (size_t)(0.5+mSize/mMaxLoadFactor));
  m = *std::lower_bound(PRIMES, PRIMES+N_PRIMES, m);1

  vector<ValueT> tmp;
  for (auto& val : *this) tmp.push_back(val);
  this->clear();
  mBuckets.resize(m);
  for (auto& val : tmp) this->insert(val);
}

ValueIterator insert_to_bucket(const ValueT& val, size_t& bi) {
  if (load_factor() > max_load_factor()) {
    rehash(2*bucket_count());
    bi = hash_to_bucket(val.first);
  }
  ++mSize;
  return mBuckets[bi].insert(mBuckets[bi].end(), val);
}
```

=== *ชอบให้ขนาดตารางเป็นจำนวนเฉพาะ*
```cpp
const size_t        N_PRIMES      = 256;
const unsigned long   PRIMES[256] = {
  2ul, 3ul, 5ul, 7ul, 11ul, 13ul, 17ul, 19ul, 23ul, 29ul,
  ...
};
```

== Separate Chaining Iterator

=== iterator
```cpp
class unordered_map {
protected:
  ...
  class hashtable_iterator {
    ...
  public:
    hashtable_iterator()                {...}
    hashtable_iterator& operator++()    {...}  // ++it
    hashtable_iterator  operator++(int) {...}  // it++
    ValueT &            operator*()     {...}  // *it
    ValueT *            operator->()    {...}  // it->first
    bool operator!=(const hashtable_iterator &other) {...}
    bool operator==(const hashtable_iterator &other) {...}
  };
public:
  typedef hashtable_iterator iterator;
  ...
};
```

=== ++iterator
```cpp
              vector<ValueT>::iterator
                        ValueIterator
vector<BucketT>::iterator      ▼
BucketIterator ▶  [ ] -▶ [ * , * , * ]
                  [ ] -▶ [ ]
                  [ ] -▶ [ * , * ]
                  [ ] -▶ [ ]
                  [ ] -▶ [ * ]
```

```cpp
class hashtable_iterator{
protected:
  ValueIterator  mCurValueItr;  // ▼
  BucketIterator mCurBucketItr;  // ▶
  BucketIterator mEndBucketsItr;  // เก็บ mBuckets.end() ตอนสร้าง iterator

  void to_next_data() {
    while(mCurBucketItr != mEndBucketsItr &&
          mCurValueItr == mCurBucketItr->end())
    mCurBucketItr++;
    if (mCurBucketItr == mEndBucketsItr) break;
    mCurValueItr = mCurBucketItr->begin();
  }

public:
  hashtable_iterator& operator++() {  // it++
    mCurValueItr++;
    to_next_data();
    return (*this);  // ++(++it) it เลื่อนสองครั้ง
  }
  hashtable_iterator operator++(int) {  // ++it
    hashtable_iterator tmp(*this);
    operator++();
    return tmp;  // (it++)++ it เลื่อนครั้งเดียว!
  }
```

=== `*it` *กับ* `it->`
```cpp
  typedef ValueT & reference;
  typedef ValueT * pointer;

  reference operator*() {
    return *mCurValueItr;  // (*it).first
  }

  pointer operator->() {
    return &(*mCurValueItr);  // it->first
  }
```

=== `it1 == it2` *กับ* `it1 != it2`
```cpp
  bool operator==(const hashtable_iterator &other) {
    return mCurValueItr == other.mCurValueItr;
  }
  bool operator!=(const hashtable_iterator &other) {
    return mCurValueItr != other.mCurValueItr;
  }
```

=== constructor
```cpp
  hashtable_iterator(ValueIterator  valueItr,
                     BucketIterator bucketItr,
                     BucketIterator endBucketItr) :
    mCurValueItr(valueItr);
    mCurBucketItr(bucketItr);
    mEndBucketItr(endBucketItr);
  {
    to_next_data();
  }
};
```

=== begin() && end()
```cpp
iterator begin() {
  return iterator( mBuckets.begin()->begin(),
                    mBuckets.begin(),
                    mBuckets.end() );
}

iterator end() {
  return iterator( mBuckets[mBuckets.size()-1].end(),
                mBuckets.end(),
                mBuckets.end() );
}
```

=== *อย่าลืม* default constructor
```cpp
class unordered_map {
  ...
  class hashtable_iterator {
    ...
    hashtable_iterator() { }
    ...
  };
  ...
  pair<iterator, bool> insert(const ValueT& val) {
    pair<iterator, bool> result;
    ...
    return result;
  }
  ...
};
```

== Open Addressing

=== *การแก้ปัญหาการชนแบบอื่น*
- แบบแยกกันโยง (separate addressing)
  - แต่ละช่องในตารางเก็บรายการโยงของข้อมูล
  - ข้อมูลที่ชนกันเก็บอยู่ด้วยกัน ไม่กระทบข้อมูลอื่น
- แบบเลขที่อยู่เปิด (open addressing)
  - แต่ละช่องในตารางเก็บข้อมูล
  - ถ้าชน ก็หาช่องว่างใหม่ในตารางเพื่อเก็บข้อมูล
  - $lambda = n\/m <= 1$ เสมอ ต้องคุมไม่ให้เกินเกณฑ์ ($lambda<=0.5$)
  - มีหลายวิธีในการหาช่องว่างใหม่ในตาราง เมื่อเกิดการชน
    - การตรวจเชิงเส้น (linear probing)
    - การตรวจกำลังสอง (quadratic probing)
    - การตรวจสองชั้น (double hashing)

=== *การตรวจเชิงเส้น* (Linear Probing)
- เมื่อชน หาช่องว่างถัดไปด้วยวิธีดูตัวถัดไปเรื่อย ๆ
  ```
    ใช้ h(x) = x % 13 แล้วเพิ่มข้อมูลที่มีคีย์ตามลำดับดังนี้
        17  32  26  7  4  43  12  11  24

      0   1   2   3   4   5   6   7   8   9  10  11  12
    [26,   ,   ,   , 17,   , 32,  7,   ,   ,   ,   ,   ]
    [26,   ,   ,   , 17,  4, 32,  7,   ,   ,   ,   ,   ] // 4 ไม่ว่าง ลง 5 แทน
    [26,   ,   ,   , 17,  4, 32,  7, 43,   ,   ,   ,   ] // 4 ไม่ว่าง ลง 8 แทน
    [26,   ,   ,   , 17,  4, 32,  7, 43,   ,   , 11, 12]
    [26, 24,   ,   , 17,  4, 32,  7, 43,   ,   , 11, 12] // 11 ไม่ว่าง วนไปลง 1 แทน
  ```
- ให้ $h_j(x)$ คือช่องที่ probe หลังจากชนครั้งที่ $j$
- $h_0(x) = h(x)$ คือช่องที่ hash เริ่มต้น (home address)
$
  h_j (x) = (h(x) + j) % m #h(5em)
  h_j (x) = (h_(j-1)(x) + 1) % m
$
- ค้น -- หาไม่พบเมื่อเจอช่องว่าง
- ลบ -- ถ้าเจอช่องว่างที่เคยมีข้อมูล ให้ค้นต่อไป

=== *สถานะของช่องเก็บข้อมูล* (bucket)
- แต่ละช่องมี 3 สถานะ
  - `0` : `empty  ` : ช่องว่าง ๆ ไม่เคยมีข้อมูลมาก่อนเลย
  - `1` : `deleted` : ช่องที่เก็บข้อมูลที่ถูกลบไปแล้ว
  - `2` : `data   ` : ช่องที่มีข้อมูลเก็บอยู่

== Linear Probing Iterator

=== *ข้อมูลที่เก็บในตาราง*
```cpp
template <...>
class unordered_map {
  protected:
    typedef pair<KeyT, MappedT> ValueT;
    class BucketT {
      public:
        ValueT        value;
        unsigned char status;

        bool available()    { return status < 2; }
        bool empty()        { return status == 0; }
        bool has_data()     { return status == 2; }
        void mark_deleted() { status = 1; }
        void mark_empty()   { status = 0; }
        void mark_data()    { status = 2; }
    };
    vector<BucketT> mBuckets;
```

=== *การเปลี่ยนสถานะของ* bucket
- `constructor     ->  empty`
- `m.insert(val)   ->  mark_data`
- `m["X"] = 2      ->  mark_data`
- `m.erase("X")    ->  mark_deleted`
- `m.clear()       ->  mark_empty`
- `m.rehash(...)`
  - `clear         ->  mark_empty`
  - `insert        ->  mark_data`

=== *มาดู* iterator *กันก่อน*
```cpp
  class hashtable_iterator {
    protected:
      BucketIterator mCurBucketItr;
      BucketIterator mEndBucketItr;
      void to_next_data() {
        while ( mCurBucketItr != mEndBucketItr &&
                !mCurBucketItr->has_data() ) {
          mCurBucketItr++;
        }
      }
      public:
        hashtable_iterator(BucketIterator bucket,
                           BucketIterator endBucket) :
        mCurBucketItr(bucket), mEndBucketItr(endBucket) {
          to_next_data();
        }
  };

  public:
    iterator begin() {
      return iterator( mBuckets.begin(), mBuckets.end() );
    }
};
```

=== `++it` *กับ* `it++`
```cpp
class hashtable_iterator {
  protected:
    BucketIterator mCurBucketItr;
    BucketIterator mEndBucketItr;
    void to_next_data() {...}

  public:
    ...
    hashtable_iterator& operator++() {  // ++it
      mCurBucketItr++;
      to_next_data();
      return (*this);
    }
    hashtable_iterator  operator++(int) {  // it++
      hashtable_iterator tmp(*this);
      operator++();
      return tmp;
    }
```

=== `*it` *กับ* `it->`
```cpp
    ValueT & operator*() {
      return mCurBucketItr->value;
    }

    ValueT * operator->() {
      return &(mCurBucketItr->value);
    }
};
```

== Linear Probing Hash Table

=== unordered_map (linear probing)
```cpp
template <...>
class unordered_map {
  protected:
    typedef pair<KeyT, MappedT> ValueT;
    class BucketT {...};
    class hashtable_iterator {...};

    vector<BucketT> mBuckets;
    size_t          mSize;
    HasherT         mHasher;         // ใช้ใน hash_to_bucket
    EqualT          mEqual;          // ใช้ใน find_position
    float           mMaxLoadFactor;  // ใช้ใน insert_to_position < 1
    size_t          mUsed;           // # data + # deleted

    size_t hash_to_bucket(const KeyT& key) {
      return mHasher(key) % mBuckets.size();
    }
    size_t find_position(const KeyT& key) {...}
    BucketIterator insert_to_position(const ValueT& val, size_t& pos) {...}
```

=== find_position
```cpp
    vector<BucketT> mBuckets;
    size_t find_position(const KeyT& key) {
      size_t homePos = hash_to_bucket(key);
      size_t pos     = homePos;
      while ( !mBuckets[pos].empty() &&
              !mEqual(mBuckets[pos].value.first, key) ) {
        pos = (pos + 1) % mBuckets.size();
      }
      return pos;  // position of the target or the next empty bucket
    }
```

=== insert
```cpp
    BucketIterator insert_to_position(const ValueT& val, size_t& pos) {
      if (load_factor() > max_load_factor()) {
        rehash(2*bucket_count());
        pos = find_position(val.first);
      }
      mSize++;
      mBuckets[pos].value = val;
      if (mBuckets[pos].empty()) mUsed++;
      mBuckets[pos].mark_data();
      return mBuckets.begin()+pos;
    }
    pair<iterator, bool> insert(const ValueT& val) {
      size_t pos = find_position(val.first);
      if (mBuckets[pos].available()) {
        BucketIterator it = insert_to_position(val, pos);
        result.first = iterator(it, mBuckets.end());
        result.second = true;
      } else {
        result.first = iterator(mBuckets.begin()+pos, mBuckets.end());
        result.second = false;
      }
      return result;
    }
```

=== *คำนวณ* load factor
```cpp
    float load_factor() {
      return (float)mUsed/mBuckets.size();
    }
    float max_load_factor() {
      return mMaxLoadFactor;
    }
    void max_load_factor(float z) {
      mMaxLoadFactor = z;
      rehash(bucket_count());
    }
```

=== operator`[]`
```cpp
    MappedT& operator[](const KeyT& key) {
      size_t pos = find_position(key);
      if (mBuckets[pos].available()) {  // ไม่มีข้อมูล
        insert_to_position(make_pair(key, MappedT()), pos);
      }
      return mBuckets[pos].value.second;
    }
```

=== erase
```cpp
    size_t erase(const KeyT & key) {
      size_t pos = find_position(key);
      if ( mBuckets[pos].has_data() ) {
        mBuckets[pos].mark_deleted();
        mSize--;
        return 1;
      } else {
        return 0;
      }
    }
```

=== clear
```cpp
    void clear() {
      for (auto& bucket : mBuckets) {
        bucket.mark_empty();
      }
      mSize = 0;
      mUsed = 0;
    }
```

=== rehash
```cpp
    void rehash(size_t m) {
      if (load_factor() <= max_load_factor() &&
          m <= mBuckets.size()) return;
      m = max(m, (size_t)(0.5+mSize/mMaxLoadFactor));
      m = *lower_bound(PRIMES, PRIMES+N_PRIMES, m);
      vector<ValueT> tmp;
      for (auto& val : this) {
        tmp.push_back(val);
      }
      this->clear();
      mBuckets.resize(m);
      for (auto& val : tmp) {
        this->insert(val);
      }
    }
```

=== *บริการอื่น ๆ*
```cpp
    bool empty()                 { return mSize == 0; }
    size_t size()                { return mSize; }
    size_t bucket_count()        { return mBuckets.size(); }
    size_t bucket_size(size_t n) {
      return mBuckets[n].has_data() ? 1 : 0;
    }
};
```

=== *การเกาะกลุ่มปฐมภูมิ* (Primary Clustering)
- ถ้าใช้ linear probing แล้วเพิ่มข้อมูลอีกตัวลงตารางข้างล่างนี้ อยากทราบว่า ข้อมูลนี้จะถูกนำไปเก็บไว้ที่ช่องใดด้วยความน่าจะเป็นสูงสุด
- Cookie Monster Effect

== Quadratic Probing

=== *การตรวจกำลังสอง* (Quadratic Probing)
- ขจัดการเกาะกลุ่มปฐมภูมิ
- หลีกเลี่ยงการตรวจช่องติด ๆ กัน
- ให้ตรวจแบบก้าวกระโดดห่าง ๆ

$
  h_j (x) = (h(x) + j^2) % m #h(5em)
  h_j (x) = (h_(j-1) (x) - 2j - 1) % m
$

```
  ใช้ h(x) = x % 13 แล้วเพิ่มข้อมูลที่มีคีย์ตามลำดับดังนี้
      4  5  8  0  7  1  17

    0   1   2   3   4   5   6   7   8   9  10  11  12
  [ 0,  1,   ,   ,  4,  5,   ,  7,  8,   ,   ,   ,   ]
  เพิ่ม 17 ลง 4 แต่ไม่ว่าง
                    ▲ +1
                      - ▲ +3
                          - - - - - ▲+5
                                      - - - - - - - >
  > ▲ +7
      - - - - - - - - - - - - - ▲ +9
                                  - - - - - - - - - >
  > - - - - - - ▼
  [ 0,  1,   , 17,  4,  5,   ,  7,  8,   ,   ,   ,   ]
```

=== Linear vs Quadratic
```cpp
size_t find_position(const KeyT& key) {
  size_t homePos = hash_to_bucket(key);
  size_t pos = homePos, m = mBuckets.size(), col_count = 0;
  while ( !mBuckets[pos].empty() &&
          !mEqual(mBuckets[pos].value.first, key) ) {
            col_count++;
            pos = (pos + 2*col_count-1) % m;
            // pos = (homePos + col_count*col_count) % m;
  }
  return pos;
}
```

=== *คลาสเพื่อการคำนวณตำแหน่งถัดไป*
```cpp
class LinearProbing {
public:
  size_t operator()(size_t homePos,
                    size_t col_count,
                    size_t bucket_count) {
    return (homePos + col_count) % bucket_count;
  }
};

class QuadraticProbing {
public:
  size_t operator()(size_t homePos,
                    size_t col_count,
                    size_t bucket_count) {
    return (homePos + col_count*col_count) % bucket_count;
  }
};
```

=== NextAddressT
```cpp
template <typename KeyT,
          typename MappedT,
          typename HasherT = std::hash<KeyT>,
          typename EqualT = std::equal_to<KeyT>,
          typename NextAddressT = LinearProbing >
class unordered_map {
  ...
  NextAddressT    mNextAddress;
```

=== default & copy constructor
```cpp
  unordered_map() :
    mBuckets(vector<BucketT>(11), mSize(0)),
    mHasher(HasherT()), mEqual(EqualT()),
    mMaxLoadFactor(0.5), mUsed(0),
    mNextAddress( NextAddressT() )
  { }

  unordered_map(const
    unordered_map<KeyT,MappedT,HasherT,EqualT> &other) :
      mBuckets(other.mBuckets), mSize(other.mSize),
      mHasher(other.mHasher), mEqual(other.mEqual),
      mMaxLoadFactor(other.mMaxLoadFactor), mUsed(other.mUsed),
      mNextAddress( other.mNextAddress )
  { }
};
```

=== *การตรวจกำลังสองไม่ตรวจทุกช่อง*
- ลองเพิ่ม `30` อีกตัว ($h(x) = x % 13$)
$
        h(x) & = 4 #h(4em) &  (4+7^2)%13 & = 1 \
  (4+1^2)%13 & = 5         &  (4+8^2)%13 & = 3 \
  (4+2^2)%13 & = 8         &  (4+9^2)%13 & = 7 \
  (4+3^2)%13 & = 0         & (4+10^2)%13 & = 0 \
  (4+4^2)%13 & = 7         & (4+11^2)%13 & = 8 \
  (4+5^2)%13 & = 3         & (4+12^2)%13 & = 5 \
  (4+6^2)%13 & = 1         & (4+13^2)%13 & = 4 \
             &             &         ...
$
- มีช่องว่างอาจหาไม่พบ

=== *เมื่อตารางมีขนาดเป็นจำนวนเฉพาะ*
- การตรวจกำลังสองจะดูอย่างน้อยครึ่งหนึ่งของตาราง
- ดังนั้น ถ้า #text(fill: red)[$"load factor" <= 1\/2$] ก็สบายใจว่า จะหาช่องว่างพบ เมื่อเพิ่มข้อมูล
- พิสูจน์ : ให้ $0<=i<=j<=floor(m\/2)$ ถ้าข้างบนไม่จริง ต้องมีการ probe ครั้งที่ $i$ และ $j$ ที่ดูช่องซ้ำกัน
$
   h(x) + j^2 & equiv h(x) + i^2 & mod m \
          j^2 & equiv i^2        & mod m \
  (j^2 - i^2) & equiv 0          & mod m \
   (j-i)(j+i) & equiv 0          & mod m
$
- เป็นไปไม่ได้: $(j-i)$ ไม่เป็น $0$, $(j+i)$ ก็ไม่เป็น $m$\
  อีกทั้ง $(j-i)(j+i)%m != 0$ เพราะทั้งสองพจน์ $< m$ และ $m$ เป็นจำนวนเฉพาะ

== Double Hashing

=== *การเกาะกลุ่ม*
- การเกาะกลุ่มทุติยภูมิ (secondary clustering)
  - ข้อมูลที่มี $h(x)$ เดียวกัน จะตรวจช่องในตารางเหมือนกัน
  - ระยะกระโดดของการตรวจแปรตามหมายเลขครั้งที่ชน
  - $h_j (x) = (h(x) + j) % m,#h(1em) h_j (x) = (h(x) + j^2) % m$
  - แก้ปัญหานี้ได้ โดยให้ข้อมูลที่มี $h(x)$ เดียวกัน ไม่จำเป็นต้องมีระยะโดดของการตรวจเหมือนกัน
  - ให้ระยะกระโดดคำนวณจากค่าของข้อมูล

=== *การแฮชสองชั้น* (Double Hashing)
- ใช้ฟังก์ชันแฮชอีกตัวเพื่อคำนวณระยะกระโดด
- ทำให้ชุดข้อมูลที่แฮชไปที่ช่องเดียวกัน อาจมีระยะกระโดดต่างกัน
$
  h_j (x) = (h(x) + j dot.c g(x)) % m #h(5em)
  h_j (x) = (h_(j-1) (x) + g(x)) % m
$
- โดยที่ $g(x) % m != 0$ (เพื่อไม่ให้ย่ำอยู่กับที่) เช่น
  - $g(x) = R - (x % R)$, $R$ เป็นจำนวนเฉพาะ และ $R < m$
- และ ตัวหารร่วมมากของ $g(x)$ และ $m$ ต้องเป็น $1$ จะได้ตรวจทุกช่องในตาราง
  - ประกันเงื่อนไขนี้ได้โดยให้ $m$ เป็นจำนวนเฉพาะ
  - $h(x) = 0, g(x) = 4, m = 8$ จะตรวจช่อง $0$ และ $4$ เท่านั้น
  - $h(x) = 0, g(x) = 4, m = 7$ จะตรวจช่อง $0, 4, 1, 5, 2, 2, 6, 3$

=== *เปรียบเทียบจำนวนการตรวจเฉลี่ย*
#table(
  align: right,
  columns: 9,
  [],
  table.cell(colspan: 2)[Linear Probing], [],
  table.cell(colspan: 2)[Quadratic Probing], [],
  table.cell(colspan: 2)[Double Hashing],

  [], [พบ], [ไม่พบ], [], [พบ], [ไม่พบ], [], [พบ], [ไม่พบ],

  [$lambda = 0.3$], [$1.21$], [$1.52$], [], [$1.21$], [$1.47$], [], [$1.19$], [$1.43$],
  [$lambda = 0.4$], [$1.33$], [$1.89$], [], [$1.31$], [$1.75$], [], [$1.28$], [$1.67$],
  [$lambda = 0.5$], [$1.50$], [$2.50$], [], [$1.43$], [$2.14$], [], [$1.39$], [$2.02$],
  [$lambda = 0.6$], [$1.75$], [$3.63$], [], [$1.59$], [$2.72$], [], [$1.53$], [$2.54$],
  [$lambda = 0.7$], [$2.16$], [$6.02$], [], [$1.82$], [$3.70$], [], [$1.74$], [$3.44$],
  [$lambda = 0.8$], [$3.00$], [$12.84$], [], [$2.16$], [$5.64$], [], [$2.05$], [$5.32$],
  [$lambda = 0.9$], [$5.44$], [$49.70$], [], [$2.79$], [$11.37$], [], [$2.67$], [$11.63$],
)

#table(
  align: left + horizon,
  columns: 3,
  [], table.cell(colspan: 2)[จำนวนการตรวจเฉลี่ย],
  [], [หาพบ], [หาไม่พบ],
  [แบบแยกกันโยง ($lambda >= 0$)], [$ 1 + lambda / 2 $], [$ 1 + lambda $],
  [การตรวจเชิงเส้น ($0 <= lambda <= 1$)], [$ 1/2 (1 + 1/(1 - lambda)) $], [$ 1/2 (1 + 1/(1 - lambda)^2) $],
  [การแฮชสองชั้น ($0 <= lambda <= 1$)], [$ 1/lambda ln 1/(1-lambda) $ ], [$ 1/(1-lambda) $],
)

*ถาม*: เก็บข้อมูลโดยใช้การตรวจเชิงเส้น ถ้าต้องการตรวจโดยเฉลี่ยไม่เกิน $5$ ครั้ง ต้องควบคุมให้ตารางแฮชมี $lambda$ เป็นเท่าใด\
*ตอบ*:
$
           5 & >= 1/2(1 + 1/(1-lambda)^2) \
           9 & >= 1/(1-lambda)^2 \
  1 - lambda & >= sqrt(1/9) \
      lambda & <= 2/3
$

=== *ข้อควรระวัง*
- ไม่เหมาะกับบริการที่
  - แจกแจงข้อมูลด้วย iterator
  - เกี่ยวข้องกับอันดับของข้อมูล `getMin`, `getMax`, ...
  - ต้องค้นทั้งตาราง $Theta(m+n)$
- ต้องระวังเรื่องฟังก์ชันแฮช
  - ฟังก์ชันแฮชไม่ดี ก็ใช้งานได้ แต่ถ้า $n$ มาก อาจช้าเป็น $cal(O)(n)$

```cpp
class BookHasher {
public:
  size_t operator()(const Book& b) const {
    return hash<string>()(b.title) ^
           hash<int>()(b.edition);
  }
};
```

=== *สรุป*
- การค้น เพิ่ม ลบข้อมูลในตารางแฮชทำได้รวดเร็ว
- สามารถปรับเวลาการทำงานให้เร็วขึ้นด้วยการใช้เนื้อที่เข้าแลก เพื่อให้ได้ $lambda$ ที่เหมาะสม
- ฟังก์ชันแฮชมีผลต่อประสิทธิภาพการทำงาน
