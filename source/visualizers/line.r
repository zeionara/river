library(ggplot2)

visualize_as_line <- function(corpus_data, manifest) {
    melted <- melt_and_group_columns(corpus_data, manifest)
    plot <- ggplot(melted, aes(x = id, y = value, col = variable)) +
    # ggplot(data, aes(x = c)) +
        (
            if(manifest['smooth'][[1]])
            geom_smooth(size=1, alpha=0.4, linetype=1, show.legend=!manifest['disable-legend'][[1]], level=0.98)
            else
            geom_line(size=1, alpha=0.9, linetype=1, show.legend=!manifest['disable-legend'][[1]])
        ) +
        # geom_line(size=1, alpha=0.9, linetype=1, show.legend=!manifest['disable-legend'][[1]]) +
        # geom_smooth(size=1, alpha=0.9, linetype=1, show.legend=!manifest['disable-legend'][[1]], method="loess", level=0.5) +
        # geom_smooth(aes(y = x), color="#e52165", size=1, alpha=0.9, linetype=1) +
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
                    ', manifest['labels'][[1]]['subtitle'], ', ""
                    )
                )
            )', sep='')))
        ) + theme(
            # axis.text.x = element_text(angle=-45, hjust=0, vjust=1),
            plot.title = element_text(size = 14, colour = "black", vjust = -1, hjust=0.5)
        ) +
        guides(color = guide_legend(override.aes = list(fill = NA)),
        linetype = guide_legend(override.aes = list(fill = NA))) +
        theme(legend.key = element_rect(fill = "white"))

    if (get_property_value(manifest, 'show-points', FALSE)) {
        plot + geom_point()
    }

    return(plot)
}
