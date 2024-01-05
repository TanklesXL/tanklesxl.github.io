import gleam/list
import lustre/attribute.{type Attribute, attribute}
import lustre/element.{type Element}
import lustre/element/html.{html}
import simplifile
import lustre/ui/stack
import lustre/ui/sequence.{sequence}

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
  Section(List(Content))
  Paragraph(List(InlineContent))
  Snippet(lang: String, code: String)
  StaticMarkdown(src: String)
  List(List(Content))
  Grid(List(Content))
  Link(href: String, text: String)
}

pub type InlineContent {
  Bold(String)
  Code(String)
  Text(String)
}

fn static_md_block(attrs: List(Attribute(msg))) -> Element(msg) {
  element.element("md-block", attrs, [])
}

pub fn render_content(content: Content) -> Element(msg) {
  case content {
    Title(text) -> html.h1([], [element.text(text)])
    Heading(text) -> html.h2([], [element.text(text)])
    Subheading(text) -> html.h3([], [element.text(text)])
    Link(href, text) -> html.a([attribute("href", href)], [element.text(text)])
    Paragraph(content) ->
      html.p(
        [],
        list.map(content, render_inline_content)
        |> list.intersperse(html.br([])),
      )
    Snippet(lang, code) ->
      html.pre([attribute("data-lang", lang)], [
        html.code([attribute.class("language-" <> lang)], [element.text(code)]),
      ])
    StaticMarkdown(src: src) -> static_md_block([attribute.src(src)])
    Grid(inner) ->
      sequence([attribute.class("grid")], list.map(inner, render_content))
    List(inner) ->
      stack.of(
        html.ul,
        [],
        list.map(inner, fn(elem) { html.li([], [render_content(elem)]) }),
      )

    Section(content) -> html.section([], list.map(content, render_content))
  }
}

fn render_inline_content(content: InlineContent) -> Element(msg) {
  case content {
    Bold(text) -> html.strong([], [element.text(text)])
    Code(text) -> html.code([], [element.text(text)])
    Text(text) -> element.text(text)
  }
}

pub fn render_page(page: Page) -> Element(msg) {
  html([attribute("lang", "en"), attribute.class("overflow-x-hidden")], [
    html.head([], [
      html.title([], page.title),
      html.meta([attribute("charset", "utf-8")]),
      html.meta([
        attribute("name", "viewport"),
        attribute("content", "width=device-width, initial-scale=1"),
      ]),
      html.link([attribute.href("/pico.min.css"), attribute.rel("stylesheet")]),
      html.link([attribute.href("/prism-nord.css"), attribute.rel("stylesheet")]),
      html.script([attribute.src("/prism-core.min.js")], ""),
      html.script([attribute.src("/prism-gleam.js")], ""),
      html.script(
        [
          attribute.type_("module"),
          attribute.src("https://md-block.verou.me/md-block.js"),
        ],
        "",
      ),
    ]),
    html.body([], [
      html.header([attribute.class("container")], [
        stack.of(html.nav, [], [
          stack.of(html.ul, [], [
            html.li([], [render_content(home)]),
            html.li([], [render_content(posts)]),
          ]),
        ]),
      ]),
      html.main(
        [attribute.class("container")],
        list.map(page.content, render_content),
      ),
    ]),
  ])
}

const home = Link(text: "home", href: "/")

const posts = Link(text: "posts", href: "/posts")
