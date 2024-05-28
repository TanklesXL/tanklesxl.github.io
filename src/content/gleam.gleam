import content.{type Page, Link, List, Page, Subheading, Title}

pub fn page() -> Page {
  Page(title: "gleam", content: [
    Title("Gleam Stuff"),
    Subheading("Libraries"),
    List([Link(href: "https://github.com/tanklesxl/glint", text: "glint")]),
    Subheading("Tools"),
    List([Link(href: "https://github.com/tanklesxl/gladvent", text: "gladvent")]),
  ])
}
