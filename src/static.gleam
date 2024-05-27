import content.{FileError, StringError}
import gleam/list
import gleam/result
import gleam/string
import lustre/ssg
import simplifile

pub fn add_static_dir(config: ssg.Config(_, ssg.NoStaticDir, _)) {
  ssg.add_static_dir(config, static_dir)
}

const static_dir = "./static"

const posts_dir = "./static/posts"

pub fn posts() -> Result(List(String), content.Err) {
  simplifile.get_files(posts_dir)
  |> result.map_error(FileError)
  |> result.try(list.try_map(_, fn(f) {
    use filename <- result.map(
      string.split_once(f, posts_dir <> "/")
      |> result.replace_error(StringError("failed to split file:" <> f)),
    )
    filename.1
  }))
}
