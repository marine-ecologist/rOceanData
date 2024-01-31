

#relevel cover

# Category Cover estimate
# 0 0%
# 1- >0-5%
# 1+ >5-10%
# 2- >10-20%
# 2+ >20-30%
# 3- >30-40%
# 3+ >40-50%
# 4- >50-62.5%
# 4+ >62.5-75%
# 5- >75-87.5
# % 5+ >87.5-100%



library(ordinal)

df <- manta_for_jez %>%  janitor::clean_names() %>%
#  mutate(coral_cover=as.factor(live_coral)) %>%
  mutate(reef_id = as.factor(reef_id))

df$coral_cover <- recode(df$live_coral, "0" = "0",
  "1L" = "5",
  "1" = "7.5",
  "1U" = "10",
  "2L" = "12.5",
  "2" = "15",
  "2U"  = "25",
  "3L" = "35",
  "3" = "40",
  "3U" = "45",
  "4L" = "56",
  "4" = "62.5",
  "4U" = "68",
  "5L" = "81.5",
  "5" = "87.5",
  "5U" = "93.5")

df$coral_cover <- as.numeric(df$coral_cover)

ggplot() + theme_bw() + geom_point(data=manta_for_jez %>% filter(REEF_NAME=="STARTLE (EAST)") , aes(REPORT_YEAR, LIVE_CORAL))  + facet_wrap(~LIVE_CORAL)


df2 <- df  %>%
  dplyr::group_by(a_sector, report_year) %>%
  dplyr::summarise(coral_cover = mean(coral_cover)) %>% # %>% #, LIVE_CORAL_SD=mean(LIVE_CORAL))
  na.omit()

ggplot() + theme_bw() + geom_line(data=df2, aes(report_year, coral_cover)) + facet_wrap(~a_sector)


df.clmm <- manta_for_jez %>%  janitor::clean_names() %>%
  mutate(live_coral = factor(live_coral, ordered = TRUE, levels = c("0","1L","1","1U","2L","2","2U","3L","3","3U","4L","4","4U","5L","5","5U"))) %>%
  mutate(reef_id = as.factor(reef_id)) %>%
  mutate(reef_id = as.factor(reef_id))

fm1 <- clmm(live_coral~report_year + (1|reef_id/a_sector), data = df.clmm)

library(brms)
brm.logit <- brm(live_coral ~ report_year + (1|reef_id/a_sector),
family = cumulative(link="logit", threshold = "equidistant"),
warmup = 1000, iter = 5000, chains = 4,
data=df.clmm)

