#' Test sf
#'
#' @return An \code{sf} spatial features collection
#' @export
#' @examples
#' test ()
test <- function() {
    sf::st_sfc (sf::st_point(1:2))
}