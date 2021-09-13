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

sample_auxiliary_row <- function(x_bound, y_bound, z) {
    return(
        list(
            x_bin_left_bound=0.0, # Left boundaries are not used on the rendering step - they are used only for storing area boundaries in the main coprus fragment
            x_bin_right_bound=x_bound,
            y_bin_left_bound=0.0,
            y_bin_right_bound=y_bound,
            z=z
        )
    )
}

visualize_as_3d_histogram <- function(corpus, epsilon = 1e-14) {
    data <- corpus$data
    manifest <- corpus$manifest

    bins <- get_property_value(manifest, 'bins')
    grid_bins = merge(make_bin_bounds(bins, 'x'), make_bin_bounds(bins, 'y'))

    bin_counts = c()

    additional_points <- data.frame(
        x_bin_left_bound=double(),
        x_bin_right_bound=double(),
        y_bin_left_bound=double(),
        y_bin_right_bound=double(),
        z=integer()   
    )

    for (i in 1:nrow(grid_bins)) {
        x_bin_left_boundary <- grid_bins[i, "x_bin_left_bound"]
        x_bin_right_boundary  <- grid_bins[i, "x_bin_right_bound"]
        
        y_bin_left_boundary <- grid_bins[i, "y_bin_left_bound"]
        y_bin_right_boundary  <- grid_bins[i, "y_bin_right_bound"]

        counts = nrow(
            data[
                which(
                    data$x > x_bin_left_boundary &
                    data$x <= x_bin_right_boundary &
                    data$y > y_bin_left_boundary &
                    data$y <= y_bin_right_boundary
                ), 
            ]
        )
        
        additional_points = rbind(
            additional_points,
            sample_auxiliary_row(x_bin_left_boundary + epsilon, y_bin_left_boundary + epsilon, counts),
            sample_auxiliary_row(x_bin_left_boundary + epsilon, y_bin_right_boundary, counts),
            sample_auxiliary_row(x_bin_right_boundary, y_bin_left_boundary + epsilon, counts)
        )

        bin_counts[i] <- counts
    }

    grid_bins$z <- bin_counts
    grid_bins <- rbind(grid_bins, additional_points)

    color <- as.vector(col2rgb(get_property_value(manifest, 'color', "#e75874")))

    grid_bins %>% plot_ly(x = ~x_bin_right_bound, y = ~y_bin_right_bound, z = ~z, width = 1920, height = 1080, type="mesh3d",
         intensity=grid_bins$z, colorscale='Viridis'
    ) %>% layout(
        scene = list(
            xaxis = list(title = manifest['labels'][[1]]['x-axis'][[1]]),
            yaxis = list(title = manifest['labels'][[1]]['y-axis'][[1]]),
            zaxis = list(title = manifest['labels'][[1]]['z-axis'][[1]])
        ) 
    ) %>% return
}
