import content.{
  type Content, type Err, type Page, type Post, Link, Page, Post, StaticMarkdown,
  StringError,
}
import gleam/result
import gleam/string

const post_path = "/posts/"

pub fn post(filename: String) -> Result(Post, Err) {
  use #(title, _) <- result.map(
    filename
    |> string.split_once(".md")
    |> result.replace_error(StringError(
      "failed to remove .md suffix from '" <> filename <> "'",
    )),
  )
  Post(
    path: title,
    title: title
    |> string.replace("_", " ")
    |> string.replace("-", " ")
    |> string.capitalise,
    src: post_path <> filename,
  )
}

pub fn link(post: Post) -> Content {
  Link(href: post_path <> post.path, text: post.title)
}

pub fn dynamic_route(post: Post) -> #(String, Page) {
  #(post.path, Page(title: post.title, content: [StaticMarkdown(post.src)]))
}
