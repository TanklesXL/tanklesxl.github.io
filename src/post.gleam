import content.{
  type Err, type InlineContent, type Page, type Post, Link, Page, Post,
  StaticMarkdown, StringError,
}
import gleam/result
import gleam/string

pub fn post(filename: String) -> Result(Post, Err) {
  use #(title, _) <- result.map(
    filename
    |> string.split_once(".md")
    |> result.replace_error(StringError(
      "failed to remove .md suffix from '" <> filename <> "'",
    )),
  )
  Post(path: title, title: title, src: "/posts/" <> filename)
}

pub fn link(prefix: String, post: Post) -> InlineContent {
  Link(href: prefix <> post.path, text: post.title)
}

pub fn dynamic_route(post: Post) -> #(String, Page) {
  #(post.path, Page(title: post.title, content: [StaticMarkdown(post.src)]))
}
