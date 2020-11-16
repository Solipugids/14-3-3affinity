df2feature <- function(df, descriptors)
{
  pep.array <- df$Sequence
  if (pep.array %>% str_length() %>% unique() %>% length() > 1) {
    stop("The peptide sequences are not consistent in length.")
  }
  descriptors.mat <-
    t(sapply(
      pep.array,
      FUN = function(x)
        (seq2feature(x, descriptors)
        )))
  colnames(descriptors.mat) <-
    paste0("V", seq(dim(descriptors.mat)[2]), sep = "")
  df <- cbind(df, descriptors.mat)
  return(df)
}

seq2feature <- function(pep_seq, descriptors) {
  pep_seq_splited <- unlist(strsplit(pep_seq, split = NULL))
  feature <-
    unlist(sapply(
      pep_seq_splited,
      FUN = function(x)
        (descriptors[which(row.names(descriptors) == x),]
        )))
  return(feature)
}
