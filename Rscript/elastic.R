library(tidyverse)
library(glmnet)
library(caret)
library(plotmo)
library(stringr)
library(leaps)
library(arrangements)

source("./Rscript/functions.R")

dpps <- read.table("./data/DPPS", row.names = 1, header = T)
affinity <- read.table('./data/array.dat', header = T, colClasses = c("NULL", "NULL", "character", "numeric", "NULL", "factor")) ## read the raw data.
affinity$logRF <- affinity$RF %>% log() %>% ifelse(. < 0, 0, .) ## convert RF to logRF.
affinity <- affinity[-which(affinity$logRF == 0), ] ## discard the rows with low affinity.
## write.table(affinity, file = "./data/14_3_3_affinity.csv", sep = "\t", quote = FALSE, row.names = FALSE) ## save the preprocessed data.
isoforms <- levels(affinity$Isoforms) 
sublibrary <- c("N", "C")
isoform.sublib <- apply(expand.grid(isoforms, sublibrary), 1, paste, collapse = ".")

for (i in isoforms) {
  for (j in sublibrary) {
    affinity.isoform <- subset(affinity, Isoforms == i)
    if (j == "N") {
      affinity.isoform.sub <-
        subset(affinity.isoform, grepl("pS/TXXX", Sequence))
      affinity.isoform.sub$Sequence <-
        gsub(pattern = "pS/TXXX",
             replacement = "",
             affinity.isoform.sub$Sequence)
    } else {
      affinity.isoform.sub <-
        subset(affinity.isoform, grepl("XXXpS/T", Sequence))
      affinity.isoform.sub$Sequence <-
        gsub(pattern = "XXXpS/T",
             replacement = "",
             affinity.isoform.sub$Sequence)
    }
    input <- df2feature(affinity.isoform.sub, dpps)
    
    set.seed(1940)
    training.samples <-
      createDataPartition(input$logRF, p = 0.8, list = FALSE)
    train <- input[training.samples,-(1:3)]
    test <- input[-training.samples,-(1:3)]
    set.seed(1940)
    fit <- train(
      logRF ~ .,
      data = train,
      method = "glmnet",
      trControl = trainControl("cv", number = 10),
      tuneLength = 10
    )
    test.predictors <- model.matrix(logRF ~ ., test)[, -1]
    prediction <- fit %>% predict(test.predictors)
    
    dpps.results[[paste(i, j, sep = ".")]] <-
      list(
        r2 = R2(prediction, test$logRF),
        rmse = RMSE(prediction, test$logRF),
        prediction = prediction,
        model = fit,
        train = train,
        test = test,
        dataset = input
      )
    ## final.data[names(final.data) == paste(i, j, collapse = ".")] <- list(RMSE = rmse, R2 = r2, model = fit)
  }
}

