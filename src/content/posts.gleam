import content.{type InlineContent,
  type Page, type Post, List, P, Page, Section}
import gleam/list

pub fn page(posts: List(Post), f: fn(Post) -> InlineContent) -> Page {
  Page(
    title: "Links to posts",
    content: [Section(List(list.map(posts, fn(p) { P([f(p)]) })))],
  )
}
