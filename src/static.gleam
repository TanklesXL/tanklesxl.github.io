import lustre/ssg
import simplifile
import gleam/result
import content.{FileError}

pub fn add_static_dir(config: ssg.Config(_, ssg.NoStaticDir, _)) {
  ssg.add_static_dir(config, static_dir)
}

const static_dir = "./static"

const posts_dir = "./static/posts"

pub fn posts() -> Result(List(String), content.Err) {
  simplifile.list_contents(posts_dir)
  |> result.map_error(FileError)
}
