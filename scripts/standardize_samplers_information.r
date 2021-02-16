# This script standardizes the outputs of the following samplers: 
# Spur, QuickSampler, Smarch, and Unigen2.
# For each model and sampler, a resulting csv file called
# model_name_satdist.sampler is generated in the 
# corresponding model_name/st_samples folder.
# These files store the empirical distribution of the SAT solutions 
# the sampler has generated
#
# Code written by Ruben Heradio

library(tidyverse)
library(gmp)

# Set the MODELS_PATH constant to the path where models are stored, 
# or introduce the path using the console command, i.e., running:
#
# Rscript standardize_samplers_information.r "models path"
args <- commandArgs(trailingOnly=TRUE)
if (length(args) == 0) {
  MODELS_PATH <- "../../data"
} else {
  MODELS_PATH <- args[1]
}

MODELS_EXTENSIONS <-
  c("kus", "bdd", "quicksampler", "smarch", "spur", "unigen2")

models <- dir(path = MODELS_PATH)

for (m in models) {
  
  writeLines(str_c("Processing ", m))
  
  for (ext in MODELS_EXTENSIONS) {
    
    writeLines(str_c("  Analyzing ", m, ".", ext))
    
    path <- str_c(MODELS_PATH,
                  "/",
                  m,
                  "/samples")
    m_filename <- list.files(
      path = path,
      pattern = str_c("[.]", ext, "$"),
      recursive = TRUE,
      include.dirs = TRUE
    )
    if (length(m_filename) != 1) {
      cat(str_c("  << WARNING: ", ext, " sample not found >>\n"))
      next()
    }
    path <- str_c(MODELS_PATH,
                  "/",
                  m,
                  "/samples/",
                  m_filename)
    
    # get sample data.frame
    
    if (ext %in% c("bdd", "quicksampler", "smarch", "unigen2")) {
      sep <- NA
      if (ext %in% c("bdd", "quicksampler", "unigen2")) {
        sep <- " "
      } else {
        # (ext == "smarch")
        sep <- ","
      }
      sample <- read.csv(
        path,
        header = FALSE,
        sep = sep,
        na = c("", "NA"),
        strip.white = FALSE
      )
    } else if (ext == "spur") { 
      sample_code <- read_file(path) 
      aux_sample <- unlist(str_extract_all(sample_code,
                                           regex("^\\d+,[01*]+", multiline=TRUE)))
      nrows <-
        str_extract_all(sample_code,
                        regex("^\\d+(?=,[01*]+)", multiline=TRUE))  %>%
        unlist() %>%
        as.numeric() %>%
        sum()
      ncols <- aux_sample[1] %>%
        str_extract_all("(?<=,)[01*]+") %>%
        nchar()
      
      sample <- matrix(rep(NA, nrows * ncols),
                       nrows,
                       ncols)
      
      i = 1
      for (s in aux_sample) {
        n <- str_extract(s,
                         "\\d+(?=,[01*]+)") %>%
          unlist() %>%
          as.numeric()
        for (j in 1:n) {
          aux_s <- s
          while (str_detect(aux_s, "[*]")) {
            aux_s <- str_replace(aux_s, "[*]",
                                 if_else(rbernoulli(1), "1", "0"))
          }
          row <-
            str_extract(aux_s, "(?<=,)[01]+") %>%
            str_replace_all("([01])", "\\1,") %>%
            str_split(",") %>%
            unlist()
          row <- row[-length(row)]
          sample[i, ] <- row
          i <- i + 1
        }
      } # for (s in aux_sample)
      sample <- as.data.frame(sample,
                              stringsAsFactors = FALSE)
    } else { #(ext == "kus") 
      sample_code <- read_file(path) 
      aux_sample <-
        str_extract_all(sample_code,
                        regex("(?<=,).*", multiline=TRUE)) %>%
        unlist %>%
        str_trim
      nrows <- length(aux_sample)
      ncols_aux <- aux_sample[1] %>%  str_split("\\s+") %>% unlist 
      ncols <- ncols_aux[!duplicated(ncols_aux)] %>% length
      sample <- matrix(rep(NA, nrows * ncols),
                       nrows,
                       ncols)
      for (i in 1:nrows) {
        r <- aux_sample[i] %>%  str_split(" ") %>% unlist 
        for (j in 1:length(r)) {
          lit <- as.numeric(r[j])
          sample[i,abs(lit)] <- ifelse(lit>0, 1, 0) 
        }
      }
      sample <- as.data.frame(sample)
    }
    
    # get satdist from the sample data.frame
    
    # ext == bdd ########################################
    
    if (ext %in% c("bdd", "kus")) {
      if (ext == "bdd") {
        sample <- sample[-ncol(sample)]
      }
      histogram_sample <- rep(NA, nrow(sample))
      for (i in 1:nrow(sample)) {
        if (i %% 500 == 0) {
          writeLines(str_c("    row ", i , " of ", nrow(sample)))
        }
        histogram_sample[i] <- sum(sample[i, ])
      }
    }
    
    # ext == quicksampler or unigen2 ########################################
    
    if (ext %in% c("quicksampler", "unigen2")) {
      sample[sample > 0] <- 1
      sample[sample < 0] <- 0
      
      histogram_sample <- rep(NA, nrow(sample))
      for (i in 1:nrow(sample)) {
        if (i %% 500 == 0) {
          writeLines(str_c("    row ", i , " of ", nrow(sample)))
        }
        histogram_sample[i] <- sum(sample[i,])
      }
    }
    
    # ext == smarch ########################################
    
    if (ext == "smarch") {
      # remove last column
      sample <- sample[-ncol(sample)]
      
      histogram_sample <- rep(NA, nrow(sample))
      sample[sample > 0] <- 1
      sample[sample < 0] <- 0
      for (i in 1:nrow(sample)) {
        if (i %% 500 == 0) {
          writeLines(str_c("    row ", i , " of ", nrow(sample)))
        }
        histogram_sample[i] <- sum(sample[i, ])
      }
    }
    
    # ext == spur ########################################
    
    if (ext == "spur") {
      histogram_sample <- rep(NA, nrow(sample))
      for (i in 1:nrow(sample)) {
        if (i %% 500 == 0) {
          writeLines(str_c("    row ", i , " of ", nrow(sample)))
        }
        histogram_sample[i] <- sample[i, ] %>%
          as.numeric %>%
          sum
      }
    }
    
    # Write resulting files ########################################
    
    histogram_sample <- tibble(true_assignments = histogram_sample)
    file_name <- str_c(MODELS_PATH,
                       "/",
                       m,
                       "/std_samples/",
                       m, "_satdist.", ext)
    write.table(
      histogram_sample,
      file = file_name,
      sep = ";",
      row.names = FALSE
    )
  } # for (ext in MODELS_EXTENSIONS) 
} # for (m in models)
