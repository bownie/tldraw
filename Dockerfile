FROM ubuntu:focal

# update local package databases
RUN apt update

# install some apps
RUN apt install -y curl \
    git

# create a regular account
ENV TLDRAW_USER tldraw
RUN useradd -m ${TLDRAW_USER}

# switch to the new user
USER ${TLDRAW_USER}

# install nvm
RUN cd /home/${TLDRAW_USER} && \
    curl -O https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh && \
    . /home/${TLDRAW_USER}/.profile && \
    NVM_DIR=/home/${TLDRAW_USER}/.nvm PROFILE=/home/${TLDRAW_USER}/.profile /bin/bash ./install.sh

# install nodejs
RUN . /home/${TLDRAW_USER}/.profile && \
    cd /home/${TLDRAW_USER} && \
    nvm install --lts

# install node packages
RUN . /home/${TLDRAW_USER}/.profile && \
    cd /home/${TLDRAW_USER} && \
    npm install --upgrade -g yarn

# clone tldraw
RUN cd /home/${TLDRAW_USER} && \
    git clone https://github.com/tldraw/tldraw

# build tldraw
RUN . /home/${TLDRAW_USER}/.profile && \
    cd /home/${TLDRAW_USER}/tldraw && \
    yarn install --network-timeout 3600000 --non-interactive

COPY yarn_start.sh /home/${TLDRAW_USER}/tldraw/

ENTRYPOINT /home/${TLDRAW_USER}/tldraw/yarn_start.sh