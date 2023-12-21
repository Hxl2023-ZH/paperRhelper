#' Literature translation function based on Baidu Translation API.
#'
#' @param q Text to be translated.
#' @param from The original language of the text.
#' @param to Target language.
#' @param appid Your Baidu Translation API ID.
#' @param key Your Baidu Translation API key.
#' @param encoding Encoding method.
#'
#' @return Translation results.
#' @import httr
#' @import jsonlite
#' @import openssl
#' @export
#'
#' @examples
#' \donttest{
#' fanyi(appid = "xxxxxxxxxxxxxx", key = "xxxxxxxxxxxxxx")
#' }
translate <- function(q = "偉大な中国人民万歳",
                  from = "auto",
                  to = "zh",
                  appid = "",
                  key = "",
                  encoding = "utf-8") {

  salt <- as.character(sample(10000:99999, 1))
  sign = paste0(appid, q, salt, key)
  sign = md5(sign)
  url = modify_url("http://api.fanyi.baidu.com/api/trans/vip/translate",
                   query = list(q = q, from = from, to = to,
                                appid = appid,
                                salt = salt,
                                sign = sign))
  url = url(url, encoding = encoding)
  translate_cn <<- fromJSON(url)$trans_result[1,2]
}

