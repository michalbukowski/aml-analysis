# syntax=docker/dockerfile:1

# Created by Michal Bukowski (michal.bukowski@tuta.io) under GPL-3.0 license.
# Dockerfile allowing for running alm-analysis Jupyter notebooks.

# Build a new image based on continuumio/miniconda3 image from the Docker library.
FROM continuumio/miniconda3

# As long as the user is root, install libtiff5 and libxt6 libraries.
RUN apt update
RUN apt -y install libtiff5 libxt6

# Create a plain user that will run the container. Adjust gid and uid when
# running docker build to you user and group by adding following arguments:
# --build-arg uid=$(id -u) --build-arg gid=$(id -g)
# To run a container as root, add the following argument to docker run:
# --user 0:0
ARG uid=1000
ARG gid=1000
ARG home=/home/amluser

RUN groupadd -g $gid amlgroup
RUN useradd -s /bin/bash -md $home -u $uid -g $gid amluser
USER amluser

# Copy the external conda enovironment aml-env.yml file to the /tmp directory.
COPY conda/aml-env.yml /tmp/aml-env.yml

# Based on the copied YAML file, create a conda environment, and add
# the environment bin directory to PATH variable.
RUN conda env create --prefix $home/aml-env --file /tmp/aml-env.yml
ENV PATH="$home/aml-env/bin:${PATH}"

# Expose the PORT Jupyter Lab will run on.
EXPOSE 8888

# Set the working directory to /app. It is expected /app directory
# will be mapped to an external location where the app files are stored, e.g.
# to ./ if you run the Docker image from the app directory.
WORKDIR /app

# Run Jupyter Lab when a container launches.
CMD ["jupyter", "lab", "--ip", "0.0.0.0", "--port", "8888", \
     "--no-browser", "--allow-root"]

