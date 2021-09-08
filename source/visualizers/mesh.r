library(plotly, warn.conflicts = FALSE)

make_bin_bounds <- function(bins, axis_name) {
    bin_bounds <- get_bin_bounds(
        get_property_value(bins, axis_name)
    )

    names(bin_bounds)[1:2] <- c(
        paste(axis_name, "bin_left_bound", sep="_"),
        paste(axis_name, "bin_right_bound", sep="_")
    )

    return(bin_bounds)
}

visualize_as_mesh <- function(corpus) {
    data <- corpus$data
    manifest <- corpus$manifest

    bins <- get_property_value(manifest, 'bins')
    grid_bins = merge(make_bin_bounds(bins, 'x'), make_bin_bounds(bins, 'y'))

    bin_counts = c()
    x_bin_labels = c()
    y_bin_labels = c()

    for (i in 1:nrow(grid_bins)) {
        x_bin_left_boundary <- grid_bins[i, "x_bin_left_bound"]
        x_bin_right_boundary  <- grid_bins[i, "x_bin_right_bound"]
        
        y_bin_left_boundary <- grid_bins[i, "y_bin_left_bound"]
        y_bin_right_boundary  <- grid_bins[i, "y_bin_right_bound"]

        bin_counts[i] = nrow(
            data[
                which(
                    data$x > x_bin_left_boundary &
                    data$x <= x_bin_right_boundary &
                    data$y > y_bin_left_boundary &
                    data$y <= y_bin_right_boundary
                ), 
            ]
        )
        
        x_bin_labels[i] = paste("(", x_bin_left_boundary, ";", x_bin_right_boundary, "]", sep="")
        y_bin_labels[i] = paste("(", y_bin_left_boundary, ";", y_bin_right_boundary, "]", sep="")
    }

    grid_bins$z <- bin_counts
    grid_bins$x_bin_labels <- x_bin_labels
    grid_bins$y_bin_labels <- y_bin_labels

    grid_bins %>% plot_ly(x = ~x_bin_labels, y = ~y_bin_labels, z = ~z, width = 1024, height = 720, type="mesh3d") %>% layout(
        scene = list(
            xaxis = list(title = manifest['labels'][[1]]['x-axis'][[1]]),
            yaxis = list(title = manifest['labels'][[1]]['y-axis'][[1]]),
            zaxis = list(title = manifest['labels'][[1]]['z-axis'][[1]])
        ) 
    ) %>% return
}
