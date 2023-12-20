#' similar literature recommend.
#'
#' @param pubmedid The article PubMed ID.
#'
#' @return A data frame of similar literature information:similar_literature_table.
#' @import xml2
#' @import rvest
#' @import tidyr
#' @import httr
#' @export
#'
#' @examples
#' \donttest{
#' ### Example
#' similar_literature(pubmedid = '32134010')
#' write.csv(similar_literature_table, file = 'similar_literature.csv',row.names = F)
#' }
similar_literature <- function(pubmedid = NULL){

  title <- c()
  web <- c()
  abs_res <- c()
  pmid <- c()
  cited_sum <- c()

  ### URL
  root = 'https://pubmed.ncbi.nlm.nih.gov/?size=200&linkname=pubmed_pubmed&from_uid='
  url <- paste0(root, pubmedid)

  ### URL Check
  response <- HEAD(url)
  status_code <- response$status_code

  if (status_code == 200) {
    print("Network Status 200")
  } else if (status_code == 404) {
    print("Network Status 404")
    break
  } else {
    print("Network ERROR")
    break
  }

  # paper numbers
  paper_numbers <- read_html(url, encoding = 'utf-8') %>%
    html_nodes(xpath = '//*[@id="search-results"]/div[2]/div[1]/div[1]/h3/span') %>%
    html_text(trim = T)
  paper_numbers <- as.numeric(paper_numbers)

  ### Title
  for (i in url){
    title <- c(title, read_html(i, encoding = 'utf-8') %>%
                 html_nodes('.docsum-title') %>%
                 html_text(trim = T))
  }
  print("Extract Title Information Finished!")

  ### Paper Link
  for (i in url){
    web <- c(web,read_html(i, encoding = 'utf-8') %>% html_nodes('.docsum-title') %>% html_attr(name = 'href'))
  }
  web_link <- paste('https://pubmed.ncbi.nlm.nih.gov', web, sep = '')

  ### Abstract
  abstract <- list()
  for (i in web_link) {
    abstract[[i]] <- read_html(i, encoding = 'utf-8') %>% html_nodes('#abstract') %>% html_text(trim = T)
  }

  abstract_clean <- lapply(abstract, gsub,pattern = '\n',replacement='')

  for (i in 1:paper_numbers){
    len = length(abstract_clean[[i]])
    if (len == 0){
      print("No Abstract Found!")
      abs_res <- c(abs_res, "None_Abstract")
    }else{
      abs_res <- c(abs_res, abstract_clean[[i]])
    }
  }
  print("Extract Abstract Information Finished!")

  ### DOI
  for (i in url){
    mydoi <- c(mydoi, read_html(i, encoding = 'utf-8') %>%
                 html_nodes('.full-journal-citation') %>%
                 html_text(trim = T))
  }

  # doi
  doi <- mydoi %>% gsub(pattern = '.*doi: ', replacement='') %>%
    gsub(pattern = ' .*', replacement = '' ) %>%
    gsub(pattern = '.$', replacement = '')

  # PMID
  for (i in url){
    pmid <- c(pmid, read_html(i, encoding = 'utf-8') %>%
                html_nodes('.docsum-pmid') %>%
                html_text(trim = T))
  }

  print(length(title))
  print(length(doi))
  print(length(pmid))
  print(length(abs_res))

  similar_literature_table <<- data.frame(Title = title,
                                          DOI = doi,
                                          PMID = pmid,
                                          Web = web_link,
                                          Abstract = abs_res)

}
