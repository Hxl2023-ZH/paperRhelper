#' Cited Analysis.
#'
#' @param root common web link part.
#' @param page_number page number.
#' @param paper_numbers paper number.
#'
#' @return The paper cited details
#' @import rvest
#' @import dplyr
#' @export
#'
#' @examples
#' \donttest{
#' cited_doi1 <- list()
#' cited_doi0 <- list()
#' mytest <- cited_extract(page_number = 1, paper_numbers = 20)
#' }
cited_extract <- function(root = 'https://pubmed.ncbi.nlm.nih.gov/?term=(Wang,%20Xin[Author])%20AND%20(Zhang,%20Yan[Author])&size=20&page=',
                          page_number = 1,
                          paper_numbers = 1){
  url <- paste0(root, 1:page_number)
  web <- c()

  for (i in url){
    web <- c(web,read_html(i, encoding = 'utf-8') %>% html_nodes('.docsum-title') %>% html_attr(name = 'href'))
  }
  web_link <- paste('https://pubmed.ncbi.nlm.nih.gov',web,sep = '')


  for (i in web_link){

    node = read_html(i, encoding = 'utf-8') %>% html_nodes(".show-all-linked-articles")
    if (length(node) == 0){
      print(0)
    }else{
      print(1)
      cited_link0 <- read_html(i, encoding = 'utf-8') %>%
        html_nodes(xpath = '//*[@id="citedby"]/div/a') %>%
        html_attr(name = 'data-href')
      print(cited_link0)

      if (length(cited_link0) == 0){
        print("--------link_problem---------")
      }else{
        cited_link <- paste0("https://pubmed.ncbi.nlm.nih.gov", cited_link0)
        print(cited_link)
        cited_doi0 <- read_html(cited_link, encoding = 'utf-8') %>%
          html_nodes('.full-journal-citation') %>% html_text(trim = T)
        cited_doi1 <<- c(cited_doi1, list(cited_doi0))

      }
    }
  }
  return(cited_doi1)
}


