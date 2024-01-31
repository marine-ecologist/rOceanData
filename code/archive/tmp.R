




#### sym_cluster()
# function to plot by similarity matrix
symcluster <- function(distance, profile, figurename = NULL, metadata = NULL,
                       tiplabels = "sample.ID", tipcols = NULL, prune=NULL,
                       height = 30, width = 30, layout = "circular", method = "average") {

  # make tree
  dist.names <- distance[, 1]
  dist.object <- distance[, -1]
  colnames(dist.object) <- dist.names
  rownames(dist.object) <- dist.names

  if (is.null(prune) == TRUE) {
  dist.object <- dist.object %>% as.dist()
  } else if (is.null(tipcols) == FALSE) {
  dist.object <-  dist.object[!(row.names(dist.object) %in% prune),] # drop rows
  dist.object <- dist.object %>% select(-all_of(prune)) # drop columns

  dist.object <-  dist.object %>% as.dist()
  }


  dendrogram.all <- as.phylo(hclust(dist.object, method = method))

  cat(print(dendrogram.all))
  (cat("------------------------\n"))

  # filtered metadata by tip.labels - missing some metadata
  filtered_metadata <- filter_metadata(SymVar_metadata, SymVar_profiles) %>%
    mutate_if(is.logical, as.character)  %>%
    mutate_if(is.character, ~ replace_na(., ""))

  SymVar_its2 <-   get_its2_profile(SymVar_profiles) %>%  mutate_if(is.character, ~ replace_na(., ""))

  profile_metadata <- left_join(SymVar_its2, SymVar_metadata, by="sample.ID")  %>%
    #mutate(node=seq(1:nrow(.))) %>%
    mutate_if(is.character, ~ replace_na(., "")) %>% # note that numeric variables are still NA
    mutate_if(is.character, as.factor) %>% # note that numeric variables are still NA
    mutate(group="")

# working
# ggtree(dendrogram.all, layout='circular') %<+% profile_metadata + geom_tiplab() +
#    geom_tippoint(aes(color = ITS2.profile.1))

ggtree(dendrogram.all, layout='circular') %<+% profile_metadata +
  geom_tiplab(aes(color= (ITS2.profile.1)),show.legend=FALSE) +
    geom_tippoint(aes(color = ITS2.profile.1, shape=host.species,  size=3), show.legend=FALSE)


  #profile_metadata <- SymVar_its2

  (cat("------------------------\n"))
  #prune
  #SymVar_metadata[!SymVar_metadata$sample.ID %in% prune,]


  if (is.null(tipcols) == TRUE) {
  p <- ggtree(dendrogram.all, layout='circular') %<+% profile_metadata + geom_tiplab(aes(label = sample.ID)) + geom_tree(size=2)
} else {
    p <- ggtree(dendrogram.all, layout='circular') %<+% profile_metadata + geom_tiplab(aes(label = get(tiplabels), color= get(tipcols))) + geom_tree(aes(color=trait), continuous = 'colour', size=2)
}

  if (is.null(figurename) == TRUE) {
    p
  } else {
     ggsave(plot = p, filename = figurename, width = width, height = height, units = "cm")
    p
}
}


#
# #symplot
#
#
# #library(plotly)
# #library(Polychrome)
# #library(RColorBrewer)
#
# #pallete <- sample(c(brewer.pal(12,"Set3"),brewer.pal(8,"Set2"),brewer.pal(9,"Set1"),brewer.pal(9,"Greens"),brewer.pal(11,"Spectral"),brewer.pal(11,"RdYlGn"),brewer.pal(11,"RdYlBu"),brewer.pal(11,"RdGy"),brewer.pal(11,"RdBu"),brewer.pal(11,"PuOr"),brewer.pal(11,"PRGn"),brewer.pal(11,"PiYG"),brewer.pal(11,"BrBG")))
#
#
# file <- SymVar_profiles %>%
#   slice(7:nrow(.)) %>%
#   select(-1) %>%
#   slice(1:(n() - 2)) %>%
#   #t() %>%
#   row_to_names(1) %>%
#   as.data.frame() %>%
#   clean_names()
#
# file2 <- pivot_longer(file, cols=-x, names_to="symbiont") %>%
#   rename(sample = 1, symbiont = 2, proportion = 3) %>%
#   mutate(proportion = as.numeric(proportion)) %>%
#   arrange(sample,symbiont)
#
#
# file2 %>% plot_ly(x = ~sample, y = ~proportion, type = 'bar',
#                 name = ~symbiont, color = ~symbiont, colors=pallete) %>%
#       layout(yaxis = list(title = 'Proportion'), barmode = 'stack')
