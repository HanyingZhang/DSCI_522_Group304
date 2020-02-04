#FROM debian:stable

# use rocker/tidyverse as the base image and
FROM rocker/tidyverse

########### <NOTES> #############
# the debian is the "name of the image"
# the stable is the "tag"; it can specify the version of the image you want
# In Terminal: `docker build --tag testr1 .` # the "." says that you want to get it from the current directory (you should be in the project root)
# The default tag is "latest"

# Example:
# (mds) dhcp-206-87-235-224:DSCI_522_Group304 annychih$ docker build --tag testr1 . # this asks docker to buid the container
# Sending build context to Docker daemon    275MB
# Step 1/1 : FROM debian:stable
# ---> 0cadf648163a
# Successfully built 0cadf648163a
# Successfully tagged testr1:latest

# Then: `docker run -it --rm testr1` to get to the dockerfile
# `ls`
# root@40a806187a93:/# apt-get update # checked that this worked in Terminal before adding below
# root@40a806187a93:/# apt-get install r-base r-base-dev # checked that this worked in Terminal before adding below
# `exit` to get out of the docker container

# For every RUN statement, there's a different layer in the container

# the '-y' in `RUN apt-get install r-base r-base-dev -y` tells it to say 'Y' when you're asked 'Do you want to continue?' during installation

# When you're in your dockerfile, you can do something like `Rscript -e "print('hello')"` to run "print('hello')" using R

# `root@34ba4b7e728d:/# Rscript -e "install.packages('cowsay')"` to install cowsay package
# Then `R` to use R (which was already installed)
# Then test cowsay with something like:
# > library(cowsay)
# > say("Smart are you for using Docker", "yoda")

# Once you exit out of docker, you won't be able to use cowsay anymore; it goes poof!

# <\notes>
#######

RUN apt-get update
RUN apt-get install r-base r-base-dev -y

# RUN Rscript -e "install.packages('cowsay')"

# install the anaconda distribution of python
RUN wget --quiet https://repo.anaconda.com/archive/Anaconda3-2019.10-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc && \
    find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    /opt/conda/bin/conda clean -afy && \
    /opt/conda/bin/conda update -n base -c defaults conda

# install docopt python package
RUN /opt/conda/bin/conda install -y -c anaconda docopt

# put anaconda python in path
ENV PATH="/opt/conda/bin:${PATH}"