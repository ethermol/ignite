#!/bin/bash
COMMIT=$(git rev-parse --verify HEAD)
docker image build -f “Dockerfile” . \
  --build-arg “app_name=knoware” \
  -t “knoware:latest” \
  -t “knoware:${COMMIT:0:5}
