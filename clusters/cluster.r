# Installer les packages nécessaires
if (!require("factoextra")) install.packages("factoextra", lib = Sys.getenv("R_LIBS_USER"), repos = "https://cloud.r-project.org/")
if (!require("cluster")) install.packages("cluster", lib = Sys.getenv("R_LIBS_USER"), repos = "https://cloud.r-project.org/")

# Charger les bibliothèques
library(factoextra)
library(cluster)

# Charger les données
data <- read.csv("data_abs.csv", stringsAsFactors = FALSE)

# Garder uniquement les colonnes numériques pour le clustering
data_num <- data[ , sapply(data, is.numeric)]

# Traiter les valeurs manquantes (par exemple, remplacer par la moyenne)
data_num <- data.frame(lapply(data_num, function(x) {
  if (any(is.na(x))) {
    x[is.na(x)] <- mean(x, na.rm = TRUE)
  }
  return(x)
}))

# Normaliser les données
data_scaled <- scale(data_num)

# Méthode du coude pour déterminer le nombre optimal de clusters
fviz_nbclust(data_scaled, kmeans, method = "wss")

# Calcul du critère silhouette
fviz_nbclust(data_scaled, kmeans, method = "silhouette")

# Appliquer le clustering avec le nombre optimal de clusters (k = 3 dans cet exemple)
set.seed(123) # pour la reproductibilité
k <- 3 # remplacez par le nombre optimal trouvé
km <- kmeans(data_scaled, centers = k, nstart = 25)

# Visualisation des clusters
fviz_cluster(km, data = data_scaled)

# Ajouter les clusters aux données d'origine
data$Cluster <- km$cluster

# Analyser les clusters (par exemple, moyenne des variables pour chaque cluster)
aggregate(data_num, by = list(Cluster = data$Cluster), FUN = mean)

