## paper.Rscholar

**paper.Rscholar** is an R package used to assist scientific researchers in literature analysis and organization. This R package can remotely search PubMed and Google Scholar databases and extract key search information through web crawler tools. It also has batch PDF file download functions and online translation functions. The online translation function is implemented based on Baidu Translation API, which can automatically identify the language of the text and translate it.

## Installation

```R
# install from github
devtools::install_github("Hxl2023-ZH/paperRhelper")
library(paper.Rhelper)
```

## Usage

**search_link():** Based on the search terms entered by the user, a search link to the PubMed database is generated for subsequent analysis, and the search results are briefly summarized. Search term for example(including author and publication data): "((Wang, Xin[Author]) AND (Zhang, Yan[Author])) AND ((\"2023/01/02\"[Date - Publication] : \"2023/12/10\"[Date - Publication]))"

```R
# example
> term <- "(Wang, Xin[Author]) AND (Zhang, Yan[Author])"
> size <- "20"
> page <- ''
> search_link(term = term, size = size, page = page)
[1] "https://pubmed.ncbi.nlm.nih.gov/?term=(Wang,%20Xin[Author])%20AND%20(Zhang,%20Yan[Author])&size=20&page="
[1] "Total search result: 53"
[1] "Total pages: 3"
```

pubmed_extract() :

gscholar_analysis():

crossref_citation():

build_author_network():

similar_literature():

scihub_download():

**fanyi():** Automatically recognizes the text language and translates it, by default to English. Users only need to register a developer account for Baidu Translation API in advance. Random numbers are automatically generated and the user does not need to enter them manually.

```R
# example
> fanyi(q = "偉大な中国人民万歳",
      appid = "202312180xxxxxxxx", 
      key = "qHUNma632FtExxxxxxxx")

A connection with description "http://api.fanyi.baidu.com/api/trans/vip/translate?q=%E5%81%89%E5%A4%A7%E3%81%AA%E4%B8%AD%E5%9B%BD%E4%BA%BA%E6%B0%91%E4%B8%87%E6%AD%B3&from=auto&to=zh&appid=202312180xxxxxxxx&salt=40118&sign=1850edbf24fe542bad6b610177864ac1"
class       "url-libcurl"  
mode        "r"                       
text        "text"                                         
opened      "closed"                                             can read    "yes"                                                 can write   "no"                                                  [1] "伟大的中国人民万岁"
```

cited_extract():

plot_coauthors():

keyword_plot():

year_plot():

pdf_doi_extract():

pdf_reference_extract():

## Note