#!/bin/bash

# Install helm.repos
helm repo add stable https://charts.helm.sh/stable
helm repo add traefik https://helm.traefik.io/traefik

# Get traefik charts from github
curl -LO https://github.com/traefik/traefik-helm-chart/archive/master.zip
unzip master.zip && rm master.zip
helm install traefik ./traefik-helm-chart-master/traefik
rm -rf ./traefik-helm-chart-master
