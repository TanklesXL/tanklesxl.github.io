import content.{
  type Page, type Post, Bold, Code, Heading, Link, List, Page, Paragraph,
  Section, Snippet, Subheading, Text, Title,
}

pub fn page() -> Page {
  Page(title: "gleam", content: [
    Title("Gleam Stuff"),
    Subheading("Libraries"),
    List([Link(href: "https://github.com/tanklesxl/glint", text: "glint")]),
    Subheading("Tools"),
    List([Link(href: "https://github.com/tanklesxl/gladvent", text: "gladvent")]),
  ])
}
