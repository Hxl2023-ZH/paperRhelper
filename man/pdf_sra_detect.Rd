% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pdf_extract.R
\name{pdf_sra_detect}
\alias{pdf_sra_detect}
\title{Detecting the presence of specific strings in PDF files}
\usage{
pdf_sra_detect(keyword = NULL, pdffile = NULL)
}
\arguments{
\item{keyword}{Key word.}

\item{pdffile}{PDF file name.}
}
\value{
SRA character search results.
}
\description{
Detecting the presence of specific strings in PDF files
}
\examples{
\donttest{
setwd("/you/pdf/dir")
fileinput <- list.files("/you/pdf/dir")
fileinput
for (d in fileinput){
  pdf_sra_detect(pdffile = d)
}
}
}
