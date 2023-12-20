#' A function used to build collaborative relationships between authors.
#' @param author_info author information.
#' @return A network.
#' @export
#' @importFrom igraph add_vertices add_edges
#' @examples
#' \donttest{
#' myauthor <- NULL
#' myauthor <- strsplit(author, split = ',')
#' for (i in length(myauthor)) {
#'   myauthor[[i]][1] <- paste0(' ', myauthor[[i]][1])
#' }
#' g <- build_author_network(myauthor)
#' }
build_author_network <- function(author_info) {

  g <- graph.empty()

  for (i in seq_along(author_info)) {

    names <- author_info[[i]]

    for (j in seq_along(names)) {

      name <- names[j]

      if (!name %in% V(g)$name) {
        g <- add_vertices(g, 1, name = name)
      }

      for (k in (j + 1):length(names)) {

        other_name <- names[k]

        if (!other_name %in% V(g)$name) {
          g <- add_vertices(g, 1, name = other_name)
        }

        if (!are.connected(g, name, other_name)) {
          g <- add_edges(g, c(name, other_name))
        }
      }
    }
  }
  g
}

#' Draw a network diagram.
#'
#' @param network The result obtained by running the build_author_network() function.
#' @param size_labels label size
#'
#' @return network diagram.
#' @export
#' @importFrom tidygraph as_tbl_graph centrality_closeness
#'
#' @examples
#' \donttest{
#' plot_coauthors(g)
#' }
plot_coauthors <- function(network, size_labels = 5) {
  graph <- tidygraph::as_tbl_graph(network) %>%
    mutate(closeness = suppressWarnings(tidygraph::centrality_closeness())) %>%
    filter(name != "")

  ggraph::ggraph(graph, layout = 'kk') +
    ggraph::geom_edge_link(ggplot2::aes_string(alpha = 1/2, color = as.character('from')), alpha = 1/3, show.legend = FALSE) +
    ggraph::geom_node_point(ggplot2::aes_string(size = 'closeness'), alpha = 1/2, show.legend = FALSE) +
    ggraph::geom_node_text(ggplot2::aes_string(label = 'name'), size = size_labels, repel = TRUE, check_overlap = TRUE) +
    ggplot2::labs(title = paste0("Network of coauthorship of ", network$author[1])) +
    ggraph::theme_graph(title_size = 16, base_family = "sans")
}
