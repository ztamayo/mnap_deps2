##
# Dockerfile for MNAP
# MNAP code created by: Anticevic Lab, Yale University and Mind and Brain Lab, University of Ljubljana
# Maintainer of Dockerfile: Zailyn Tamayo, Yale University
##

##
# Tag: ztamayo/mnap_deps2:latest
# Dockerfile 2 for dependencies needed to run MNAP suite
# Installs dependencies FreeSurfer 5.3.0, FIX (removed), PALM, and Gradunwarp
##

FROM ztamayo/mnap_deps1:latest 

# Set PATH
ENV PATH="/opt/workbench/bin_linux64" \
    FREESURFER_HOME="/opt/freesurfer-5.3-HCP" \
    PATH="/opt/freesurfer-5.3-HCP/bin:$PATH"
RUN apt-get update -qq && \
    apt-get clean && \
    echo "Downloading FreeSurfer ..." && \
    mkdir -p /opt/freesurfer-5.3-HCP/ && \
# Install FreeSurfer 5.3-HCP
    wget --progress=bar:force -O /tmp/freesurfer-Linux-centos6_x86_64-stable-pub-v5.3.0-HCP.tar.gz ftp://ftp.nmr.mgh.harvard.edu/pub/dist/freesurfer/5.3.0-HCP/freesurfer-Linux-centos6_x86_64-stable-pub-v5.3.0-HCP.tar.gz && \
    tar -xzvf /tmp/freesurfer-Linux-centos6_x86_64-stable-pub-v5.3.0-HCP.tar.gz -C $FREESURFER_HOME --strip-components 1 && \
    rm /tmp/freesurfer-Linux-centos6_x86_64-stable-pub-v5.3.0-HCP.tar.gz && \
    rm -R ${FREESURFER_HOME}/trctrain/ && \
    echo "source $FREESURFER_HOME/SetUpFreeSurfer.sh" >> ~/.bashrc && \
# Install PALM
    wget --progress=bar:force -O /tmp/palm-alpha111.tar.gz https://s3-us-west-2.amazonaws.com/andersonwinkler/palm/palm-alpha111.tar.gz && \
    tar -xzvf /tmp/palm-alpha111.tar.gz -C /opt && \
    rm /tmp/palm-alpha111.tar.gz && \
# Install Gradunwarp
    cd /opt && \
    git clone https://github.com/Washington-University/gradunwarp.git

WORKDIR /opt/gradunwarp/

RUN python setup.py install && \
    wget --progress=bar:force -O /tmp/nibabel-1.2.0.dev.tar.gz https://github.com/downloads/ksubramz/gradunwarp/nibabel-1.2.0.dev.tar.gz && \
    tar -xzvf /tmp/nibabel-1.2.0.dev.tar.gz -C /opt && \
    rm /tmp/nibabel-1.2.0.dev.tar.gz

WORKDIR /opt/nibabel-1.2.0.dev/

RUN python setup.py install && \
# Install workbench
    echo "Downloading workbench ..." && \
    wget --progress=bar:force -O /tmp/workbench-linux64.zip https://ftp.humanconnectome.org/workbench/workbench-linux64-v1.3.1.zip && \
    unzip /tmp/workbench-linux64.zip -d /opt/ && \
    rm /tmp/workbench-linux64.zip && \
# Clear apt cache and other empty folders
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /boot /media /mnt /srv && \
    rm -rf ~/.cache/pip && \
    cd /opt/workbench/libs_linux64 && \
    mv libz.so.1 libz.so.1.old && \
    ln -s /lib/x86_64-linux-gnu/libz.so.1 && \
    cd /

ADD license.txt $FREESURFER_HOME

CMD ["bash"]

# Install FIX
#RUN wget --progress=bar:force -O /tmp/fix.tar.gz http://www.fmrib.ox.ac.uk/~steve/ftp/fix.tar.gz
#RUN tar -xzvf /tmp/fix.tar.gz -C /opt
#RUN rm /tmp/fix.tar.gz
