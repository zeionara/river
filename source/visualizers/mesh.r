library(plotly)

visualize_as_mesh <- function(corpus) {
    # print("baz")
    # print("qux")
    data <- corpus$data
    manifest <- corpus$manifest

    print('Rendering 3d histogram')

    # print(x_axis_title)
    bins <- get_property_value(manifest, 'bins')

    x_bins <- get_property_value(bins, 'x')

    x_min <- get_property_value(x_bins, 'min')
    x_max <- get_property_value(x_bins, 'max')
    bin_size <- get_property_value(x_bins, 'bin-size')

    x_bin_left_bound <- seq(x_min, x_max - bin_size, by=bin_size)
    x_bin_right_bound <- seq(x_min + bin_size, x_max, by=bin_size)

    x_bin_bounds <- data.frame(x_bin_left_bound, x_bin_right_bound)

    # print(head(x_bin_bounds))
    # print(paste("total", nrow(x_bin_bounds), "bins"))

    y_bins <- get_property_value(bins, 'y')

    y_min <- get_property_value(y_bins, 'min')
    y_max <- get_property_value(y_bins, 'max')
    bin_size <- get_property_value(y_bins, 'bin-size')

    y_bin_left_bound <- seq(y_min, y_max - bin_size, by=bin_size)
    y_bin_right_bound <- seq(y_min + bin_size, y_max, by=bin_size)

    y_bin_bounds <- data.frame(y_bin_left_bound, y_bin_right_bound)

    # print(head(y_bin_bounds))
    # print(paste("total", nrow(y_bin_bounds), "bins"))

    grid_bins = merge(x_bin_bounds, y_bin_bounds)

    print(head(grid_bins))
    print(paste("total", nrow(grid_bins), "bins"))

    print(head(data))
    # dat <- data

    bin_counts = c()
    x_bin_labels = c()
    y_bin_labels = c()
    # summ = 0
    for (i in 1:nrow(grid_bins)) {
        x_bin_left_boundary <- grid_bins[i, "x_bin_left_bound"]
        x_bin_right_boundary  <- grid_bins[i, "x_bin_right_bound"]
        
        y_bin_left_boundary <- grid_bins[i, "y_bin_left_bound"]
        y_bin_right_boundary  <- grid_bins[i, "y_bin_right_bound"]

        # print(paste(x_bin_left_boundary, x_bin_right_boundary, y_bin_left_boundary, y_bin_right_boundary))
        # print()
        # print(nrow(data[data$x > x_bin_left_boundary, ]))
        # print(i)
        bin_counts[i] = nrow(data[which(data$x > x_bin_left_boundary & data$x <= x_bin_right_boundary & data$y > y_bin_left_boundary & data$y <= y_bin_right_boundary), ])
        x_bin_labels[i] = paste("(", x_bin_left_boundary, ";", x_bin_right_boundary, "]", sep="")
        y_bin_labels[i] = paste("(", y_bin_left_boundary, ";", y_bin_right_boundary, "]", sep="")
        # summ = summ + bin_counts[i]
    }

    # print(bin_counts)
    # print(sum(bin_counts))
    # print(summ)
    grid_bins$z <- bin_counts
    grid_bins$x_bin_labels <- x_bin_labels
    grid_bins$y_bin_labels <- y_bin_labels

    print(head(grid_bins))

    fig <- plot_ly(grid_bins, x = ~x_bin_labels, y = ~y_bin_labels, z = ~z, width = 1024, height = 720, type="mesh3d")
    # fig <- fig %>% add_markers()
    fig <- fig %>% layout(
        scene = list(
            xaxis = list(title = manifest['labels'][[1]]['x-axis'][[1]]),
            yaxis = list(title = manifest['labels'][[1]]['y-axis'][[1]]),
            zaxis = list(title = manifest['labels'][[1]]['z-axis'][[1]])
        )
        # title = list(
        #     text=manifest['labels'][[1]]['title'][[1]]
        # )
        # autosize = F, 
    )

    return(fig)
}
