library(eurostat)
library(tidyverse)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Données européens sur la population et le PIB (et déflateurs)
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

path_prefix <- ""

# Données européennes: liste des dataframes complets pour la loop

loop_data_estat <- data.frame(
  collection = c("PPP", "GDP_HAB", "GDP", "POP", "POP_G", "EXP", "REC", "FORX"),
  data_id = c("prc_ppp_ind",
                  "nama_10_pc",
                  "nama_10_gdp",
                  "demo_pjanbroad",
                  "demo_pjan",
                  "spr_exp_sum",
                  "spr_rec_sumt",
                  "ert_bil_eur_a")) %>% 
  mutate(filename = paste0(collection, ".rds")) %>% 
  mutate(dest_rds = paste0(path_prefix, "input/data/varia/", collection, ".rds"))

# Charger les données de l'Europe, en ligne, et les transformer en rds pour augmenter la rapidité

# Loop

for(i in 1:nrow(loop_data_estat)){
  
  # Paramètres
  
  collection <- loop_data_estat[i, 1]  
  data_id <- loop_data_estat[i, 2]
  file_name <- loop_data_estat[i, 3]
  dest_rds <- loop_data_estat[i, 4]  
  
  # Si le RDS a été déjà produit le charger...
  
  if (paste0(collection, ".rds") %in% list.files(paste0(path_prefix, "input/data/varia/"))){
    
    assign(paste0("d_", collection), 
           read_rds(dest_rds), envir = .GlobalEnv)
    
    print("Fichier préalablement téléchargé d'Internet, sauvegardé en rds, pour des raisons de rapidité!")
    
  }else{
    
    # sinon, le télécharger
    
    df <- get_eurostat(data_id)
    write_rds(x = df, file = paste0(path_prefix, "input/data/varia/", file_name))
    
    # Lire les données
    
    assign(paste0("d_", collection), df, envir = .GlobalEnv)
  
  }
}

