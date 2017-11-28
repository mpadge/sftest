context ("sf-construction")

make_sfc <- function (x, type) {
    if (!is.list (x)) x <- list (x)
    type <- toupper (type)
    stopifnot (type %in% c ("POINT", "LINESTRING", "POLYGON",
                            "MULTILINESTRING", "MULTIPOLYGON"))
    if (is.list (x [[1]]))
        xy <- do.call (rbind, do.call ("c", x))
    else
        xy <- do.call (rbind, x)
    xvals <- xy [, 1]
    yvals <- xy [, 2]
    bb <- structure(rep(NA_real_, 4), names = c("xmin", "ymin", "xmax", "ymax"))
    bb [1:4] <- c (min (xvals), min (yvals), max (xvals), max (yvals))
    class (bb) <- "bbox"
    if (type == "POLYGON")
        x <- lapply (x, function (i) list (i))
    else if (grepl ("MULTI", type) & !is.list (x [[1]]))
        x <- list (x)
    if (type != "MULTIPOLYGON")
        x <- lapply (x, function (i)
                     structure (i, class = c ("XY", type, "sfg")))
    else
        x <- lapply (x, function (i)
                     structure (list (i), class = c ("XY", type, "sfg")))
    attr (x, "n_empty") <- sum(vapply(x, function(x)
                                      length(x) == 0,
                                      FUN.VALUE = logical (1)))
    attr(x, "precision") <- 0.0
    class(x) <- c(paste0("sfc_", class(x[[1L]])[2L]), "sfc")
    attr(x, "bbox") <- bb
    NA_crs_ <- structure(list(epsg = NA_integer_,
                              proj4string = NA_character_), class = "crs")
    attr(x, "crs") <- NA_crs_
    x
}

make_sf <- function (...)
{
    x <- list (...)
    sf <- vapply(x, function(i) inherits(i, "sfc"),
                 FUN.VALUE = logical (1))
    sf_column <- which (sf)
    if (!is.null (names (x [[sf_column]])))
        row.names <- names (x [[sf_column]])
    else
        row.names <- seq_along (x [[sf_column]])
    df <- if (length(x) == 1) # ONLY sfc
                data.frame(row.names = row.names)
            else # create a data.frame from list:
                    data.frame(x[-sf_column], row.names = row.names,
                           stringsAsFactors = TRUE)

    object <- as.list(substitute(list(...)))[-1L]
    arg_nm <- sapply(object, function(x) deparse(x)) #nolint
    sfc_name <- make.names(arg_nm[sf_column])
    #sfc_name <- "geometry"
    df [[sfc_name]] <- x [[sf_column]]
    attr(df, "sf_column") <- sfc_name
    f <- factor(rep(NA_character_, length.out = ncol(df) - 1),
               levels = c ("constant", "aggregate", "identity"))
    names(f) <- names(df)[-ncol (df)]
    attr(df, "agr") <- f
    class(df) <- c("sf", class(df))
    return (df)
}

test_that ("sfg-point", {
               x <- structure (1:2, class = c("XY", "POINT", "sfg"))
               expect_identical (x, sf::st_point (1:2))
})
