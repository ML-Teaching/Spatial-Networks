
bookdown::render_book("index.Rmd")

bookdown::render_book("index.Rmd", "bookdown::pdf_book")

browseURL("docs/index.html")


