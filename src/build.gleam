// IMPORTS ---------------------------------------------------------------------

import gleam/list
import gleam/map
import lustre/ssg
import content
import content/index
import content/posts
import post
import static

const output_dir = "./dist"

// MAIN ------------------------------------------------------------------------

pub fn main() {
  // get the filenames of all posts
  let assert Ok(posts_files) = static.posts()

  let assert Ok(posts) = list.try_map(posts_files, post.post)

  // create a function that generates the link value for posts
  let post_to_link = post.link("/posts/", _)

  // generate the index given the list of posts
  let index_page = index.page(posts, post_to_link)

  // generate the posts page
  let posts_page = posts.page(posts, post_to_link)

  // generate the dynamic route for the post pages
  let post_pages =
    posts
    |> list.map(post.dynamic_route)
    |> map.from_list

  ssg.new(output_dir)
  |> static.add_static_dir
  |> ssg.add_static_route("/", content.page(index_page))
  |> ssg.add_static_route("/posts", content.page(posts_page))
  |> ssg.add_dynamic_route("/posts", post_pages, content.page)
  |> ssg.use_index_routes
  |> ssg.build
}
