## paper.Rhelper

**paper.Rhelper** is an R package used to assist scientific researchers in literature analysis and organization. This R package can remotely search PubMed and Google Scholar databases and extract key search information through web crawler tools. It also has batch PDF file download functions and online translation functions. The online translation function is implemented based on Baidu Translation API, which can automatically identify the language of the text and translate it.

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

**pubmed_extract() :** Use a web crawler to extract search results in PubMed and finally return a data frame (*final_table*). The data frame contains information such as title, author, keywords, abstract, and number of citations of all papers obtained by the search.

```R
# example
> root <- 'https://pubmed.ncbi.nlm.nih.gov/?term=(Wang,%20Xin[Author])%20AND%20(Zhang,%20Yan[Author])&size=20&page='
> pubmed_extract(page_number = 1, paper_numbers = 20, root = root)
> summary(final_table)
    Title              Author           Reference           Keyword              DOI           
 Length:20          Length:20          Length:20          Length:20          Length:20         
 Class :character   Class :character   Class :character   Class :character   Class :character  
 Mode  :character   Mode  :character   Mode  :character   Mode  :character   Mode  :character  
     PMID               Year              Cited               Web              Abstract        
 Length:20          Length:20          Length:20          Length:20          Length:20         
 Class :character   Class :character   Class :character   Class :character   Class :character  
 Mode  :character   Mode  :character   Mode  :character   Mode  :character   Mode  :character 
```

gscholar_analysis(): 

**crossref_citation()**: Use the cr_citation_count() function in the R package rcrossref to obtain the number of citations of the paper in the crossref database, and return a data frame (*crossref_citation_table*). Due to network reasons, using this feature may require users to use a network proxy.

```R
# example
> r.proxy::proxy()# Enable network proxy, disable: r.proxy::noproxy()
> crossref_citation(mydoi = final_table$DOI)
> crossref_citation_table 
                             DOI Cited
1  10.1080/15548627.2015.1100356  4012
15             10.1002/hep.30705    44
20            10.1039/d1cc06323e    29
16  10.1016/j.humimm.2014.10.002    26
9      10.1016/j.aca.2022.340337    19
3            10.3390/biom8020041    18
7              10.3390/v12070692    16
11    10.1038/s41420-021-00667-x    12
4   10.1016/j.actbio.2021.07.039    11
14        10.1002/advs.202001502    11
5   10.1021/acs.analchem.2c01459     9
6     10.1007/s10096-022-04401-y     6
10           10.1042/BSR20204136     6
2      10.3390/molecules28041998     3
13  10.1016/j.celrep.2021.109949     3
8       10.3389/fonc.2022.967451     2
12    10.3389/fgene.2022.1019940     1
18          10.3390/bios12090760     1
17    10.1016/j.ibmb.2022.103878     0
19 10.1080/14728222.2023.2216382     0
```

**build_author_network()**: Based on the extracted results, the collaboration network diagram of authors of different articles is drawn.

**plot_coauthors()**: This function comes from the R package scholar and can be used to draw network relationship diagrams. Users can make changes to drawing parameters.

```R
# example
author <- final_table$Author
myauthor <- strsplit(author, split = ',')
for (i in length(myauthor)) {
  myauthor[[i]][1] <- paste0(' ', myauthor[[i]][1])
}
myauthor
myauthor[1] <- NULL # The document corresponding to myauthor[1] is "10.1080/15548627.2015.1100356", but this document has been completed by more than a thousand authors, so for the convenience of demonstration, we have cleared the author information of this article.。

g <- build_author_network(myauthor)
plot_coauthors(g) 
```



**similar_literature()**: Obtain literature similar to an article from the PubMed database, and return as a data frame (*similar_literature_table*).

```R
# example
> similar_literature(pubmedid = '32134010')
> summary(similar_literature_table)
    Title               PMID               Web              Abstract        
 Length:74          Length:74          Length:74          Length:74         
 Class :character   Class :character   Class :character   Class :character  
 Mode  :character   Mode  :character   Mode  :character   Mode  :character  
```

**scihub_download()**: Batch download PDF files from sci-hub database.

```R
# example
doi_df <- final_table$DOI
for (i in doi_df) {
  print(i)
  try(scihub_download(doi = i, file_dir = "C:/you/path/"), silent = TRUE)
}

```

**fanyi():** Automatically recognizes the text language and translates it, by default to Chinese. Users only need to register a developer account for Baidu Translation API in advance (https://fanyi-api.baidu.com/?fr=pcHeader). Random numbers are automatically generated and the user does not need to enter them manually.

```R
# example
> fanyi(q = "偉大な中国人民万歳",
      appid = "202312180xxxxxxxx", 
      key = "qHUNma632FtExxxxxxxx")

A connection with description "http://api.fanyi.baidu.com/api/trans/vip/translate?q=%E5%81%89%E5%A4%A7%E3%81%AA%E4%B8%AD%E5%9B%BD%E4%BA%BA%E6%B0%91%E4%B8%87%E6%AD%B3&from=auto&to=zh&appid=202312180xxxxxxxx&salt=40118&sign=1850edbf24fe542bad6b610177864ac1"
class       "url-libcurl"  
mode        "r"                       
text        "text"                                         
opened      "closed"                                             can read    "yes"                                                 can write   "no"
[1] "伟大的中国人民万岁"
```

cited_extract():

plot_coauthors():

keyword_plot():

year_plot():

pdf_doi_extract():

pdf_reference_extract():

## Note