#!/usr/bin/Rscript

source('source/utils.r')

args <- commandArgs(trailingOnly=TRUE)

default_images_path <- "images"

if (length(args) < 1 || length(args) > 2) {
  stop(
    paste(
      "Two arguments are required - path to the folder with corpus and path to the directory ",
      "containing images (the second argument is optional, by default value '", default_images_path, "' will be used)",
      sep=''
    ),
    call.=FALSE
  )
} else if (length(args)==1) {
  args[2] <- default_images_path
}

image_path <- visualize_corpus(args[1], args[2])

print(paste("The image was saved as '", image_path, "'", sep=''))
