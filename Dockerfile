FROM ubuntu:focal AS build

ENV DEBIAN_FRONTEND=noninteractive
ARG KUBEADM_VERSION="1.21.3-00"
ARG ANSIBLE_VERSION="2.10"

RUN apt-get update && apt-get -y install \
  curl \
  software-properties-common

RUN curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list

RUN add-apt-repository ppa:ansible/ansible-${ANSIBLE_VERSION}

RUN apt-get update && apt-get -y install \
  kubeadm=$KUBEADM_VERSION \
  ansible-base=${ANSIBLE_VERSION}*

COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]