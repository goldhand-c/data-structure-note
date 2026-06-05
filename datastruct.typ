#set text(font: ("Linux Libertine", "KaiTi"), size: 10pt, number-type: "old-style")

#set raw(theme: "z.tmTheme")
#show raw: set text(font: "LMMono10", size: 10pt, number-type: "lining")

#show math.equation: set text(font: "Concrete Math", number-type: "lining")

// Automatically scale Thai characters to be larger (like MatchLowerCase)
#show regex("[\u0e00-\u0e7f]+"): set text(size: 1.18em, font: "TH Sarabun New")

#set page(numbering: "1")

// Title
#align(center)[
  #v(2.9em)
  #v(-2cm)
  #label("head")
  #v(2cm)
  #text(size: 21pt, weight: "regular")[2110211 Introduction to Data Structure] \
  #v(2.0em)
  #text(size: 14pt)[Sorrawee Worawichayawiwat] \
  #v(0.4em)
  #text(size: 14pt)[May -- June, 2026]
]
#v(2.9em)

// #set outline.entry(fill: line(length: 100%, stroke: 0.3pt))

// #show outline.entry.where(level: 1): set outline.entry(
//   fill: align(
//     right,
//     line(length: 98%, stroke: 0.7pt + blue),
//   ),
// )
// #show outline.entry.where(level: 1): set text(
//   weight: "bold",
//   size: 1.1em,
// )

// #show outline.entry.where(level: 2): set text(
//   weight: "bold",
//   size: 1.1em,
// )

// #show outline.entry.where(level: 3): it => link(
//   it.element.location(),
//   it.indented(it.prefix(), it.body()),
// )

// #outline(title: [Contents], depth: 3)<toc>

// -------------- Custom outline --------------

#set heading(numbering: "1.1.1")
#show heading: it => block(sticky: true)[
  // Invisible number keeps counter in sync, body renders normally
  #box(width: 0pt, hide(
    counter(heading).display(heading.numbering),
  ))#it.body \ #v(0.2em, weak: true)
]

#context {
  let subsection_mapper(subsection) = {
    let loc = subsection.location()
    // let num = numbering(
    //   heading.numbering,
    //   ..counter(heading).at(loc),
    // )
    let pg = numbering(
      loc.page-numbering(),
      ..counter(page).at(loc),
    )
    return link(
      loc,
      [
        // #num
        #subsection.body (#pg).
      ]
        + h(0.5em),
    )
  }

  let chapters = query(heading.where(level: 1))
  let sections = query(heading.where(level: 2))
  let subsections = query(heading.where(level: 3))

  for (i, chapter) in chapters.enumerate(start: 1) {
    let chapter_location = chapter.location()
    // let chapter_num = numbering(
    //   heading.numbering,
    //   ..counter(heading).at(chapter_location),
    // )
    let chapter_page = numbering(
      chapter_location.page-numbering(),
      ..counter(page).at(chapter_location),
    )
    let chapter_sections = sections.filter(
      section => counter(heading).at(section.location()).at(0) == i,
    )

    block(
      above: 2mm,
      below: 2mm,
      link(
        chapter_location,
        text(
          size: 1.1em,
          weight: "bold",
          h(0.4em) + chapter.body + h(0.6em) + box(width: 1fr, line(length: 99%, stroke: 0.75pt + blue)),
        ),
      ),
    )

    for (j, section) in chapter_sections.enumerate(start: 1) {
      let section_location = section.location()
      // let section_num = numbering(
      //   heading.numbering,
      //   ..counter(heading).at(section_location),
      // )
      let section_page = numbering(
        section_location.page-numbering(),
        ..counter(page).at(section_location),
      )
      let section_subsections = subsections.filter(
        sub => {
          let c = counter(heading).at(sub.location())
          c.at(0) == i and c.at(1) == j
        },
      )
      let subsections_body = section_subsections.map(subsection_mapper).join()

      block(
        above: 2.4mm,
        below: 1mm,
        link(
          section_location,
          text(
            size: 1.06em,
            weight: "semibold",
            h(2em)
              // + [#section_num]
              + h(0.4em)
              + section.body
              + h(0.3em)
              + box(width: 1fr, repeat(gap: 0.44em, [#text(size: 0.8em)[.]]))
              + h(0.2em)
              + section_page,
          ),
        )
          + if subsections_body != none {
            align(
              right,
              block(
                width: 90%,
                above: 2.4mm,
                inset: (right: 5mm),
                align(left, par(justify: true, text(
                  font: "Nebula Sans",
                  weight: "medium",
                  size: 0.8em,
                )[#subsections_body])),
              ),
            )
          },
      )
    }
  }
}

// --------------------------------------------

#pagebreak()

// Link to current section
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
  let all-headings = query(heading.where(level: 1))
  let current-pos = here().position()

  let before = all-headings.filter(h => {
    let hpos = h.location().position()
    (
      hpos.page < current-pos.page
        or (
          hpos.page == current-pos.page and hpos.y < current-pos.y
        )
    )
  })

  if before.len() > 0 {
    link(before.last().location(), body)
  } else {
    body
  }
}

// Header
#set page(header: {
  grid(
    columns: (1fr, 1fr),
    align: (left, right),
    [
      #link(<head>, [Introduction to Data Structure])
    ],
    [#context {
      // let final-page = counter(page).final().first()
      // link((page: final-page, x: 0pt, y: 0pt))[#current-section-title()]
      link-to-current[#current-section-title()]
    }],
    [#v(0.18cm)],
    grid.hline(stroke: 0.4pt),
  )
})

// Table
#set table(stroke: 0.6pt + luma(150))

// Include sections
#let lect = 14
#for i in range(1, lect + 1) {
  if (i < 10) {
    include "lect0" + str(i) + ".typ"
  } else {
    include "lect" + str(i) + ".typ"
  }
  [\ ]
  v(2.2em, weak: true)
}
