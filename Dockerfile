FROM rocker/r-base:4.4.2

# copy the app to the image
RUN mkdir /app
COPY . /app

# install dependencies
RUN apt-get update
RUN apt-get -y install make zlib1g-dev libcurl4-openssl-dev libssl-dev libicu-dev pandoc libxml2-dev libglpk-dev

# install renv
RUN R -e "install.packages('renv')"

# install all necessary packages with renv
WORKDIR /app
ENV RENV_PATHS_LIBRARY renv/library
RUN R -e "renv::restore()"

EXPOSE 3838
CMD ["R", "-e", "shiny::runApp('/app', port = 3838, host = '0.0.0.0')"]
