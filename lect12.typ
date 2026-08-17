= Lecture 12

== Complexity Analysis
How fast is our code?

=== Overview
- Introducing a #text(fill: purple)[measurement] of efficiency of a program
- Why we need measurement
- How we measure
  - How to analyze our code to get a measurement
- What is measurement
  - #text(fill: purple)[Asymtotic Notation]

=== Key Idea
- We need a useful way to describe effiency of our code
  - Useful = able to be #text(fill: blue)[easily use to predict] how much resource (time / memory) that our program will need
  - Useful = #text(fill: blue)[not overly complex] in analysis
  - Need to balance between usefulness and complexity
- Ultimately, we introduce a #text(fill: orange)[class of efficiency] that says how our code use resource with respect to size of data
  - Focus on #text(fill: green)[on growth of resource usage]

=== Preview
#grid(
  columns: (1fr, 1fr),
  row-gutter: 1em,
  [
    ```cpp
    int find_max(vector<int> v) {
      int m = v[0];
      for (size_t i = 0; i < v.size(); i++)
        if (v[i] > m)
          m = v[i];
      return m;
    }
    ```],
  [
    - This code takes time #text(fill: green)[directly proportional] to #text(fill: blue)[the size of the data]
      - Size $N$ takes time $T$
      - Size $5N$ should take time $5T$
  ],

  [
    ```cpp
    int count_pair_sum(vector<int> v, int k) {
      int count = 0;
      for (size_t i = 0; i < v.size(); i++)
        for (size_t j = 0; j < v.size(); j++)
          if (i != j && v[i] + v[j] == k)
            count++;
      return count/2;
    }
    ```
  ],
  [
    - This code takes time #text(fill: green)[directly proportional] to #text(fill: blue)[the square of the size of the data]
      - Size $N$ takes time $T$
      - Size $5N$ should take time $25T$
  ],
)

=== Why don't we use real world clock?
- Ultimately, we want to know #text(fill: purple)[how long our program takes] to do each operation
  - Use in design, how much resource we need
  - Help use #text(fill: orange)[choose appropriate data structure]
- #text(fill: green)[Real world clock] measurement #text(fill: green)[is possible] but has #text(fill: red)[many drawback]
  - System dependency
  - Too complex (we have to build our system)
  - Too specific

=== Dependency of System
- Same program in different system = different time
  - CPU
  - RAM
  - Compiler
  - Operating parameter
    - Heat? Other running program?

=== How to measure
- Counting instruction
  - Depend on code only
- Dependency on size of data
  - Focus on large data

```cpp
int count_pair_sum(vector<int> v, int k) {
  int count = 0;                            // 1
  for (size_t i = 0; i < v.size(); i++)     // 2 + n + n  ( n = v.size() )
    for (size_t j = 0; j < v.size(); j++)   // (2 + n + n) * n
      if (i != j && v[i] + v[j] == k)       // 2 * n * n
        count++;                            // 1 * ????  ( <= (d) )
  return count/2;                           // 1
}

// Total = 1 + 2+n+n + (2+n+n)n + 2n^2 + n^2 + 1
//       = 4 + 4n + 5n^2
```

=== Time per instruction
- In reality, different CPU instructions use different time
- Same instruction but different CPU also use different number of cycle
- #text(fill: purple)[However, we just ignore it]
  - For now

=== Focusing on large data
- In many cases, the size of the data we are working with will affect the time our code use
- Large data usually mean longer time
- What matter is when the data is large

=== Growth rate simplifies analysis
```cpp
int count_pair_sum(vector<int> v, int k) {
  int count = 0;                             //     i=0: 1 + n-0 + n-1
  for (size_t i = 0; i < v.size(); i++)      //     i=1: 1 + n-1 + n-2
    for (size_t j = i+1; j < v.size(); j++)  // <-- i=2: 1 + n-2 + n-3
      if (v[i] + v[j] == k)                  //     . . .
        count++;                             //     i=n-1: 1 + 1 + 0
  return count;                              //     sum = Σ(1+2n-2i-1) = n^2 + n
}

// Total = 1 + 2+n+n + n^2+n + n^2 + n^2 + 1
//       = 4 + 3n + 3n^2
```

=== Small Detail

#import "@preview/zero:0.3.3": num

// Custom num function:
// - If |value| >= 1e8: show as X.XXe+N (2 decimal mantissa, base-10 exponent)
// - If decimal (non-integer): round to 5 significant digits
// - Otherwise: show as integer
#let mynum(s) = {
  let v = float(s)
  let av = calc.abs(v)
  if av >= 1e8 {
    // Exponential form with 2-digit mantissa
    let exp = calc.floor(calc.log(av))
    let mantissa = v / calc.pow(10.0, exp)
    // Round mantissa to 2 decimal places
    let m = calc.round(mantissa, digits: 2)
    // Format: m × 10^exp
    num(str(m) + "e" + str(exp))
  } else if v == calc.round(v) {
    // Integer value
    num(str(int(v)))
  } else {
    // Decimal: round to 5 significant digits
    num(str(calc.round(v, digits: 5)))
  }
}

#table(
  columns: 7,
  align: (right,) * 7,

  table.cell(rowspan: 2)[$n$],
  table.cell(colspan: 2, align: center)[$5n^2+4n+4$],
  table.cell(colspan: 2, align: center)[$3n^2+3n+4$],
  table.cell(colspan: 2, align: center)[$n^2$],
  [raw], [growth], [raw], [growth], [raw], [growth],

  // Row 1
  [$10$], [$544$], [], [$334$], [], [$100$], [],
  // Data rows
  ..{
    let rows = ()
    for n in range(1, 12) {
      let i = 10 * calc.pow(2, n)
      let f1 = 5 * i * i + 4 * i + 4
      let f1p = 5 * (i / 2) * (i / 2) + 4 * (i / 2) + 4
      let f2 = 3 * i * i + 3 * i + 4
      let f2p = 3 * (i / 2) * (i / 2) + 3 * (i / 2) + 4
      let i2 = i * i
      rows.push(mynum(str(i)))
      rows.push(mynum(str(f1)))
      rows.push(mynum(str(f1 / f1p)))
      rows.push(mynum(str(f2)))
      rows.push(mynum(str(f2 / f2p)))
      rows.push(mynum(str(i2)))
      rows.push([4])
    }
    rows
  },
)


When counting instruction, it is usually OK to focus on #text(fill: orange)[most executed line]

=== Measurement by Growth Rate
#v(0.5em)
#block(breakable: false)[
  #grid(
    columns: (1fr, 1fr),
    row-gutter: 1em,
    [*What?*], [*Why?*],
    [
      - Growth rate = how much resource usage growth with respect to change of input
        - Resource usage = number of instruction used
        - Input = size of data
      - Emphasizes long term trend
    ],
    [
      - System independent
        - The result can be used to predict behavior on any system
      - Focus on change of resource usage with respect to size of input
      - Can regard small detail
        - Simple to calculate
        - Applicable in real world
    ],
  )
]

== Asymtotic Notation
Classification of growth rate

=== Overview
- Formally, it is a #text(fill: blue)[set of function] having the #text(fill: red)[growth rate] related to something
- The definition focus #text(fill: red)[on growth of the function] while #text(fill: green)[disregard small detail]
- Also provide some workaround on dependency of value of input

=== What is?
- A kind notation written as $O(f(n))$
  - $O$ can be one of $cal(O), Theta, Omega, cal(o), omega$
  - $f(n)$ is some expression
- Example $cal(O)(n)$ or $Theta(n^2+3)$ or $omega(n^2 log(n))$
- Usage
  - "This code is $cal(O)(n)$" #text(fill: blue)[(read as Big-Oh of n)]
  - "This function takes time in $Theta(log(n))$" #text(fill: blue)[(read as Big-theta of log n)]
  - "Time complexity of this program is $cal(O)(n^2)$"

=== Meaning
- "A is $Theta(f(x))$" means the #text(fill: red)[growth rate of A] is #text(fill: purple)[equal] to the #text(fill: red)[growth rate of $f(x)$]
- "B is $cal(O)(f(x))$" means the #text(fill: red)[growth rate of B] is #text(fill: purple)[less than or equal] to the #text(fill: red)[growth rate of $f(x)$]
- For $Omega, cal(o), omega$, (#text(fill: blue)[Big-Omega], #text(fill: orange)[little-oh], #text(fill: green)[little-omega]), we won't use it for now but the meaning is similar (which are #text(fill: blue)[more than or equal], #text(fill: orange)[less than], #text(fill: green)[more than], respectively)
- Conventionally, we usually use #text(fill: blue)[$N$ for the size of the data]

=== Usage
- Let #text(fill: orange)[$f(n)$] be the number of instruction needed by #text(fill: orange)[code A] when the #text(fill: orange)[size of data is $n$]
- We will calculate asymtotic notation that $f(n)$ is a member of
  - Find $g(n)$ such that $f(n)$ is #text(fill: green)[$cal(O)(g(n))$] or #text(fill: purple)[$Theta(g(n))$] (or #text(fill: red)[$Omega(g(n))$] or ...)
- Let's say we have analyze that #text(fill: green)[$f(n)$ is $cal(O)(g(n))$]
  - We now understand that the growth rate of instruction required by $n$ grows slower or the same as how $g(n)$ grow

=== Comparing growth rate of f(n) and g(n)
- The relation of growth rate of $f(n)$ and $g(n)$ depends on the value of $f(n) \/ g(n)$ when $n -> oo$

$
  lim_(n -> oo) f(n) / g(n) = cases(
    0 & "if" f(n) "grows" #text(fill: green)[slower] "than" g(n),
    c & "if" f(n) "grows" #text(fill: orange)[similarly] "to" g(n),
    oo & "if" f(n) "grows" #text(fill: red)[faster] "than" g(n),
  )
$

=== Example
- $f(n) = 4 + 3n + 4n^2$
- $g(n) = n^2$
$
  lim_(n -> oo) (4n^2 + 3n + 4)/n^2 = lim_(n -> oo) (4 + 3/n + 4/n^2) = 4
$
- Hence #text(fill: green)[$f(n)$ grows similarly to $g(n)$]
  - Therefore, $f(n) = Theta(n^2)$

*Another Example*
- $f(n) = 0.00005 n^2$
- $g(n) = 100000 n$
$
  lim_(n -> oo) (0.00005 n^2)/(100000 n) = lim_(n -> oo) 10^(-10) n = oo
$
- Hence #text(fill: red)[$f(n)$ grows faster than $g(n)$] (also means #text(fill: blue)[$g(n)$ grows slower than $f(n)$])
  - Therefore $g(n) = cal(O)(n^2)$
  - and $f(n) = Omega(10000 n)$

=== Dependency on the value of input
- Consider `vector::insert(iterator it, T value)`
- The time it takes depends on both #text(fill: red)[the size of the vector] and the #text(fill: red)[value of it]
  - Larger size $-->$ more time
  - Closer to `end()` $-->$ less time

=== Big-O describes upper bound
- `vector::insert` is $cal(O)(n)$
  - Its growth rate #text(fill: blue)[does not exceed $n$]
  - There are cases that it may grow less than $n$ (insert at `end()`)
- This is very useful in real world
  - Knowing #text(fill: green)[maximum load]
  - Not overly complex in analysis

=== Big-O Example
- Find is $cal(O)(n)$
  - At worse, it can't find #text(fill: red)[value] and `a` & `b` points to `begin()` & `end()`
    - This case, #text(fill: purple)[find] growth rate is $n$
  - At best, it always find #text(fill: red)[value] at the first position (`a`)
    - This case, find growth as $1$

```cpp
bool find(iterator a, iterator b, T value) {
  while (a < b) {
    if (*a == value)
      return true;
    a++;
  }
  return false;
}
```

=== L'Hôpital's Rule
$
  lim_(n -> oo) f(x) / g(x) = lim_(n -> oo) (f'(x))/(g'(x))
$
If $f(x), g(x)$ must be diffable, $g(x)$ is non-zero, $lim_(n -> oo) f' \/ g'$ exists

- Can help
- $F(n) = log n$
- $g(n) = n^0.5$
$
  lim_(n -> oo) log(n) / sqrt(n) & = lim_(n -> oo) ln(n) / (ln(10) sqrt(n)) \
                                 & = 1 / ln(10) lim_(n -> oo) ln(n) / sqrt(n) \
                                 & = 1 / ln(10) lim_(n -> oo) (1/n) / (1/(2sqrt(n))) \
                                 & = 1 / ln(10) lim_(n -> oo) 2 / sqrt(n) \
                                 & = 0
$

=== Exercise
- $f(n) = lg^c n$
- $g(n) = n^k$
- We know that $c > 0, k > 0$
- Does $f(n)$ grow slower than $g(n)$?

#box(fill: yellow, inset: 5pt)[Will do this part later]

== Big Theta

=== Big-Theta is tight bound
- `std::count` always go through entire array
- Regardless of the value in the array, it always perform ```cpp if (*first == value)```

```cpp
size_t count(iterator first, iterator last, const T& value) {
  size_t ret = 0;                   // 1
  for (; first != last; ++first) {  // n + n
    if (*first == value)            // 1 * n
      ret++;                        // 1 * ???? ( <= (d) )
  }
  return ret;                       // 1
}

// Total = 1 + n+n + 1*n + 1*n + 1
//       = 2 + 4n
```

=== More Example
#table(
  columns: (4.5cm, 4.5cm, 4.5cm),
  [*$Theta(1)$*], [*$Theta(n)$*], [*$Theta(n^2)$*],
  [
    $f(n) = 5$\
    $f(n) = 0$\
    $f(n) = c$
  ],
  [
    $f(n) = n$\
    $f(n) = n + 3$\
    $f(n) = n/1200 + 86$\
    $f(n) = 40000000n$
  ],
  [
    $f(n) = n^2$\
    $f(n) = binom(n, 2) = (n(n-1))/2$\
    $f(n) = 400n^2 + a n + b$
  ],
)

Observation: multiplicative and addition constants in $f(n)$ can usually be ignored, since it will be disragard by $lim$, Degree cannot.

=== Well known growth rate class
#table(
  columns: 2,
  column-gutter: 20pt,
  stroke: none,
  [$Theta(1)$], [Constant],
  [$Theta(log(n))$], [Logarithm],
  [$Theta(log^c (n)), c >= 1$], [Polylogarithm],
  [$Theta(n^a), 0 < a < 1$], [Sublinear],
  [$Theta(n)$], [Linear],
  [$Theta(n log(n))$], [Linearithmic],
  [$Theta(n^2)$], [Quadratic],
  [$Theta(n^c), c >= 1$], [Polynomial],
  [$Theta(c^n), c > 1$], [Exponential],
  [$Theta(n!)$], [Factorial],
)

#import "@preview/cetz:0.4.0"
#import "@preview/cetz-plot:0.1.2": chart, plot

#cetz.canvas({
  plot.plot(
    size: (10, 5.5),
    x-min: 0,
    x-max: 84,
    y-min: 0,
    y-max: 62,
    x-tick-step: 20,
    y-tick-step: 20,
    x-grid: false,
    y-grid: false,
    axis-style: "left",
    x-label: none,
    y-label: none,
    {
      let x-max = 84
      let x-min = 0.01
      plot.add(domain: (x-min, x-max), x => x * calc.ln(x), style: (stroke: red), label: $ n ln(n) #v(1.3em) $)
      plot.add(domain: (x-min, x-max), x => x, style: (stroke: green), label: $ n #v(1.3em) $)
      plot.add(domain: (1, x-max), x => calc.pow(calc.ln(x), 2), style: (stroke: purple), label: $ ln^2(n) #v(1.3em) $)
      plot.add(domain: (x-min, x-max), x => calc.pow(x, 0.5), style: (stroke: black), label: $ n^(0.5) #v(1.3em) $)
      plot.add(domain: (x-min, x-max), x => calc.ln(x), style: (stroke: blue), label: $ ln(n) #v(1.3em) $)
    },
  )
})

$ln^2(n)$ grows slower than $n^0.5$. At around $n = 56000$, $ln^2(n)$ is less than $n^0.5$.\
$x^4$ grows slower than $2^n$. At around $n = 16$, $x^4$ is less than $2^n$.

=== Beware
- It is #text(fill: red)[wrong] to say that `vector::insert` is $Theta(n)$
  - Because there is a case that it grows slower than $n$
- It is #text(fill: red)[wrong] to say that `vector::push_back` is $Theta(n)$
  - Because there is a case that it grows slower than $n$
- It is #text(fill: purple)[ok] to say that `std::count` is $cal(O)(n)$
  - Because while it always grows as $n$, #text(fill: orange)[it does not grow faster than $n$]
  - $cal(O)(n)$ is upper bound
  - But it is better to say that `std::count` is $Theta(n)$

=== How to analyze using asymptotic notation
+ Write a code
+ Calculate the function $f(n)$ that counts the number of instruction of the code when the data is size $n$
  - Usually, just focus on #text(fill: green)[most executed line]
+ Find $g(n)$ and a notation $X$ such that $f(n)$ is $X(g(n))$
  - It's either #text(fill: green)[Big-O] or #text(fill: green)[Big-Theta]. If there is a case that it can grow slower than $G(n)$, use Big-O

=== Another Example
- Let's analyze `vector::push_back`

```cpp
iterator insert(iterator it, const T& element) {
  size_t pos = it - begin();
  ensureCapacity(mSize + 1);
  for (size_t i = mSize; i > pos; i--) {
    mData[i] = mData[i-1];  // <-----  Most executed line: 1 (b)
  }
  mData[pos] = element;
  mSize++;
  return begin()+pos;
}
void push_back(const T& element) {
  insert(end(), element);
}

void expand(size_t capacity) {
  T *arr = new T[capacity]();
  for (size_t i = 0; i < mSize; i++) {
    arr[i] = mData[i];  // <-----  Most executed line: 0, 0, 0, 0, 2, 4, 8, 16 (a)
  }
  delete [] mData;
  mData = arr;
  mCap = capacity;
}

void ensureCapacity(size_t capacity) {
  if (capacity > mCap) {
    size_t s = (capacity > 2 * mCap) ? capacity : 2 * mCap;
    expand(s);
  }
}

// (a) can be 0 to n
// (b) can also be 0 to n
// Best case 0 + 0
// Worst case n + n
// vector::push_back is O(n)
```

=== Another Definition for $cal(O)$ and $Theta$
- Using set builder notation
- $cal(O)(g(n)) = { f(n) | "there exists" c > 0 "and" n_0 >= 0 "such that" f(n) <= c g(n) "for" n >= n_0 }$
- $Theta(g(n)) = { f(n) | "there exists" c_1, c_2 > 0 "and" n_0 >= 0 "such that" c_1 g(n) <= f(n) <= c_2 g(n) "for" n >= n_0 }$
- The result is the same as definition using $lim$

=== Summary
- We use Asymtotic Notation to describe efficiency of a program
  - Measure instruction count instead of time
  - Focus on growth rate of instruction count
- Find most frequently executed line in the code and count it
- Maps to Big-Theta if we have tight bound
- Use Big-O if we have upper bound

== Example

=== Showing $log_2(n!)$ is $Theta(n log_2(n))$

- Will use set definition of Big-Theta\ ${ f(n) | "there exists" c_1, c_2 > 0 "and" n_0 >= 0 "such that" c_1 g(n) <= f(n) <= c_2 g(n) "for" n >= n_0 }$
- Need to find $c_1, c_2$ and $n_0$

=== Finding $c_1$ and $c_2$

#import "@preview/mannot:0.3.3": *
#v(0.6em)
$n! & = n times (n - 1) times (n - 2) times (n - 3) times dots.c times 1 \
n! & <= n times n times n times n times dots.c times n \
log n! & <= log n^n #h(3em) markrect(log n^n = n log n " when " n >= 1, outset: #.2em)$

Found $c_2 = 1$ for upper bound #h(1em) $markrect(log n! <= n log n " when " n >= 1, outset: #.2em)$

#v(1.2em)
$n! &= n times (n - 1) times dots.c times floor(n / 2) times (floor(n / 2) - 1) times dots.c times 1\
n! &>= floor(n / 2) times floor(n / 2) times dots.c times floor(n / 2) times 1 times dots.c times 1\
n! &>= (n/2)^(n\/2) #h(3em) markrect(log(n/2)^(n\/2) = n/2 log n - n/2, outset: #.2em)\
log n! &>= log(n/2)^(n\/2) #h(3em) markrect(0.5 n log n - 0.5 n >= 0.4 n log n " when " n >= 32, outset: #.2em)$

Found $c_1 = 0.4$ for lower bound #h(1em) $markrect(log n! >= 0.4 n log n " when " n >= 32, outset: #.2em)$

#v(1.2em)
$markrect(0.4 n log n <= log n! <= n log n " when " n >= 32\, c_1 = 0.4\, c_2 = 1\, n_0 = 32, outset: #.2em)$\ #v(0em)
$==> #h(.5em) markrect(log n! " is " Theta(n log n) " and " n log n " is " Theta(log n!), outset: #.2em)$
