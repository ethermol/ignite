#!/bin/bash

[ -f /usr/local/bin/helm ] || \
  { curl -LO https://get.helm.sh/helm-v3.4.1-linux-arm64.tar.gz && \
    tar xf helm-v3.4.1-linux-arm64.tar.gz && mv linux-arm64/helm /usr/local/bin/ && rm helm-v3.4.1.*.gz && rm -rf linux-arm64 \
  }

