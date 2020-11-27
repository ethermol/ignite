# Creating the initial hugo-container

Build this docker-image on order to get going with k8s.
Build and test within docker locally as a first step.
The resulting image should be stored in docker-hub.

- create hugo-book template in public github repo which will be cloned into the image.
- build the image with: docker build -t hugo .
- * run the image with: docker run --name hugo -p 1313:1313 hugo
- * test the image with: http://<ip>:1313/
- * items don't work for some reason, might need --bind 0.0.0.0/0 or url: http://example.com/ should be changed.
- run the image with: docker run --name hugo --network=host hugo.
- connect locally: http://localhost:1313/
