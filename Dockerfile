# Dockerfile for Group 304
# Authors: Anny Chih, Wenjiao Zou, Robert Pimentel
# Use rocker/tidyverse as the Base Image
FROM rocker/tidyverse

# Install R
RUN apt-get update
RUN apt-get install r-base r-base-dev -y

# Install R Packages
RUN Rscript -e "install.packages('tidyverse')"
RUN Rscript -e "install.packages('knitr')"
RUN Rscript -e "install.packages('docopt')"
RUN Rscript -e "install.packages('dplyr')"
RUN Rscript -e "install.packages('repr')"
RUN Rscript -e "install.packages('readr')"
RUN Rscript -e "install.packages('infer')"
RUN Rscript -e "install.packages('broom')"
RUN Rscript -e "install.packages('kableExtra')"
RUN Rscript -e "install.packages('testthat')"
RUN Rscript -e "install.packages('cowplot')"

# Install the Anaconda distribution of Python
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

# Install Python Packages
RUN /opt/conda/bin/conda install -y -c anaconda docopt
RUN /opt/conda/bin/conda install -y anaconda pandas

# Put Anaconda Python in PATH
ENV PATH="/opt/conda/bin:${PATH}"

CMD [ "/bin/bash" ]

# STEPS IN TERMINAL
# First navigate to the root directory, then type the following commands into Terminal:
# 1. `docker build --tag test .`
# 2. `docker run --rm -it test /bin/bash`
#note: you don't need the "/bin/bash" in Step 2 if you have `CMD ["/bin/bash"]` in the Dockerfile like we do here
