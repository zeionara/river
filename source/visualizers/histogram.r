library(ggplot2)

visualize_as_histogram <- function(corpus) {
    melted <- melt_and_group_columns(corpus)
    manifest <- corpus$manifest

    min <- get_property_value(manifest, "min")
    max <- get_property_value(manifest, "max")
    bin_size <- get_property_value(manifest, "bin-size")

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

    return(plot)
}
