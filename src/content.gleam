import gleam/list
import lustre/attribute.{type Attribute, attribute}
import lustre/element.{type Element}
import lustre/element/html.{html}
import simplifile

pub type Err {
  FileError(simplifile.FileError)
  StringError(String)
}

pub type Post {
  Post(path: String, title: String, src: String)
}

pub type Page {
  Page(title: String, content: List(Content))
}

pub type Content {
  Title(String)
  Heading(String)
  Subheading(String)
  Section(List(InlineContent))
  Snippet(lang: String, code: String)
  StaticMarkdown(src: String)
}

pub type InlineContent {
  Bold(String)
  Code(String)
  Link(href: String, text: String)
  Text(String)
}

fn static_md_block(attrs: List(Attribute(msg))) -> Element(msg) {
  element.element("md-block", attrs, [])
}

pub fn content(content: Content) -> Element(msg) {
  case content {
    Title(text) -> html.h1([], [element.text(text)])
    Heading(text) -> html.h2([], [element.text(text)])
    Subheading(text) -> html.h3([], [element.text(text)])
    Section(content) -> html.p([], list.map(content, inline_content))
    Snippet(lang, code) ->
      html.pre(
        [attribute("data-lang", lang)],
        [
          html.code(
            [attribute.class("language-" <> lang)],
            [element.text(code)],
          ),
        ],
      )
    StaticMarkdown(src: src) -> static_md_block([attribute.src(src)])
  }
}

fn inline_content(content: InlineContent) -> Element(msg) {
  case content {
    Bold(text) -> html.strong([], [element.text(text)])
    Code(text) -> html.code([], [element.text(text)])
    Link(href, text) -> html.a([attribute("href", href)], [element.text(text)])
    Text(text) -> element.text(text)
  }
}

pub fn page(page: Page) -> Element(msg) {
  html(
    [attribute("lang", "en"), attribute.class("overflow-x-hidden")],
    [
      html.head(
        [],
        [
          html.title([], page.title),
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
          html.script(
            [
              attribute.type_("module"),
              attribute.src("https://md-block.verou.me/md-block.js"),
            ],
            "",
          ),
        ],
      ),
      html.body([], [html.div([], list.map(page.content, content))]),
    ],
  )
}
