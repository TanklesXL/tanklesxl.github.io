import content.{
  type InlineContent, type Page, type Post, Bold, Code, Heading, List, P, Page,
  Post, Section, Snippet, Subheading, Text, Title,
}
import gleam/list

pub fn page(posts: List(Post), f: fn(Post) -> InlineContent) -> Page {
  Page(
    title: "Home",
    content: [
      Title("Hello, world!"),
      P([Text("Here are all the posts!")]),
      Section(List(list.map(posts, fn(p) { P([f(p)]) }))),
      Heading("We can write code snippets..."),
      Snippet(
        "gleam",
        "import gleam/io

pub fn main() {
  io.println(\"Hello, world!\")
}",
      ),
      Subheading("...and even format text!"),
      P([
        Text("This is some text. "),
        Bold("This is bold. "),
        Text("This text has some "),
        Code("code"),
        Text(" in it."),
      ]),
    ],
  )
}
