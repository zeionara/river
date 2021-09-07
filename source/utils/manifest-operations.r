library(yaml)

source('source/utils/files.r')

group_names_separator <- "::"

get_property_value <- function(container, property_name, default = NULL) {
    value <- container[property_name][[1]]
    if (is.null(value) || is.na(value)) {
        return(default)
    }
    return(value)
}

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

read_manifest <- function(path) {
    manifest_path <- find_manifest(path)
    manifest <- yaml.load_file(manifest_path)
}
