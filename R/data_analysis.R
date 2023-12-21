#' Keyword frequency statistics.
#'
#' @param words keyword.
#' @param size size.
#' @param shape shape.
#'
#' @return Word cloud diagram
#' @export
#' @import wordcloud2
#' @import jiebaR
#' @importFrom dplyr arrange
#'
#' @examples
#' \donttest{
#' keyword_plot(final_table$Keyword)
#' }
keyword_plot <- function(words, size = 0.7, shape = 'circle'){
  engine <- worker()
  segment <- segment(words, engine)
  wordfreqs <- freq(segment)
  wordcloud2(wordfreqs)
  wordf <- arrange(wordfreqs, -freq)
  wordcloud2(data=wordf, size = size, shape = shape)
}


#' Counting the number of literature publications per year.
#'
#' @param year A data frame contain year of publication of the articles.
#' @return line chart
#' @export
#' @import wordcloud2
#' @import jiebaR
#' @import ggplot2
#' @examples
#' \donttest{
#' year_plot(final_table$Year)
#' }
year_plot <- function(year) {
  engine <- worker()
  segment <- segment(year, engine)
  wordfreqs <- freq(segment)

  ggplot(wordfreqs, aes(x = char, y = freq)) +
    geom_point()+
    geom_line(aes(group = 1), color = "red")+
    theme_classic()+
    theme(axis.text.x = element_text(size = 15),
          axis.text.y = element_text(size = 15),
          axis.title.x = element_text(size = 20),
          axis.title.y = element_text(size = 20))+
    labs(x = "Years", y = "Total Papers")

  ggsave("year_plot.png", width = 5, height = 5, dpi = 300)
  ggsave("year_plot.pdf", width = 5, height = 5)
}
