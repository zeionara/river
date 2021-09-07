source('source/utils/manifest-operations.r')

is_there_column <- function(data, column_name){
    return(any(names(data) == column_name))
}

group_columns <- function(data, manifest){
    column_groups = get_property_value_as_reversed_string_map(manifest, 'column-groups')
    if(is.null(column_groups)){
        return(data)
    }
    input_data <- data
    
    for(column_name in column_groups$keys()){
        data_without_target_rows <- subset(data, data$variable != column_name)
        for(group_name in str_split(column_groups[[column_name]], group_names_separator)[[1]]){
            target_rows <- data[data$variable == column_name,]
            target_rows$variable <- group_name
            data_without_target_rows <- rbind(data_without_target_rows, target_rows)
        }
        data <- data_without_target_rows
    }

    return(data)
}

read_corpus_data <- function(path, manifest) {
    # Generate data path and read the corpus contents

    data_path <- paste(path, get_property_value(manifest, 'data', 'data.tsv'), sep = "/")
    data <- read.table(file = data_path, sep = '\t', header = TRUE, check.names = FALSE)
    
    # Make sure that there is an index column in the corpus data

    index_column_name <- get_property_value(manifest, 'index-column', 'id')
    if (!is_there_column(data, index_column_name)) {
        print("Oops, no index column in the dataset! Initializing it with default values which reflect the index of row")
        data[index_column_name] <- 1:nrow(data)
    }

    return(list(data = data, index_column_name = index_column_name))
}

melt_and_group_columns <- function(corpus) {
    melted <- melt(corpus$data, id=corpus$index_column_name)
    names(melted)[1] <- 'id'
    melted <- group_columns(melted, corpus$manifest)
    return(melted)
}
