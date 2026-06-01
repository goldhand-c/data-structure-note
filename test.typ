#set text(size: 12pt)
#set page(numbering: "1")
#set heading(numbering: "1.A")

#context {
  let section_mapper(section) = {
    let section_location = section.location()
    let section_num = numbering(
      heading.numbering,
      ..counter(heading).at(section_location),
    )
    let section_page = numbering(
      section_location.page-numbering(),
      ..counter(page).at(section_location),
    )
    return link(
      section_location,
      [#section_num #section.body (#section_page).] + h(0.5em),
    )
  }

  let chapters = query(heading.where(level: 1))
  let sections = query(heading.where(level: 2))

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
    let chapter_sections = sections.filter(section => counter(heading).at(section.location()).at(0) == i)
    let chapter_sections_body = chapter_sections.map(section_mapper).join()

    block(
      above: 6mm,
      below: 4mm,
      link(
        chapter_location,
        text(
          size: 1.5em,
          weight: "bold",
          [#chapter_num]
            + h(0.4em)
            + chapter.body
            + h(0.2em)
            + box(
              width: 1fr,
              repeat(gap: 0.15em, [.]),
            )
            + h(0.2em)
            + chapter_page,
        ),
      )
        + align(
          right,
          block(
            width: 96%,
            above: 5mm,
            align(left, par(justify: true, chapter_sections_body)),
          ),
        ),
    )
  }
}

#pagebreak()

= The first chapter
== First chapter, first section
#pagebreak()
== First chapter, second section
#pagebreak()
== First chapter, third section
#pagebreak()
== First chapter, fourth section
#pagebreak()
= The second chapter
== Second chapter, first section
#pagebreak()
== Second chapter, second section
#pagebreak()
== Second chapter, third section
#pagebreak()
== Second chapter, fourth section
