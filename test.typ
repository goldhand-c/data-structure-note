// #set text(size: 12pt)
#set page(numbering: "1")
#set heading(numbering: "1.A.a")

#context {
  let subsection_mapper(subsection) = {
    let loc = subsection.location()
    let num = numbering(
      heading.numbering,
      ..counter(heading).at(loc),
    )
    let pg = numbering(
      loc.page-numbering(),
      ..counter(page).at(loc),
    )
    return link(
      loc,
      [#num #subsection.body (#pg).] + h(0.5em),
    )
  }

  let chapters = query(heading.where(level: 1))
  let sections = query(heading.where(level: 2))
  let subsections = query(heading.where(level: 3))

  for (i, chapter) in chapters.enumerate(start: 1) {
    let chapter_location = chapter.location()
    let chapter_num = numbering(
      heading.numbering,
      ..counter(heading).at(chapter_location),
    )
    let chapter_page = numbering(
      chapter_location.page-numbering(),
      ..counter(page).at(chapter_location),
    )
    let chapter_sections = sections.filter(
      section => counter(heading).at(section.location()).at(0) == i,
    )

    block(
      above: 6mm,
      below: 2mm,
      link(
        chapter_location,
        text(
          size: 1.5em,
          weight: "bold",
          [#chapter_num]
            + h(0.4em)
            + chapter.body
            + h(0.2em)
            + box(width: 1fr, repeat(gap: 0.15em, [.]))
            + h(0.2em)
            + chapter_page,
        ),
      ),
    )

    for (j, section) in chapter_sections.enumerate(start: 1) {
      let section_location = section.location()
      let section_num = numbering(
        heading.numbering,
        ..counter(heading).at(section_location),
      )
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
        above: 3mm,
        below: 1mm,
        link(
          section_location,
          text(
            size: 1.15em,
            weight: "semibold",
            h(2em)
              + [#section_num]
              + h(0.4em)
              + section.body
              + h(0.2em)
              + box(width: 1fr, repeat(gap: 0.15em, [.]))
              + h(0.2em)
              + section_page,
          ),
        )
          + if subsections_body != none {
            align(
              right,
              block(
                width: 90%,
                above: 2mm,
                align(left, par(justify: true, subsections_body)),
              ),
            )
          },
      )
    }
  }
}

#pagebreak()

= The first chapter
== First chapter, first section
=== First chapter, first section, first subsection
#pagebreak()
=== First chapter, first section, second subsection
#pagebreak()
== First chapter, second section
=== First chapter, second section, first subsection
#pagebreak()
=== First chapter, second section, second subsection
#pagebreak()
= The second chapter
== Second chapter, first section
=== Second chapter, first section, first subsection
#pagebreak()
=== Second chapter, first section, second subsection
#pagebreak()
== Second chapter, second section
=== Second chapter, second section, first subsection
#pagebreak()
=== Second chapter, second section, second subsection
