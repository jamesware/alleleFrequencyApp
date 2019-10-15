FROM rocker/shiny

WORKDIR /srv/shiny-server/alleleFrequencyApp

COPY . /srv/shiny-server/alleleFrequencyApp/

# Install additional packages
RUN bash installRequiredRPackages.sh server.R
RUN bash installRequiredRPackages.sh ui.R
