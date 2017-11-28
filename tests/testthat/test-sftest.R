context ('test')

test_that ('test fn', {
    dat <- test ()
    expect_is (dat, "sfc")
})

test_that ('sf GDAL osm driver', {
    f <- system.file ("extdata", "test-hw.osm", package = "sftest")
    dat <- sf::st_read (f, layer = "lines", quiet = TRUE)
    expect_is (dat, "sf")
    expect_equal (nrow (dat), 133)
})
