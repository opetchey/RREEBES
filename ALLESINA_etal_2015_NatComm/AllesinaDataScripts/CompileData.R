library(stringr)

Records <- read.csv("bodysizes_2008_removed_cols.csv", sep = "\t", stringsAsFactors= FALSE)
Taxonomy <- read.csv("UniqueTaxa.txt.taxon", sep = ",", stringsAsFactors= FALSE)

Geographic <- character(0)
Habitat <- character(0)
Mass_consumer <-  numeric(0)
Mass_resource <-  numeric(0)
Type_interaction <- character(0)
Metabolic_consumer <- character(0)
Metabolic_resource <- character(0)
K_consumer <- character(0)
K_resource <- character(0)
P_consumer <- character(0)
P_resource <- character(0)
C_consumer <- character(0)
C_resource <- character(0)
O_consumer <- character(0)
O_resource <- character(0)

NRecs <- dim(Records)[1]
for (i in 1:NRecs){
    R <- Records[i, ]
    ## If body mass is present
    if (R$Mass_consumer > 0.0){
        if (R$Mass_resource > 0.0){
            ## If taxonomy is present
            txr <- R$Taxonomy_resource
            txc <- R$Taxonomy_consumer

            txr <- str_trim(txr)
            txr <- gsub("\\.", " ", txr)
            txr <- gsub("\\,", " ", txr)
            txr <- gsub("\\t", " ", txr)
            
            txc <- str_trim(txc)
            txc <- gsub("\\.", " ", txc)
            txc <- gsub("\\,", " ", txc)
            txc <- gsub("\\t", " ", txc)
            
            TxR <- Taxonomy[Taxonomy$input == txr,]
            TxC <- Taxonomy[Taxonomy$input == txc,]
            if (TxR$tsn_kingdom > 0){
                if (TxC$tsn_kingdom > 0){
                    
                    Geographic <- c(Geographic, R$Geographic)
                    Habitat <- c(Habitat, R$Habitat)
                    Type_interaction <- c(Type_interaction, R$Type_interaction)
                    Metabolic_consumer <- c(Metabolic_consumer, R$Metabolic_consumer)
                    Metabolic_resource <- c(Metabolic_resource, R$Metabolic_resource)

                    K_consumer <- c(K_consumer, TxR$kingdom)
                    P_consumer <- c(P_consumer, TxR$phylum)
                    C_consumer <- c(C_consumer, TxR$class)
                    O_consumer <- c(O_consumer, TxR$order)

                    K_resource <- c(K_resource, TxC$kingdom)
                    P_resource <- c(P_resource, TxC$phylum)
                    C_resource <- c(C_resource, TxC$class)
                    O_resource <- c(O_resource, TxC$order)
                   
                    Mass_consumer <- c(Mass_consumer, R$Mass_consumer)
                    Mass_resource <- c(Mass_resource, R$Mass_resource)
                }
            }
        }
    }
}

FinalData <- data.frame(Geographic = Geographic,
                        Habitat = Habitat,
                        Type_interaction = Type_interaction,
                        Metabolic_consumer = Metabolic_consumer,
                        Metabolic_resource = Metabolic_resource,
                        K_consumer = K_consumer,
                        P_consumer = P_consumer,
                        C_consumer = C_consumer,
                        O_consumer = O_consumer,
                        K_resource = K_resource,
                        P_resource = P_resource,
                        C_resource = C_resource,
                        O_resource = O_resource,
                        Mass_consumer = Mass_consumer,
                        Mass_resource = Mass_resource)

write.csv(FinalData, "BodySizeInteractions.csv", row.names = FALSE)

                       
