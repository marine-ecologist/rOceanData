library(tidyverse)
library(janitor)
library(stringr)
library(ape)
library(phyloseq)


################  ################

### pre-med and post-med seqs

### Sample

# sample_name
# sample_uid


### Profiles - in the its2_type_profiles folder.
# ITS2.type.profile.UID - e.g. 259200
# Majority.ITS2.sequence - e.g C8/C8a
# ITS2.type.profile - e.g. C8/C8a-C1-C42.2-C42e-C8e-C42ae # THIS IS CORRECT - the incorrect comes from

# can also pull local abundance of ITS profiles against DB
# ITS2.profile.abundance.local
# ITS2.profile.abundance.DB

### Sequences
# each unique sequence within a profile has UID:
# seq_names - e.g. C1 (can be alphanumeric as well, e.g. 2355146_A, C35.3) # CHECK CORRECT NAME
# seq_accession - e.g 2


### Get Sequence ID
# solution drops rows 1:39 which is the metadata. Not ideal if metadata changes but complex otherwise due to data formatting
tmp.head <-   read.delim("/Users/rof011/20220919T102058_esampayo/post_med_seqs/224_20220926T061917_DBV_20220926T133809.seqs.relative.abund_and_meta.txt", header = F) %>% slice_head(n=1)
tmp.tail <- read.delim("/Users/rof011/20220919T102058_esampayo/post_med_seqs/224_20220926T061917_DBV_20220926T133809.seqs.relative.abund_and_meta.txt", header = T) %>% slice_tail(n=1)
names(tmp.head) <- tmp.head
names(tmp.tail) <- tmp.head

seq.UID <- rbind(tmp.head, tmp.tail) %>%
  t() %>%
  as.data.frame() %>%
  `rownames<-`( NULL ) %>%
  slice(40:nrow(.)) %>%
  rename(seq_names=1, seq_accession = 2)

### Get Sequence ID and match these to ITS2 profiles
its2_type_profiles <- read.delim("/Users/rof011/20220919T102058_esampayo/its2_type_profiles/224_20220926T061917_DBV_20220926T133809.profiles.relative.abund_and_meta.txt", header = F)
its2_type_profiles <- rbind(slice(its2_type_profiles, n=1), slice(its2_type_profiles, n=7), slice(its2_type_profiles, n=(n()-1))) %>%
  t() %>%
  as.data.frame() %>%
  `colnames<-`(slice(.,1)) %>% # get colnames
  slice(3:nrow(.)) %>%  # delete empty space
  rename(ITS2.type.profile.UID=1, ITS2.type.profile=2)

##############
# tree - rooted or unrooted?
# tree is a phylo of seq_accession numbers
#tree <- read.tree("/Users/rof011/20220919T102058_esampayo/between_profile_distances/C/clade_C_seqs.aligned.fasta.treefile")
#tree <- phyloseq::read_tree("/Users/rof011/20220919T102058_esampayo/between_profile_distances/C/clade_C_seqs.aligned.fasta.rooted.treefile")
#plot(tree)


### function: extract_postmed_seq_names (postmed seqs table)
extract_postmed_seq_names <- function(data = NULL) {
  read.delim(data, header = T, check.names = FALSE) %>%
    column_to_rownames("sample_uid") %>%
    dplyr::select(39:ncol(.)) %>%
    slice(1:(n() - 1)) %>%
    as.matrix() %>%
    t()
}

extract_postmed_seq_accession <- function(data = NULL) {
  read.delim(data, header = T, check.names = FALSE) %>%
    column_to_rownames("sample_uid") %>%
    dplyr::select(39:ncol(.)) %>%
    slice(1:(n() - 1)) %>%
    as.matrix() %>%
    t() %>%
    as.data.frame() %>%
    mutate(seq_names = rownames(.)) %>%
    left_join(., seq.UID, by = "seq_names") %>%
    column_to_rownames("seq_accession") %>%
    dplyr::select(-seq_names) %>%
    as.matrix()
}

postmed_sequences <- extract_postmed_seq_names("/Users/rof011/20220919T102058_esampayo/post_med_seqs/224_20220926T061917_DBV_20220926T133809.seqs.relative.abund_and_meta.txt")

### make alignemnt from fasta

#cd /Users/rof011/20220919T102058_esampayo/post_med_seqs/
#"/usr/local/bin/mafft"  --auto --clustalout --inputorder "224_20220926T061917_DBV_20220926T133809.seqs.fasta" > "224_20220926T061917_DBV_20220926T133809.seqs.MAFFS.fasta"
#/Users/rof011/downloads/iqtree -s 224_20220926T061917_DBV_20220926T133809.seqs.MAFFS.fasta -st DNA -t RANDOM -keep-ident -nt AUTO -redo -pre  224_20220926T061917_DBV_20220926T133809.iqtree

# replace read_tree for unifrac with the realigned tree
tree <- phyloseq::read_tree("/Users/rof011/20220919T102058_esampayo/post_med_seqs/224_20220926T061917_DBV_20220926T133809.iqtree.treefile")

tree$tip.label %in% rownames(postmed_sequences)

unifrac.weighted <- rbiom::unifrac(postmed_sequences, weighted = TRUE, tree)
unifrac.unweighted <- rbiom::unifrac(postmed_sequences, weighted = FALSE, tree)

unifrac.weighted.hclust <- (ape::as.phylo(hclust(dist(unifrac.weighted))))
unifrac.unweighted.hclust <- (ape::as.phylo(hclust(dist(unifrac.unweighted))))

profile_metadata <- read.delim("/Users/rof011/20220919T102058_esampayo/post_med_seqs/224_20220926T061917_DBV_20220926T133809.seqs.relative.abund_and_meta.txt", header = T, check.names = FALSE) %>% select(1:39)

#rows <- sample(nrow(profile_metadata))
#profile_metadata <- profile_metadata[rows, ]
#profile_metadata

ggtree(unifrac.unweighted.hclust, layout='rectangular') %<+% profile_metadata +
  geom_tiplab(aes(label = sample_name, color=host_species), size=2) +
  geom_tree(size=0.2)

ggtree(unifrac.weighted.hclust, layout='rectangular') %<+% profile_metadata +
  geom_tiplab(aes(label = sample_name, color=host_species), size=2) +
  geom_tree(size=0.2)


##
source("/Users/rof011/symportalfunctions.R")

SymVar_distance <- read.delim("/Users/rof011/20220919T102058_esampayo/between_sample_distances/C/20220926T133809_unifrac_sample_distances_C_no_sqrt.dist", header=FALSE) %>% select(-2)
SymVar_profiles <- read.delim("/Users/rof011/20220919T102058_esampayo/its2_type_profiles/224_20220926T061917_DBV_20220926T133809.profiles.relative.abund_and_meta.txt", check.names = FALSE, header = F)



symcluster(distance=unifrac.weighted, profile=SymVar_profiles, tiplabels="ITS2.profile.1", tipcols="avg.depth")







####### see below for splitting its2_type_profiles into seq_names

#str_replace_all(its2_type_profiles$ITS2.type.profile, setNames(seq.UID$seq_accession, seq.UID$seq_names))

# #### keep for error checking
# # split to individual sequences
# # - generates warning (Missing pieces filled with 'na') - ok to ignore
# ITS2.profiles_split <- its2_type_profiles %>%
#   select(2) %>% # select ITS2.type.profile
#   mutate(ITS2.type.profile = str_replace_all(ITS2.type.profile, "/", "-")) %>% # replace / with
#   separate(ITS2.type.profile, paste0("ITS2.profile.", 1:50), sep = "-|\\|/") %>%
#   select(where(function(x) any(!is.na(x)))) %>% # replace blanks with NA
#   pivot_longer(everything(), names_to="profilename", values_to="seq_names") %>%
#   na.omit()
#
# View(tmp <- left_join(ITS2.profiles_split, seq.UID, by="seq_names"))
# ####

# split to individual sequences
# - generates warning (Missing pieces filled with 'na') - ok to ignore
ITS2.profiles_split <- its2_type_profiles %>%
  select(2) %>% # select ITS2.type.profile
  mutate(ITS2.type.profile = str_replace_all(ITS2.type.profile, "/", "-")) %>% # replace / with
  separate(ITS2.type.profile, paste0("seq_accs.", 1:50), sep = "-|\\|/") %>%
  select(where(function(x) any(!is.na(x))))  # replace blanks with NA

#ITS2.profiles_split_seq_names
ITS2.profiles_split_seq.UID <- ITS2.profiles_split %>%
  mutate(across(everything(), ~ with(seq.UID, seq_accession[match(.x, seq_names)])))

# compare with Ben's
ITS2.profiles_split_ben <- its2_type_profiles %>%
  select(3) %>% # select ITS2.type.profile
  mutate(`Sequence accession / SymPortal UID` = str_replace_all(`Sequence accession / SymPortal UID`, "/", "-")) %>% # replace / with
  separate(`Sequence accession / SymPortal UID`, paste0("ITS2.profile.", 1:50), sep = "-|\\|/") %>%
  select(where(function(x) any(!is.na(x))))  # replace blanks with NA

####


# Decompose the ITS2.type.profile into seq_accessions instead of seq_names



ITS2.profiles_split$value %in% seq.UID$seq_names

####### Junk below


# split to uid
SymPortal.UID_split <-
  its2_type_profiles %>%
  select(8) %>%
  mutate(Sequence.accession...SymPortal.UID = str_replace_all(Sequence.accession...SymPortal.UID, "/", "-")) %>%
  separate(Sequence.accession...SymPortal.UID, paste0("SymPortal.UID", 1:50), sep = "-") %>%
  select(where(function(x) any(!is.na(x)))) %>%
  pivot_longer(everything())
SymPortal.UID_split
ITS2.profiles_split
# join and find distinct
matches <- cbind(ITS2.profiles_split[, 2], SymPortal.UID_split[, 2]) %>%
  na.omit() %>%
  rename(its2_type_profile = 1, uid = 2) %>%
  distinct()
matches
# split to its2
ITS2.profiles_split <- its2_type_profiles %>%
  select(7) %>%
  mutate(ITS2.type.profile = str_replace_all(ITS2.type.profile, "/", "-")) %>%
  separate(ITS2.type.profile, paste0("ITS2.profile.", 1:50), sep = "-") %>%
  select(where(function(x) any(!is.na(x)))) %>%
  pivot_longer(everything())
# split to uid
SymPortal.UID_split <-
  its2_type_profiles %>%
  select(8) %>%
  mutate(Sequence.accession...SymPortal.UID = str_replace_all(Sequence.accession...SymPortal.UID, "/", "-")) %>%
  separate(Sequence.accession...SymPortal.UID, paste0("SymPortal.UID", 1:50), sep = "-") %>%
  select(where(function(x) any(!is.na(x)))) %>%
  pivot_longer(everything())
# join and find distinct
matches <- cbind(ITS2.profiles_split[, 2], SymPortal.UID_split[, 2]) %>%
  na.omit() %>%
  rename(its2_type_profile = 1, uid = 2) %>%
  distinct()
matches
# split to its2
ITS2.profiles_split <- its2_type_profiles %>%
  select(7) %>%
  mutate(ITS2.type.profile = str_replace_all(ITS2.type.profile, "/", "-")) %>%
  separate(ITS2.type.profile, paste0("ITS2.profile.", 1:50), sep = "-") %>%
  select(where(function(x) any(!is.na(x)))) %>%
  pivot_longer(everything())
ITS2.profiles_split
ITS2.profiles_split <- its2_type_profiles %>%
  select(7) %>%
  mutate(ITS2.type.profile = str_replace_all(ITS2.type.profile, "/", "-"))
# split to its2
ITS2.profiles_split <- its2_type_profiles %>%
  select(7) %>%
  mutate(ITS2.type.profile = str_replace_all(ITS2.type.profile, "/", "-")) %>%
  separate(ITS2.type.profile, paste0("ITS2.profile.", 1:50), sep = "-") %>%
  select(where(function(x) any(!is.na(x)))) %>%
  pivot_longer(everything())
its2_type_profiles <- read.delim("20220919T102058_esampayo/its2_type_profiles/224_20220926T061917_DBV_20220926T133809.profiles.meta_only.txt", header = T)
its2_type_profiles <- read.delim("20220919T102058_esampayo/its2_type_profiles/224_20220926T061917_DBV_20220926T133809.profiles.meta_only.txt", header = T)
# Get matching UID and its2_type_profile
its2_type_profiles <- read.delim("/Users/rof011/20220919T102058_esampayo/its2_type_profiles/224_20220926T061917_DBV_20220926T133809.profiles.meta_only.txt", header = T)
its2_type_profiles %>% select(7, 8)
tmp <- its2_type_profiles %>% select(7, 8)
tmp[16, ]
tmp[17, ]
tmp[1, ]



post_med_seqs.relative.abund_and_meta <- read.delim("/Users/rof011/20220919T102058_esampayo/post_med_seqs/224_20220926T061917_DBV_20220926T133809.seqs.relative.abund_and_meta.txt", header = F)

seqnames <- rbind(
post_med_seqs.relative.abund_and_meta %>% slice_head(n=1),
post_med_seqs.relative.abund_and_meta %>% slice_tail(n=1) ) %>% t() %>% as.data.frame() %>% filter(!V2=="") %>% row_to_names(row_number=1)
