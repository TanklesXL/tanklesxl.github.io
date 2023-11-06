import content.{type InlineContent, type Page, type Post, Page, Section}
import gleam/list

pub fn page(posts: List(Post), f: fn(Post) -> InlineContent) -> Page {
  Page(title: "Links to posts", content: [Section(list.map(posts, f))])
}
