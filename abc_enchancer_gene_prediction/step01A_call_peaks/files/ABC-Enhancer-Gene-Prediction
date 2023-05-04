# Need to clone the repository first

FROM continuumio/anaconda3:2022.10
# Install required libraries
RUN apt-get update && apt-get install -y python python3 virtualenv python3-pip  zlib1g-dev zlib1g libbz2-dev liblzma-dev wget libncurses5-dev

# Set the working directory
WORKDIR /usr/src/app

# Setup the python requirements
#RUN pip2 install --no-cache-dir numpy
RUN pip3 install Cython
RUN pip3 install --no-cache-dir numpy pandas scipy pyBigWig pyranges
RUN pip3 install pysam

# Setup samtools
RUN wget -O samtools-0.1.19.tar.bz2 https://sourceforge.net/projects/samtools/files/samtools/0.1.19/samtools-0.1.19.tar.bz2/download &&  tar xjf samtools-0.1.19.tar.bz2 && cd  /usr/src/app/samtools-0.1.19 &&  make -j 4

# Doesn't work?
# Setup tabix
# RUN wget -O tabix-0.2.5.tar.bz2 https://sourceforge.net/projects/samtools/files/tabix/tabix-0.2.5.tar.bz2/download &&  tar xjf tabix-0.2.5.tar.bz2 && cd  /usr/src/app/tabix-0.2.5 &&  make -j 4

# Update the path
ENV PATH=/usr/src/app/samtools-0.1.19/:${PATH}

# Setup bedtools
RUN wget -O bedtools-2.26.0.tar.gz https://github.com/arq5x/bedtools2/releases/download/v2.26.0/bedtools-2.26.0.tar.gz && tar xzf bedtools-2.26.0.tar.gz && cd /usr/src/app/bedtools2/ &&  make -j 12

# Update the path
ENV PATH=/usr/src/app/bedtools2/bin/:${PATH}

# Install python packages
#RUN pip2 install MACS2 && pip2 install progressbar &&  pip3 install progressbar
#RUN pip3 install MACS2
COPY macs.yml /usr/src/app/macs.yml
RUN conda env create -f macs.yml
COPY abcenv.yml /usr/src/app/abcenv.yml
RUN conda env create -f abcenv.yml

# Copy the required scripts
COPY src/ /usr/src/app/src
#Copy the Dockerfile for reproducibility
COPY Dockerfile Dockerfile