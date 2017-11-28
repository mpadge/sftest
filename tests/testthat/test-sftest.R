context ('test')

test_that ('test fn', {
    dat <- test ()
    expect_is (dat, "sfc")
})

test_that ('test rcpp fn', {
    dat <- testrc ()
    expect_true (all (dat == 0))
    expect_length (dat, 10)
})

test_that ('sf GDAL osm driver', {
    f <- system.file ("extdata", "test-hw.osm", package = "sftest")
    dat <- sf::st_read (f, layer = "lines", quiet = TRUE)
    expect_is (dat, "sf")
    expect_equal (nrow (dat), 133)
})
