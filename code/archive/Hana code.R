#https://archetypalecology.wordpress.com/2018/02/21/distance-based-redundancy-analysis-db-rda-in-r/

library(tidyverse)
library(vegan)
library(FD)
library(ggbiplot)

# open data, select species and 7 traits
traits <- read.csv("/Users/rof011/traitbiogeography.csv", head = TRUE, stringsAsFactors = FALSE) %>% # read file
  select(species,
    cat_growthrate,
    cat_corallitesize,
    cat_colonydiameter,
    cat_skeletaldensity,
    cat_colonyheight,
    cat_SA_vol,
    cat_spacesize)

# subsample n=265 species from main species pool
set.seed(11) # set seed for consistent random subsample of taxa
traits <- traits %>% slice_sample(n=100)

# make rownames from species and drop species column
rownames(traits) <- traits$species
traits <- traits %>% select(-species)

# make traits simpler by dropping cat_ (e.g. cat_colonyheight to colonyheight)
names(traits) <- gsub(".*_","",names(traits))

# make traits ordinal and code them as 1:5 levels (instead of numeric)
traits$growthrate <- ordered(traits$growthrate, levels = 1:5)
traits$corallitesize <- ordered(traits$corallitesize, levels = 1:5)
traits$colonydiameter <- ordered(traits$colonydiameter, levels = 1:5)
traits$skeletaldensity <- ordered(traits$skeletaldensity, levels = 1:5)
traits$colonyheight <- ordered(traits$colonyheight, levels = 1:5)
traits$vol <- ordered(traits$vol, levels = 1:5)
traits$spacesize <- ordered(traits$spacesize, levels = 1:5)


# use fd::gowdis as the dissimilarity matrix (can account for mixed variables and uses Podani to handle ordinal variables
# usually use vegan::vegdist but doesn't handle ordinal data

gowertraits <- gowdis(traits, ord = c("podani"))


# use vegan::cascadeKM for K-means partitioning of clusters - increase iterations (iter=10000) for final analysis, slow to run with high iter
# can set the minimum and maximum number of groups here to avoid over clustering (see ?cascadeKM)
# here is set between 2 and 10 (inf.gr and sup.gr) - can also change criterion depending on clustering (see ?cclust for other options)
kmeans <- cascadeKM(gowertraits,iter = 100,inf.gr=2,sup.gr=10, criterion="ssi")
plot(kmeans,sortg=TRUE) # plot the K-means result to visualise

# choose SSI criterion based on the previous plot and write to a vector, here taking 8 clusters
kmeansclus <- kmeans$partition[,7]

kmeanscluster_overlay <- kmeansclus %>%
  as.data.frame() %>%
  rownames_to_column() %>%
  dplyr::rename(species=1, cluster=2) %>%
  mutate_all( as.factor)


# use hierchical cluster analysis to make a dendrogram of kmeans clustering
# used for the overlay of groups and clusters in the PCoA
gowertraitshclust<-hclust(gowertraits, method = "average")
hclusters <- as.data.frame(cutree(gowertraitshclust, 7)) # cut the tree according to the number of clusters in the kmeans (here 8)

# use ape::pcoa to compute Principal Coordinate Analysis (PCoA) with cailliez correction for negative eigenvalues
pcoa1 <- pcoa(gowertraits, correction="cailliez", rn=NULL)


# alternatively cmdscale will give a goodness of fit:
#pcoa1 <- cmdscale(gowertraits, eig = TRUE)
#pcoa1$GOF


# combine PCoA vector output with kmeanscluster groups
pcoa_plot <- pcoa1$vectors %>%
  as.data.frame() %>%
  select(Axis.1, Axis.2) %>%
  rownames_to_column() %>%
  dplyr::rename(species = rowname) %>%
  mutate(species=as.factor(species)) %>%
  left_join(.,kmeanscluster_overlay, by="species",copy = TRUE)

# plain ggplot output with clusters coloured
ggplot() + theme_light() +
  geom_point(data=pcoa_plot, aes(x = Axis.1, y = Axis.2, colour = cluster))

# add convex hulls to the groups and plot
pca_hull <-
  pcoa_plot %>%
  group_by(cluster) %>%
  slice(chull(Axis.1 , Axis.2))

ggplot() + theme_light() + scale_x_reverse() + scale_y_reverse() + # reverse axis to match PCA, not needed otherwise
  geom_point(data=pcoa_plot, aes(x = Axis.1, y = Axis.2, colour = cluster)) +
  geom_polygon(data = pca_hull, aes(x = Axis.1, y = Axis.2, fill = cluster, colour = cluster), alpha = 0.3, show.legend = FALSE)

ggsave("pcoa_plot_1.pdf",width = 30, height = 20, units = "cm")


#### switch to numeric and try PCA with euclidian to get loadings:

traitsnumeric <- traits

# make traits numeric again
traitsnumeric$growthrate <- as.numeric(traitsnumeric$growthrate)
traitsnumeric$corallitesize <- as.numeric(traitsnumeric$corallitesize)
traitsnumeric$colonydiameter <- as.numeric(traitsnumeric$colonydiameter)
traitsnumeric$skeletaldensity <- as.numeric(traitsnumeric$skeletaldensity)
traitsnumeric$colonyheight <- as.numeric(traitsnumeric$colonyheight)
traitsnumeric$vol <- as.numeric(traitsnumeric$vol)
traitsnumeric$spacesize <- as.numeric(traitsnumeric$spacesize)


library("FactoMineR")
library("factoextra")


# make PCA
res.pca <- prcomp(traitsnumeric, scale = TRUE)

fviz_pca_biplot(res.pca, repel = TRUE,
                col.var = "#2E9FDF", # Variables color
                col.ind = "#696969"  # Individuals color
                )

ggsave("pca_plot_1.pdf",width = 30, height = 20, units = "cm")

fviz_pca_biplot(res.pca,
             col.ind = as.factor(kmeansclus), # color by groups
             palette=c("#001f3f", "#0074D9","#39CCCC", "#3D9970","#FFDC00", "#85144b","#FF4136", "#FF851B","#2ECC40"),
             addEllipses = TRUE, # Concentration ellipses
             ellipse.type = "convex",
             legend.title = "Groups",
             repel = TRUE
             )

ggsave("pca_plot_2.pdf",width = 30, height = 20, units = "cm")


#####

# detour to visualise t-sne

library(Rtsne)

tsne_obj <- Rtsne(gowertraits, is_distance = TRUE)

tsne_data <- tsne_obj$Y %>%
  data.frame() %>%
  setNames(c("X", "Y")) %>%
  mutate(cluster = factor(kmeanscluster_overlay$cluster))

tsne_hull <-
  tsne_data %>%
  group_by(cluster) %>%
  slice(chull(X , Y))

ggplot(aes(x = X, y = Y), data = tsne_data) + theme_bw() +
  geom_point(aes(color = cluster)) +
  geom_polygon(data = tsne_hull, aes(x = X, y = Y, fill = cluster, colour = cluster), alpha = 0.3, show.legend = FALSE)



# #### junk below for later
#
# # as far as I know PCoA doesn't have loadings (directional arrows)
#
# traitsnumeric <- traits
#
# # make traits numeric again
# traitsnumeric$growthrate <- as.numeric(traitsnumeric$growthrate)
# traitsnumeric$corallitesize <- as.numeric(traitsnumeric$corallitesize)
# traitsnumeric$colonydiameter <- as.numeric(traitsnumeric$colonydiameter)
# traitsnumeric$skeletaldensity <- as.numeric(traitsnumeric$skeletaldensity)
# traitsnumeric$colonyheight <- as.numeric(traitsnumeric$colonyheight)
# traitsnumeric$vol <- as.numeric(traitsnumeric$vol)
# traitsnumeric$spacesize <- as.numeric(traitsnumeric$spacesize)
#
#
# plot(capscale(traitsnumeric ~ 1, distance="bray",  sqrt.dist = FALSE))
#
#
# # add vectors to show directionality of species
#
#
# pcoa_vectors <- pcoa1$values
#
# ggplot() + theme_light() +
#   geom_point(data=pcoa_plot, aes(x = Axis.1, y = Axis.2, colour = cluster)) +
#   geom_polygon(data = pca_hull, aes(x = Axis.1, y = Axis.2, fill = cluster, colour = cluster), alpha = 0.3, show.legend = FALSE)
#   geom_segment(data = pcoa_vectors, aes(x = 0, y = 0, xend = Axis.1*5, yend = Axis.2*5), arrow = arrow(length = unit(1/2, 'picas'))) +
#   annotate('text', x = (pcoa_vectors$Axis.1*6), y = (pca_load$Axis.1*5.2),
#            label = pca_load$variable,
#            size = 3.5)
#
#
# rownames(pcoa1$vectors)
# rownames(hclusters)
# #rownames(pcoa1$vectors) %in% rownames(hclusters)
#
# # visualise using ade4::s.class
# s.class(pcoa1$vectors[,c(1,2)],  fac = as.factor(hclusters$clus))
# #s.class(pcoa1$vectors[,c(1,2)],  ellipseSize = 2, paxes.draw = TRUE, fac = as.factor(clus2$clus))
#
# pcoa1$values[1][1,] # Eigenvalues
# pcoa1$values[1][1,]/sum(pcoa1$values[1])*100
# pcoa1$values[1][2,]/sum(pcoa1$values[1])*100
#
#
