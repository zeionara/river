create_folder_if_doesnt_exist <- function(path) {
    dir.create(file.path(getwd(), path), showWarnings = FALSE, recursive = TRUE)
}

get_property_value <- function(container, property_name, default = NULL) {
    value <- container[property_name][[1]]
    if (is.null(value)) {
        return(default)
    }
    return(value)
}

group_names_separator <- "::"

get_property_value_as_reversed_string_map <- function(container, property_name, default = NULL) {
    value <- get_property_value(container, property_name, default = default)
    if (is.null(value)) {
        return(NULL)
    }

    result <- hashmap(c("foo"), c("bar"))

    group_names <- names(value)
    for(i in seq_along(value)) {
        for(column_name in value[[i]]){
            if(!result$has_key(column_name)){
                result[[column_name]] <- group_names[[i]]
            } else {
                result[[column_name]] <- paste(result[[column_name]], group_names[[i]], sep=group_names_separator)
            }
        }
    }

    result$erase("foo")
    return(result)
}

group_columns <- function(data, manifest){
    column_groups = get_property_value_as_reversed_string_map(manifest, 'column-groups')
    if(is.null(column_groups)){
        return(data)
    }
    input_data <- data
    # print(column_groups)

    
    for(column_name in column_groups$keys()){
        data_without_target_rows <- subset(data, data$variable != column_name)
        for(group_name in str_split(column_groups[[column_name]], group_names_separator)[[1]]){
            # print(paste(column_name, '->', group_name))
            # eval(paste("data$", group_name, " <- ", "data$", column_name, sep=""))
            # print(paste("data$", group_name, " <- ", "data$", column_name, sep=""))
            # data[,group_name] <- data[,column_name]
            target_rows <- data[data$variable == column_name,]
            target_rows$variable <- group_name
            data_without_target_rows <- rbind(data_without_target_rows, target_rows)
        }
        data <- data_without_target_rows
    }
   
    # print(nrow(input_data))
    # print(nrow(data_without_target_rows))
    # print(nrow(data))

    return(data)
}

visualize_corpus_using_line_plot <- function(path, images_path) {
    library(yaml)
    library(stringr)
    library(ggplot2)
    library(hrbrthemes)
    library(reshape2)
    library(hashmap)

    # Generate image path

    folder_name <- tail(str_split(path, "/")[[1]], n=1)
    image_path <- paste(images_path, "/", folder_name, ".jpeg", sep = "")

    # Generate manifest path and read the data

    manifest_path <- paste(path, list.files(path, pattern = ".+\\.yml")[1], sep = "/")
    manifest <- yaml.load_file(manifest_path)
    
    # Generate data path and read the corpus contents

    data_path <- paste(path, manifest['data'], sep = "/")
    data <- read.table(file = data_path, sep = '\t', header = TRUE)
    # group_columns(data, manifest)
    
    # print(head(data))
    # print(manifest['index-column'][[1]])
    
    melted <- melt(data, id=manifest['index-column'][[1]])
    names(melted)[1] <- 'id'
    melted <- group_columns(melted, manifest)

    # print(head(melted))

    # Draw the plot and save it on the disk

    # header <- 
    # print(header)

    # print(is.null(manifest['show-points'][[1]]))

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
            plot.title = element_text(size = 14, colour = "black", vjust = -1, hjust=1)
        ) +
        guides(color = guide_legend(override.aes = list(fill = NA)),
        linetype = guide_legend(override.aes = list(fill = NA))) +
        theme(legend.key = element_rect(fill = "white"))

    if (get_property_value(manifest, 'show-points', FALSE)) {
        plot + geom_point()
    }

    create_folder_if_doesnt_exist(images_path)
    ggsave(image_path, height = 7 , width = 14)

    return(image_path)
}
