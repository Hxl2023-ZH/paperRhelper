#' Obtain the download link for sci hub based on DOI.
#'
#' @param doi The paper doi.
#' @return download link.
#' @import httr
#' @examples
#' \donttest{
#' get_scihub_url(doi = "10.1038/nrmicro3564")
#' }
get_scihub_url <- function(doi) {

  url <- paste0("https://sci-hub.se/", doi)
  pdf_url <- NULL
  response <- NULL
  response_tmp <- GET(url)
  if (grepl("未找到文章", response_tmp)){
    print("No paper found in sci-hub!")
  }else{
    response <- response_tmp
    print("Paper found in sci-hub!")
  }

  if (status_code(response) == 200) {
    content <- content(response, as = "text")
    pdf_url1 <- sub(".*location.href='(.*)'.*", "\\1", content)
    if (grepl("sci-hub", pdf_url1)){
      pdf_url <- paste0("https:", pdf_url1)
    }else{
      pdf_url <- paste0("https://sci-hub.se", pdf_url1)
    }
  } else {
    print("Response failed!")
  }
}

#' Download PDF from sic-hub.
#'
#' @param doi paper doi.
#' @param file_dir File save path.
#'
#' @return PDF.
#' @import httr
#' @export
#'
#' @examples
#' \donttest{
#' doi <- final_table$DOI
#' for (i in doi) {
#'   print(i)
#'   try(scihub_download1(doi = i, file_dir = "C:/your/path/"), silent = TRUE)
#' }
#' }
scihub_download <- function(doi, file_dir){
  pdf_url <- get_scihub_url(doi)
  response <- GET(pdf_url)
  if (status_code(response) == 200) {
    filename <- paste0(gsub("[/]", "", doi), ".pdf")
    local_path <- paste0(file_dir, filename)
    writeBin(content(response, "raw"), local_path)
    print("pdf download!")
  } else {
    print("Download Response Failed!")
  }
}
