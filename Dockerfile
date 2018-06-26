##
# Dockerfile for MNAP
# MNAP code created by: Anticevic Lab, Yale University and Mind and Brain Lab, University of Ljubljana
# Maintainer of Dockerfile: Zailyn Tamayo, Yale University
##

##
# Tag: ztamayo/mnap_deps2:latest
# Dockerfile 2 for dependencies needed to run MNAP suite
# Installs dependencies FreeSurfer 5.3.0, FIX, PALM, and Gradunwarp
##

FROM ztamayo/mnap_deps1:latest 

RUN apt-get update

# Install FreeSurfer 5.3.0
ENV FREESURFER_HOME="/opt/freesurfer-5.3.0" \
    PATH="/opt/freesurfer-5.3.0/bin:$PATH"
RUN echo "Downloading FreeSurfer ..." && \
    mkdir -p /opt/freesurfer-5.3.0 && \
    wget --progress=bar:force -O /tmp/freesurfer-Linux-centos6_x86_64-stable-pub-v5.3.0.tar.gz ftp://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/5.3.0/freesurfer-Linux-centos6_x86_64-stable-pub-v5.3.0.tar.gz
RUN tar -xzvf /tmp/freesurfer-Linux-centos6_x86_64-stable-pub-v5.3.0.tar.gz -C $FREESURFER_HOME --strip-components 1 
RUN rm /tmp/freesurfer-Linux-centos6_x86_64-stable-pub-v5.3.0.tar.gz
    
COPY $FREESURFER_LIC $FREESURFER_HOME/license.txt
RUN echo "source $FREESURFER_HOME/SetUpFreeSurfer.sh" >> ~/.bashrc

# Install FIX
RUN wget --progress=bar:force -O /tmp/fix.tar.gz http://www.fmrib.ox.ac.uk/~steve/ftp/fix.tar.gz
RUN tar -xzvf /tmp/fix.tar.gz -C /opt
RUN rm /tmp/fix.tar.gz

# Install PALM
RUN wget --progress=bar:force -O /tmp/palm-alpha111.tar.gz https://s3-us-west-2.amazonaws.com/andersonwinkler/palm/palm-alpha111.tar.gz
RUN tar -xzvf /tmp/palm-alpha111.tar.gz -C /opt
RUN rm /tmp/palm-alpha111.tar.gz

# Install Gradunwarp
RUN wget --progress=bar:force -O /tmp/gradunwarp-2.1_slice_alpha.tar.gz https://github.com/downloads/ksubramz/gradunwarp/gradunwarp-2.1_slice_alpha.tar.gz
RUN tar -xzvf /tmp/gradunwarp-2.1_slice_alpha.tar.gz -C /opt
RUN rm /tmp/gradunwarp-2.1_slice_alpha.tar.gz
WORKDIR /opt/gradunwarp-2.0_alpha/
RUN python setup.py install

RUN wget --progress=bar:force -O /tmp/nibabel-1.2.0.dev.tar.gz https://github.com/downloads/ksubramz/gradunwarp/nibabel-1.2.0.dev.tar.gz
RUN tar -xzvf /tmp/nibabel-1.2.0.dev.tar.gz -C /opt
RUN rm /tmp/nibabel-1.2.0.dev.tar.gz
WORKDIR /opt/nibabel-1.2.0.dev/
RUN python setup.py install

WORKDIR /

# Clear apt cache and other empty folders
USER root
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /boot /media /mnt /srv && \
    rm -rf ~/.cache/pip

CMD ["bash"]