## Coursera Project Nick Stellitano
library("car")
library("plyr")

data_xtest_raw <- read.table("UCI HAR Dataset/test/X_test.txt")
data_ytest_raw <- read.table("UCI HAR Dataset/test/Y_test.txt")
data_sub_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
data_feature_test <- read.table("UCI HAR Dataset/features.txt")

colnames(data_xtest_raw) <-  as.character(t(data_feature_test[,2]))
colnames(data_ytest_raw) <- "Activity"
colnames(data_sub_test) <- "Subject"

data_test <- cbind(data_sub_test, data_ytest_raw, data_xtest_raw)
data_test[,2] <- recode(data_test[,1], "1 = 'Walking'; 2 = 'Walking_Upstairs';  3 = 'Walking_Downstairs';
                                             4 = 'Sitting'; 5 = 'Standing'; 6 = 'Laying'")


data_xtrain_raw <- read.table("UCI HAR Dataset/train/X_train.txt")
data_ytrain_raw <- read.table("UCI HAR Dataset/train/Y_train.txt")
data_sub_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
data_feature_train <- read.table("UCI HAR Dataset/features.txt")


colnames(data_xtrain_raw) <-  as.character(t(data_feature_train[,2]))
colnames(data_ytrain_raw) <- "Activity"
colnames(data_sub_train) <- "Subject"

data_train <- cbind(data_sub_train, data_ytrain_raw, data_xtrain_raw)
data_train[,2] <- recode(data_train[,2], "1 = 'Walking'; 2 = 'Walking_Upstairs';  3 = 'Walking_Downstairs';
                            4 = 'Sitting'; 5 = 'Standing'; 6 = 'Laying'")

mean_std <- grepl("*mean*|*std*|*Mean*", colnames(data_test))
mean_std[1:2] <-TRUE
data_test_short<-data_test[,mean_std]

write.table(colnames(data_test_short), "Tidy_Names.txt")

mean_std <- grepl("*mean*|*std*|*Mean*", colnames(data_train))
mean_std[1:2] <-TRUE
data_train_short<-data_train[,mean_std]

data_test_tidy <- ddply(data_test_short, .(Subject), numcolwise(mean))
data_train_tidy <- ddply(data_train_short, .(Subject), numcolwise(mean))

data_tidy_combined <- rbind(data_test_tidy, data_train_tidy)
write.table(data_tidy_combined, "Tidy Data Table Stellitano.txt")
