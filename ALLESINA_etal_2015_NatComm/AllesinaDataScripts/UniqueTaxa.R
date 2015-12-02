a <- read.csv("bodysizes_2008_removed_cols.csv", sep = "\t", stringsAsFactors= FALSE)

# Find unique taxa
unique_taxa <- sort(unique(c(a$Taxonomy_consumer, a$Taxonomy_resource)))
# 796 taxa

write.table(unique_taxa, "UniqueTaxa.txt", row.names = FALSE, col.names = FALSE, quote = FALSE)

