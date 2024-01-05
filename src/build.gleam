// IMPORTS ---------------------------------------------------------------------

import gleam/list
import gleam/dict as map
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

  // generate the index given the list of posts
  let index_page = index.page(posts)

  // generate the posts page
  let posts_page = posts.page(posts)

  // generate the dynamic route for the post pages
  let post_pages =
    posts
    |> list.map(post.dynamic_route)
    |> map.from_list

  ssg.new(output_dir)
  |> static.add_static_dir
  |> ssg.add_static_route("/", content.render_page(index_page))
  |> ssg.add_static_route("/posts", content.render_page(posts_page))
  |> ssg.add_dynamic_route("/posts", post_pages, content.render_page)
  |> ssg.use_index_routes
  |> ssg.build
}
