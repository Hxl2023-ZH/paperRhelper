#' Extract the search results from the PubMed database.
#'
#' @param root The public part of webpage links.
#' @param page_number Total pages of search results.
#' @param paper_numbers Total number of retrieved papers.
#' @return A data frame including article title, abstract, etc.
#' @export
#' @examples
#' \donttest{
#' pubmed_extract(page_number = 1, paper_numbers = 20)
#' }
pubmed_extract <- function(root = 'https://pubmed.ncbi.nlm.nih.gov/?term=(Wang,%20Xin[Author])%20AND%20(Zhang,%20Yan[Author])&size=20&page=',
                           page_number = 1,
                           paper_numbers = 1){

  title <- c()
  web <- c()
  abs_res <- c()
  mydoi <- c()
  pmid <- c()
  cited_sum <- c()

  ### search link
  url <- paste0(root, 1:page_number)

  ### title
  for (i in url){
    title <- c(title, read_html(i, encoding = 'utf-8') %>%
                 html_nodes('.docsum-title') %>%
                 html_text(trim = T))
  }

  ### paper link
  for (i in url){
    web <- c(web,read_html(i, encoding = 'utf-8') %>% html_nodes('.docsum-title') %>% html_attr(name = 'href'))
  }
  web_link <- paste('https://pubmed.ncbi.nlm.nih.gov',web,sep = '')

  ### author
  author0 <- c()
  for (i in web_link) {
    author0 <- c(author0, read_html(i, encoding = 'utf-8') %>%
                   html_nodes(xpath = '//*[@id="full-view-heading"]/div[2]/div') %>%
                   html_text(trim = TRUE))
  }
  author0

  author1 <- gsub('\\d', "", author0)
  author2 <- gsub('\\n', "", author1)
  author <- gsub('\\s+', " ", author2)

  ### abstract
  abstract <- list()
  for (i in web_link) {
    abstract[[i]] <- read_html(i, encoding = 'utf-8') %>% html_nodes('#abstract') %>% html_text(trim = T)
  }
  abstract_clean <- lapply(abstract, gsub,pattern = '\n',replacement='')
  # Merge multiple summaries
  for (i in 1:paper_numbers){
    len = length(abstract_clean[[i]])
    if (len == 1){
      abs_res <- c(abs_res, abstract_clean[[i]])
    }else{
      abs_res <- c(abs_res, paste0(abstract_clean[[i]]), sep = '-', collapse = '')
    }
  }

  ### paper DOI
  for (i in url){
    mydoi <- c(mydoi, read_html(i, encoding = 'utf-8') %>%
                 html_nodes('.full-journal-citation') %>%
                 html_text(trim = T))
  }

  doi <- mydoi %>% gsub(pattern = '.*doi: ', replacement='') %>%
    gsub(pattern = ' .*', replacement = '' ) %>%
    gsub(pattern = '.$', replacement = '')

  # Obtain the year of publication of the article
  year <- sub(".* (\\d{4}) .*", "\\1", mydoi)

  # paper PMID
  for (i in url){

    pmid <- c(pmid, read_html(i, encoding = 'utf-8') %>%
                html_nodes('.docsum-pmid') %>%
                html_text(trim = T))

  }

  ### the number of citations and relevant literature DOI for the article
  cited_link <- c()
  for (i in web_link){
    cited_link <- c(cited_link,read_html(i, encoding = 'utf-8') %>%
                      html_nodes('.show-all-linked-articles') %>%
                      html_attr(name = 'href'))
  }

  web_link <- paste('https://pubmed.ncbi.nlm.nih.gov',web,sep = '')

  for (i in web_link){
    # Determine if there is a reference
    node = read_html(i, encoding = 'utf-8') %>% html_nodes(".show-all-linked-articles")
    if (length(node) == 0){
      print(0)
      cited_sum <- c(cited_sum,"0")
    }else{
      print(1)
      cited_link0 <- read_html(i, encoding = 'utf-8') %>%
        html_nodes(xpath = '//*[@id="citedby"]/div/a') %>%
        html_attr(name = 'data-href')
      print(cited_link0)
      # Determine if link access is valid
      if (length(cited_link0) == 0){
        print("--------link_problem---------")
        cited_sum <- c(cited_sum,"error_linked")
      }else{
        cited_link <- paste0("https://pubmed.ncbi.nlm.nih.gov", cited_link0)
        print(cited_link)
        cited_sum <- c(cited_sum, read_html(cited_link, encoding = 'utf-8') %>% html_nodes(xpath = '//*[@id="search-results"]/div[2]/div[1]/div[1]/h3/span') %>% html_text())
      }
    }
  }


  ### keyword
  keywd <- list()
  for (i in web_link){
    keywd1 <- read_html(i, encoding = 'utf-8') %>% html_nodes(xpath = '//*[@id="abstract"]/p/text()') %>% html_text(trim = TRUE)
    print(keywd1)
    keywd <- c(keywd, list(keywd1))
  }

  keyword <- c()
  for (i in 1:paper_numbers){
    len = length(keywd[[i]])
    if (len == 1){
      keyword[i] <- keywd[[i]]
    }else{
      keyword[i] <- keywd[[i]][2]
    }
  }

  print(length(cited_doi))
  print(length(title))
  final_table <<- data.frame(Title = title,
                             Author = author,
                             Reference = mydoi,
                             Keyword = keyword,
                             DOI = doi,
                             PMID = pmid,
                             Year = year,
                             Cited = cited_sum,
                             Web = web_link,
                             Abstract = abs_res)

}


#' Obtain information such as citation frequency of literature through CrossRef.
#'
#' @param mydoi paper DOI.
#'
#' @return Number of citations, etc.
#' @export
#' @importFrom rcrossref cr_citation_count
#'
#' @examples
#' \donttest{
#' mydoi <- c("10.1016/j.metabol.2020.154171", "10.3390/metabo10020048", "12.3390/metabo10020048")
#' crossref_citation(mydoi = mydoi)
#' crossref_citation_table
#' }
crossref_citation <- function(mydoi){
  c_doi <- c()
  c_count <- c()
  for (i in mydoi){
    co <- cr_citation_count(i)
    print(length(co))
    if (is.na(co$count) == FALSE) {
      c_doi <- c(c_doi, co$doi)
      c_count <- c(c_count, co$count)
    }else{
      c_doi <- c(c_doi, i)
      c_count <- c(c_count, "0")
    }
    crossref_citation_tab <- data.frame(DOI = c_doi, Cited = c_count)
    crossref_citation_tab$Cited <- as.numeric(crossref_citation_tab$Cited)
    crossref_citation_table <<- crossref_citation_tab[order(-crossref_citation_tab$Cited),]
  }
}
