import content.{
  type Page, type Post, Bold, Code, Heading, List, Page, Paragraph, Section,
  Snippet, Subheading, Text, Title,
}
import gleam/list
import post

pub fn page(posts: List(Post)) -> Page {
  Page(
    title: "Home",
    content: [
      Title("Hello, world!"),
      Section([
        Paragraph([Text("Here are all the posts!")]),
        List(list.map(posts, post.link)),
        Heading("We can write code snippets..."),
        Snippet(
          "gleam",
          "import gleam/io

pub fn main() {
  io.println(\"Hello, world!\")
}",
        ),
        Subheading("...and even format text!"),
        Paragraph([
          Text("This is some text. "),
          Bold("This is bold. "),
          Text("This text has some "),
          Code("code"),
          Text(" in it."),
        ]),
      ]),
    ],
  )
}
