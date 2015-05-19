## Based on rocker / hadleyverse maintained by Carl Boettiger and Dirk Eddelbuettel
FROM rocker / hadleyverse

MAINTAINER "Petr Simecek" lamparna@gmail.com

# install additional BioC scripts
RUN Rscript -e 'source("http://bioconductor.org/biocLite.R"); biocLite("annotate", ask=FALSE); biocLite("biomaRt", ask=FALSE)'