import content.{type Page, type Post, List, Page, Section}
import gleam/list
import post

pub fn page(posts: List(Post)) -> Page {
  Page(title: "Links to blog posts", content: [
    Section([List(list.map(posts, post.link))]),
  ])
}
