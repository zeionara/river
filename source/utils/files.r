create_folder_if_doesnt_exist <- function(path) {
    dir.create(file.path(getwd(), path), showWarnings = FALSE, recursive = TRUE)
}

get_last_path_element <- function(path) {
    return(tail(str_split(path, "/")[[1]], n=1))
}

find_manifest <- function(path) {
    return(paste(path, list.files(path, pattern = ".+\\.yml")[1], sep = "/"))
}