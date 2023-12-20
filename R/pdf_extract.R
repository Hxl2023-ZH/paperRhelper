#' PDF reference extraction.
#' @param pdf_text PDF file.
#' @param begin_word Words at the beginning of the reference section.
#' @param end_word Words at the end of the reference section.
#'
#' @return "pdf_reference_extract.txt".
#' @import pdftools
#' @importFrom stringr str_detect str_split
#' @export
#'
#' @examples
#' \donttest{
#' pdf_text <- pdf_text("Machine_learning_for_microbiologists.pdf")
#' begin_word <- "References|REFERENCES"
#' end_word <- "Acknowledgements"
#'
#' pdf_reference_extract(pdf_text = pdf_text, begin_word = begin_word, end_word = end_word)
#' }
#'
pdf_reference_extract <- function(pdf_text = NULL, begin_word = NULL, end_word = NULL){

  start_page <- -1
  end_page <- -1
  for (i in seq_along(pdf_text)) {
    if (str_detect(pdf_text[i], begin_word)) {
      start_page <- i
      break
    }
  }
  print(paste0("The reference section is start from page: ", start_page))

  for (i in seq_along(pdf_text)) {
    if (str_detect(pdf_text[i], end_word)) {
      end_page <- i
      break
    }
  }
  print(paste0("The reference section is end in page: ", end_page))

  references_text <- NULL
  if (start_page != -1 && end_page != -1) {
    references <- pdf_text[start_page:end_page]
    references_text <- paste(references, collapse = "\n")
  } else {
    references_text <- "References section not found."
  }

  merged_pdf_reference <<- str_split(references_text, "\n")
  sink("pdf_reference_extract.txt")
  print(merged_pdf_reference)
  sink()
}



#' Extract DOI from PDF.
#'
#' @param pdf_text PDF file.
#'
#' @return paper doi.
#' @importFrom stringr str_detect str_split
#' @export
#'
#' @examples
#' \donttest{
#' pdf_doi_extract(pdf_text = pdf_text)
#' }
pdf_doi_extract <- function(pdf_text = NULL){

  for (f in 1:length(pdf_text)){
    tmp <- pdf_text[f]
    tmp1 <- str_split(tmp, '\n')
    page_mer <- tmp1[[1]]

    infor <- NULL
    for (i in 1:length(page_mer)){
      doi_word <- grepl("doi", page_mer[i])
      while (doi_word == TRUE) {
        print(page_mer[i])
        infro = TRUE
        break
      }
    }
    while (infor) {
      print("find DOI!")
      break
    }
  }

}
