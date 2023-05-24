
# choose pipeline:
Sys.setenv(TAR_PROJECT = "pipeline3")

# choose dev. or production environment (ie., small or large data to prcocess):
Sys.setenv("R_CONFIG_ACTIVE" = "dev")

# build visual network:
library(targets)
tar_visnetwork()
tar_visnetwork(targets_only = TRUE)


# build pipeline
tar_make()


# list pipeline steps:
tar_manifest()
