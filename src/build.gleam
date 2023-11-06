// IMPORTS ---------------------------------------------------------------------

import gleam/list
import lustre/attribute.{attribute}
import lustre/element.{type Element}
import lustre/element/html.{html}
import lustre/ssg
import content.{type Content}
import content/index

// MAIN ------------------------------------------------------------------------

pub fn main() {
  ssg.new("./dist")
  |> ssg.add_static_route("/", page(index.content, "Home"))
  |> ssg.add_static_dir("./static")
  |> ssg.use_index_routes
  |> ssg.build
}

fn page(content: List(Content), title: String) -> Element(msg) {
  html(
    [attribute("lang", "en"), attribute.class("overflow-x-hidden")],
    [
      html.head(
        [],
        [
          html.title([], title),
          html.meta([attribute("charset", "utf-8")]),
          html.meta([
            attribute("name", "viewport"),
            attribute("content", "width=device-width, initial-scale=1"),
          ]),
          html.link([
            attribute.href(
              "https://cdn.jsdelivr.net/npm/@picocss/pico@1/css/pico.min.css",
            ),
            attribute.rel("stylesheet"),
          ]),
          html.style(
            [],
            " body > div {
                max-width: 60ch;
                margin: 0 auto;
                padding-top: 2rem;
              }
            ",
          ),
          html.link([
            attribute.rel("stylesheet"),
            attribute.href(
              "https://unpkg.com/nord-highlightjs@0.1.0/dist/nord.css",
            ),
            attribute.type_("text/css"),
          ]),
          html.script(
            [
              attribute.src(
                "https://unpkg.com/@highlightjs/cdn-assets@11.9.0/highlight.min.js",
              ),
            ],
            "",
          ),
          html.script(
            [
              attribute.src(
                "https://cdn.jsdelivr.net/gh/gleam-lang/website@main/javascript/highlightjs-gleam.min.js",
              ),
            ],
            "",
          ),
          html.script([], "hljs.highlightAll();"),
        ],
      ),
      html.body([], [html.div([], list.map(content, content.view))]),
    ],
  )
}
