FROM jenkins/ssh-agent:jdk11

USER root
RUN apt-get update && apt-get install -y lsb-release ca-certificates curl unzip && update-ca-certificates
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-ce-cli
WORKDIR /opt
RUN curl -LO https://dl.k8s.io/release/v1.25.0/bin/linux/amd64/kubectl && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
RUN curl https://deb.nodesource.com/setup_current.x | bash && apt-get install -y nodejs
RUN npm i -g npm@latest
RUN apt-get install -y git-core

RUN echo "PATH=${PATH}" >> /etc/environment