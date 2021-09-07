source('source/utils/files.r')
source('source/utils/manifest-operations.r')
source('source/utils/dataframe.r')

source('source/visualizers/line.r')

visualize_corpus <- function(path, images_path) {
    library(stringr)
    library(hrbrthemes)
    library(reshape2)
    library(hashmap)

    # Generate image path

    folder_path <- get_parent_folder_path(path)
    image_path <- paste(images_path, "/", folder_path, ".jpeg", sep = "")
    create_folder_if_doesnt_exist(images_path)

    # Generate manifest path and read the data

    manifest <- read_manifest(path)
    corpus_data <- read_corpus_data(path, manifest)
    data <- corpus_data$data

    # Melt dataframe using it's index column as an anchor point, group values if required

    plot_kind <- get_property_value(manifest, 'kind', 'line')

    # Draw the plot and save it on the disk

    if (plot_kind=='line') {
        visualize_as_line(corpus_data, manifest)
        ggsave(image_path, height = 7 , width = 14)
    } else if(plot_kind=="histogram") {
        print("bar")
        library(ggplot2)

        min <- get_property_value(manifest, "min")
        max <- get_property_value(manifest, "max")
        bin_size <- get_property_value(manifest, "bin-size")

        melted <- melt_and_group_columns(corpus_data, manifest)
        plot <- ggplot(melted, aes(x = value, col = variable, fill = variable)) +
            (
                if(!is.null(min) && !is.null(max) && !is.null(bin_size))
                geom_histogram(aes(y = stat(count / sum(count))), breaks = seq(min, max, by = bin_size), position="dodge", show.legend=!manifest['disable-legend'][[1]])
                else if(!is.null(bin_size))
                geom_histogram(binwidth = bin_size, position="dodge", show.legend=!manifest['disable-legend'][[1]])
                else
                geom_histogram(position="dodge", show.legend=!manifest['disable-legend'][[1]])
            ) +
            # geom_density(alpha=.7, show.legend=FALSE) +
            xlab(manifest['labels'][[1]]['x-axis']) +
            ylab(manifest['labels'][[1]]['y-axis']) +
            ggtitle(
                # eval(parse(text="expression(atop(bold('ok'),atop('ok')))"))
                eval(parse(text=paste('expression(
                    atop(
                        bold(
                            ', manifest['labels'][[1]]['title'], '
                        ),
                        atop(
                            ', manifest['labels'][[1]]['subtitle'], '
                        )
                    )
                )', sep='')))
            ) + theme(
                # axis.text.x = element_text(angle=-45, hjust=0, vjust=1),
                plot.title = element_text(size = 14, colour = "black", vjust = -1, hjust=0.5)
            )
            # scale_colour_discrete("Continents")
             # +
            # guides(
            #         color = guide_legend(
            #             override.aes = list(fill = NA)
            #         ),
            #         linetype = guide_legend(
            #             override.aes = list(fill = NA)
            #         )
            #     ) +
            # theme(
            #     legend.key = element_rect(fill = "white")
            # ) +
            # guides(fill="none") + # delete entries from legend which correspond to the bars fill color
            # scale_fill_discrete(name="Experimental\nCondition")
        
        custom_legend_properties = get_property_value(manifest, 'legend')
        if (!is.null(custom_legend_properties)) {
            # plot + scale_fill_discrete(name = "New Legend Title", fill = FALSE)
            custom_legend_title = get_property_value(custom_legend_properties, 'title')
            if (!is.null(custom_legend_title)) {
                plot + guides(fill = guide_legend(title=custom_legend_title)) + guides(col = "none")
            }
        }

        ggsave(image_path, height = 7 , width = 14)
    } else if(plot_kind=="3d-histogram"){
        # print("baz")
        library(plotly)
        # print("qux")

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

        fig <- plot_ly(grid_bins, x = ~x_bin_labels, y = ~y_bin_labels, z = ~z, width = 5120, height = 3600, type="mesh3d")
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
        
        orca(fig, image_path, error=F)
        file.rename(from = str_replace(image_path, ".jpeg", '_1.jpeg'),  to = image_path) # fix names for files generated by plotly
    }

    return(image_path)
}
