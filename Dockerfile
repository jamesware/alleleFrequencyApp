FROM rocker/shiny

# Copy the codebase into the correct directory for hosting
WORKDIR /srv/shiny-server/alleleFrequencyApp

COPY . /srv/shiny-server/alleleFrequencyApp/

# Copy the customised shiny server config
COPY shiny-server.conf /etc/shiny-server/shiny-server.conf

# Remove the shiny default index page
RUN rm /srv/shiny-server/index.html

# Install additional packages
RUN bash installRequiredRPackages.sh server.R
RUN bash installRequiredRPackages.sh ui.R
