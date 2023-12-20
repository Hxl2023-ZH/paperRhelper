#' Obtain citation information from Google Scholar.
#'
#' @param paper_title The paper title.
#'
#' @return Citation information.
#' @import xml2
#' @import rvest
#' @import tidyr
#' @import curl
#' @export
#'
#' @examples
#' \donttest{
#' # Enable proxy
#' r.proxy::proxy()
#' # disable proxy
#' r.proxy::noproxy()

#' paper_title <- "The hematologic consequences of obesity"
#' gscholar_analysis(paper_title = paper_title)
#' cited_title
#' }
gscholar_analysis <- function(paper_title = NULL){

  url <- paste0("https://scholar.google.com/scholar?hl=zh-CN&as_sdt=0%2C5&q=", URLencode(paper_title), "&btnG=")
  i <- curl(url, handle = curl::new_handle("useragent" = "Mozilla/5.0"))
  webpage <- read_html(i, encoding = 'utf-8') %>%
    html_nodes(xpath = '//*[@id="gs_res_ccl_mid"]/div/div[2]/div[5]/a[3]')

  cited_link0 <- webpage  %>% html_attr(name = 'href')
  cited_sum <- webpage %>% html_text(trim = TRUE)
  cited_paper_sum <- as.numeric(sub("被引用次数：", "", cited_sum))
  page_num <- ceiling(cited_paper_sum/10)

  cited_link <- c()
  for (i in 1:page_num) {
    if (i == 1){
      cited_link <- c(cited_link, "https://scholar.google.com/scholar?hl=zh-CN&as_sdt=5&sciodt=0&cites=6714114238831677087&scipsc=")
    } else {
      start = as.character((i-1)*10)
      cited_link <- c(cited_link, paste0("https://scholar.google.com/scholar?start=", URLencode(start), "&hl=zh-CN&as_sdt=2005&sciodt=0&cites=6714114238831677087&scipsc="))
    }
  }
  cited_link

  tmp_title <- c()
  for (i in cited_link){
    tmp_link <- curl(i, handle = curl::new_handle("useragent" = "Mozilla/5.0"))
    tmp <- read_html(tmp_link, encoding = 'utf-8')
    tmp_title <- c(tmp_title, tmp %>% html_nodes(".gs_rt") %>% html_text(trim = TRUE))
  }
  cited_title <<- tmp_title[!tmp_title == tmp_title[1]]
}



