#!/usr/bin/Rscript
# a <- 2

# print(a)

# library(tidyverse)
# library(ggplot2)
# library(hrbrthemes)

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

image_path <- visualize_corpus_using_line_plot(args[1], args[2])

print(paste("The image was saved as '", image_path, "'", sep=''))

# data <- read.table(file = 'corpora/x-expectation-value-c-based-plot.tsv', sep = '\t', header = TRUE)

# # ggplot(data = data) + geom_point(mapping = aes(x = foo, y = bar))

# ggplot(data, aes(x = c), ) +
# #   geom_smooth(aes(y = bar), color="#69b3a2", size=1, alpha=0.9, linetype=1) +
#   geom_smooth(aes(y = x), color="#e52165", size=1, alpha=0.9, linetype=1) +
#   xlab("wavefunction weight parameter (c)") +
#   ylab("location expectation value") +
# #   ggtitle("Electron position in the one-dimensional potential well (width = 5.0) expectation value depending on the value of base wavefunction weight") +
#   ggtitle(
#       expression(
#           atop(
#               bold(
#                   "Electron position in the one-dimensional potential well (width = 5.0) expectation value depending on the value of base wavefunction weights"
#              ),
#           atop(
#               "Ψtotal = sqrt(c) * Ψ(x, 1) + sqrt((1 - c) * 0.5) * Ψ(x, 2) + sqrt((1 - c) * 0.5) * Ψ(x, 3)", ""
#             )
#           )
#         )
#       ) +
#   theme(
#       # axis.text.x = element_text(angle=-45, hjust=0, vjust=1),
#       plot.title = element_text(size = 14, colour = "black", vjust = -1)
#     )

# create_folder_if_doesnt_exist("images")

# ggsave("images/x-expectation-value-c-based-plot.jpeg", height = 7 , width = 14)
