


# simulate 5 different reef types:

# good coral cover
# Bare - high sediment
# Bare - high juveniles
# Bare - low juveniles
# macroalgae

# df:
# coral cover
# macroalgal cover
# rubble cover
# Juvenile coral cover
# Sediment flux (turfs?)


df <- data.frame(
coral=c(6.5,18.8,14.6,16.5,21.2,19.1,21.2),
algae=c(49.5,21.8,33,26,42,38.5,32.5),
recruit=c(5,7,6,14,30,69,50),
sediment=c(46,20,22.5,2.5,10,21,44),
  rubble=c(0,0,0,0,0,0,0))
rownames(df) <- c("A1","B1","B2","B3","C1","C2","C3")

pcoa1 <- ape::pcoa( vegan::vegdist(df, "bray"), correction="lingoes", rn=NULL)
pcoa1.df <- pcoa1$vectors[,1:2] %>% as.data.frame() %>% cbind(.,df) %>% cbind(., rownames(df)) #%>% rename(site=7)
df.st = apply(df, 2, scale, center=TRUE, scale=TRUE)
ape::biplot.pcoa(pcoa1, df.st)


df.loadings <- df.st %>% t() %>% as.data.frame() %>% dplyr::select(1:2) %>%  rownames_to_column("site")
df.loadings <- df.st %>% t() %>% as.data.frame() %>% dplyr::select(1:2) %>%  rownames_to_column("site")


ggplot() + theme_bw() +
  geom_point(data=pcoa1.df, aes(x=Axis.1, y=Axis.2, size=exp(coral)), show.legend=FALSE)

ggplot() + theme_bw() +
  geom_label(data=df.loadings, aes(x=V1, y=V2, label=site), show.legend=FALSE) +
   geom_segment(data = df.loadings,
               aes(x = 0, y = 0,
                   xend = V1,
                   yend = V2),
               arrow = arrow(length = unit(1/2, 'picas')))



  ###

df2 <- data.frame(
coral=c(4,8),
algae=c(15,10),
recruit=c(2,2),
sediment=c(5,10),
  rubble=c(60,40))
rownames(df2) <- c("D1","D2")

  df <- bind_rows(df,df2)

#gower.df <- FD::gowdis(df, ord = c("podani"))
#pcoa1 <- ape::pcoa(gower.df, correction="cailliez", rn=NULL)
#biplot(pcoa1)

bray.df <- vegan::vegdist(df, "bray")
pcoa1 <- ape::pcoa(bray.df, correction="cailliez", rn=NULL)
pcoa1.df <- pcoa1$vectors[,1:2] %>% as.data.frame() %>% cbind(.,df) %>% cbind(., rownames(df)) #%>% rename(site=7)
df.st = apply(df, 2, scale, center=TRUE, scale=TRUE)
biplot(pcoa1, df.st)





df.loadings <- df.st %>% t() %>% as.data.frame() %>% dplyr::select(1:2) %>%  rownames_to_column("site")

ggplot() + theme_bw() +
  geom_point(data=pcoa1.df, aes(x=Axis.1, y=Axis.2, size=exp(coral)), show.legend=FALSE) +
  geom_segment(data = df.loadings,
               aes(x = 0, y = 0,
                   xend = V1*0.15,
                   yend = V2*0.15),
               arrow = arrow(length = unit(1/2, 'picas')))
