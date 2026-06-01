#set text(font: ("Libertinus Serif", "KaiTi"), size: 10pt, ligatures: true)
#show raw: set text(font: "LMMono10", size: 10pt)
// Automatically scale Thai characters to be larger (like MatchLowerCase)
#show regex("[\u0e00-\u0e7f]+"): set text(size: 1.15em, font: "TH Sarabun New")

#set page(numbering: "1")

// Title
#align(center)[
  #v(2.9em)
  #text(size: 21pt, weight: "regular")[2110211 Introduction to Data Structure] \
  #v(2.0em)
  #text(size: 14pt)[Sorrawee Worawichayawiwat] \
  #v(0.4em)
  #text(size: 14pt)[May -- June, 2026]
]
#v(2.9em)

// #set outline.entry(fill: line(length: 100%, stroke: 0.3pt))

#show outline.entry.where(level: 1): set outline.entry(
  fill: align(
    right,
    line(length: 98%, stroke: 0.7pt + blue),
  ),
)
#show outline.entry.where(level: 1): set text(
  weight: "bold",
  size: 1.1em,
)

#show outline.entry.where(level: 2): set text(
  weight: "bold",
  size: 1.1em,
)



#show outline.entry.where(level: 3): it => link(
  it.element.location(),
  it.indented(it.prefix(), it.body()),
)

#outline(title: [Contents], depth: 3)<toc>

#pagebreak()

#let current-section-title() = context {
  let headings = query(heading.where(level: 1).before(here()))
  if headings == () { return }
  if (headings.last().body == [Contents]) {
    [Lecture 1]
    return
  }
  headings.last().body
}

#let link-to-current(body) = context {
  // Filter headings to only look for level 1 before this exact spot
  let current-heading = query(
    heading.where(level: 1).before(here()),
  ).last()

  link(current-heading.location(), body)
}

#set page(header: {
  grid(
    columns: (1fr, 1fr),
    align: (left, right),
    [
      #link(<toc>, [Introduction to Data Structure])
    ],
    [#context {
      let final-page = counter(page).final().first()
      // link((page: final-page, x: 0pt, y: 0pt))[#current-section-title()]
      link-to-current[#current-section-title()]
    }],
    [#v(0.18cm)],
    grid.hline(stroke: 0.4pt),
  )
})

// Include sections
#for i in range(1, 12) {
  include "lec" + str(i) + ".typ"
}
