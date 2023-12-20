#' Building a PubMed retrieval link.
#'
#' @param term Search terms.
#' @param size The total number of papers contained on each page of the result.
#' @param page
#'
#' @return PubMed search link
#' @import rvest
#' @import httr
#' @export
#'
#' @examples
#' \donttest{
#' term <- "(m6A) AND (cancer)"
#' term <- "(Wang, Xin[Author]) AND (Zhang, Yan[Author])"
#' term <-  "((Wang, Xin[Author]) AND (Zhang, Yan[Author])) AND ((\"2023/01/02\"[Date - Publication] : \"2023/12/10\"[Date - Publication]))"
#' size <- "20"
#' page <- ''
#'
#' search_link(term = term, size = size, page = page)
#' }
search_link <- function(term, size, page) {

  base_url <- "https://pubmed.ncbi.nlm.nih.gov/"
  search_url <<- paste0(base_url, "?term=", URLencode(term), "&size=", URLencode(size), "&page=", URLencode(page))
  print(search_url)
  i <- search_url
  pub_result_sum <- read_html(i, encoding = 'utf-8') %>%
    html_nodes(xpath = '//*[@id="search-results"]/div[2]/div[1]/div[1]/h3/span') %>%
    html_text(trim = TRUE)

  total_pages <- read_html(i, encoding = 'utf-8') %>%
    html_nodes(xpath = '//*[@id="search-results"]/div[2]/div[2]/div/label[2]') %>%
    html_text(trim = TRUE)

  print(paste0("Total search result: ", pub_result_sum))
  print(paste0("Total pages: ", total_pages))
}

