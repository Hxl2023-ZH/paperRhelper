#' Literature translation function based on Baidu Translation API.
#'
#' @param q Text to be translated.
#' @param from The original language of the text.
#' @param to Target language.
#' @param appid Your Baidu Translation API ID.
#' @param salt Random Password.
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
#' fanyi(appid = "20231218001914384", key = "qHUNma632FtElNsgSPaM")
#' }
fanyi <- function(q = "apple",
                  from = "en",
                  to = "zh",
                  appid = "",
                  salt = "1435660288",
                  key = "",
                  encoding = "utf-8") {
  sign = paste0(appid, q, salt, key)
  sign = md5(sign)
  url = modify_url("http://api.fanyi.baidu.com/api/trans/vip/translate",
                   query = list(q = q, from = from, to = to,
                                appid = appid,
                                salt = salt,
                                sign = sign))
  url = url(url, encoding = encoding)
  print(url)
  fromJSON(url)$trans_result[1,2]
}

