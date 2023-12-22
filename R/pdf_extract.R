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


#' Detecting the presence of specific strings in PDF files
#'
#' @param keyword Key word.
#' @param pdffile PDF file name.
#'
#' @import pdftools
#' @import stringr
#'
#' @return SRA character search results.
#' @export
#'
#' @examples
#' \donttest{
#' setwd("/you/pdf/dir")
#' fileinput <- list.files("/you/pdf/dir")
#' fileinput
#' for (d in fileinput){
#'   pdf_sra_detect(pdffile = d)
#' }
#' }
pdf_sra_detect <- function(keyword = NULL, pdffile = NULL) {

  pdf_text <- pdf_text(pdffile)
  filebase = basename(pdffile)

  # 判断是否有关键词输入
  sra_word <- NULL
  if (is.null(keyword)){
    print("Default keyword.")
    sra_word <- c("PRJNA", "JNA", "PRJEB", "JEB", "ERP")
  }else{
    sra_word <- keyword
  }

  sra_page <- c()
  for (i in seq_along(pdf_text)) {
    if (str_detect(pdf_text[i], regex(paste(sra_word, collapse = "|")))) {
      sra_page <- c(sra_page, i)
    }
  }

  # 判断文献中是否存在
  if (is.null(sra_page)) {
    print(paste("SRA Data not Found in", filebase))
  }else{
    print(paste("SRA Data Found in", filebase))
  }

}


#' Detect and extract github links for a single page.
#'
#' @param pdf_text PDF file name.
#' @param github_word github related word.
#' @param git_page_num numeric.
#' @param filebase file base name.
#'
#' @import pdftools
#' @import stringr
#'
#' @return github link.
#'
#' @examples
#' \donttest{
#' github_link_extract()
#' }
github_link_extract <- function(pdf_text = NULL, github_word = NULL, git_page_num = NULL, filebase = NULL) {

  # 相关PDF页面格式化
  git_page <- str_split(pdf_text[git_page_num], '\n')

  # 确定github单词所在的文本行
  github_line <- c()
  for (i in seq_along(git_page[[1]])) {
    if (str_detect(git_page[[1]][i], github_word)) {
      github_line <- c(github_line, i)
    }
  }
  github_line

  # 判断一页文本中是否存在多个github链接
  if (length(github_line) == 1){
    num0 <- as.numeric(github_line[1])
    num1 = num0 + 1
    github_link_line <- git_page[[1]][num0:num1]

    link_line_merge <- paste0(github_link_line[1], github_link_line[2])
    print(link_line_merge)

    sink("pdf_github_found.txt", append = TRUE)
    print(paste(filebase, link_line_merge, sep = "\t"))
    sink()
  }else{
    for (i in 1:length(github_line)){
      num0 <- as.numeric(github_line[i])
      num1 = num0 + 1
      github_link_line <- git_page[[1]][num0:num1]

      link_line_merge <- paste0(github_link_line[1], github_link_line[2])
      print(link_line_merge)

      sink("pdf_github_found.txt", append = TRUE)
      print(paste(filebase, link_line_merge, sep = "\t"))
      sink()
    }
  }

}


#' Detect and extract github link.
#'
#' @param pdffile PDF file name.
#' @param git_word github related word.
#'
#' @import pdftools
#' @import stringr
#'
#' @return Github links.
#' @export
#'
#' @examples
#' \donttest{
#' setwd("C:/Users/huxin/Desktop/test")
#' fileinput <- list.files("C:/Users/huxin/Desktop/test")
#' fileinput
#' for (d in fileinput){
#'   try(pdf_github(pdffile = d))
#' }
#' }
pdf_github <- function(pdffile = NULL, git_word = NULL){

  pdf_text <- pdf_text(pdffile)
  filebase <- basename(pdffile)

  github_word <- NULL
  if (is.null(git_word)){
    github_word <- "github"
  }else{
    github_word <- git_word
  }

  #判断github链接数量
  github_page <- c()
  for (i in seq_along(pdf_text)) {
    if (str_detect(pdf_text[i], github_word)) {
      github_page <- c(github_page, i)
    }
  }

  if (is.null(github_page)) {
    print("Github link not found in the paper")
    sink("pdf_github_not_found.txt", append = TRUE)
    print(filebase)
    sink()
    break
  }else{
    github_page <- unique(github_page)
  }

  for (f in 1:length(github_page)) {
    git_page_num <- as.numeric(github_page[f])
    github_link_extract(pdf_text = pdf_text, github_word = github_word, git_page_num = git_page_num, filebase = filebase)
  }
}

