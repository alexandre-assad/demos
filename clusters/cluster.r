if (!require("factoextra")) install.packages("factoextra", lib = Sys.getenv("R_LIBS_USER"), repos = "https://cloud.r-project.org/")
if (!require("cluster")) install.packages("cluster", lib = Sys.getenv("R_LIBS_USER"), repos = "https://cloud.r-project.org/")

library(factoextra)
library(cluster)

data <- read.csv("data_abs.csv", stringsAsFactors = FALSE)

data_num <- data[ , sapply(data, is.numeric)]

data_num <- data.frame(lapply(data_num, function(x) {
  if (any(is.na(x))) {
    x[is.na(x)] <- mean(x, na.rm = TRUE)
  }
  return(x)
}))

data_scaled <- scale(data_num)

fviz_nbclust(data_scaled, kmeans, method = "wss")

fviz_nbclust(data_scaled, kmeans, method = "silhouette")

set.seed(123)
k <- 3
km <- kmeans(data_scaled, centers = k, nstart = 25)

fviz_cluster(km, data = data_scaled)

data$Cluster <- km$cluster

aggregate(data_num, by = list(Cluster = data$Cluster), FUN = mean)

