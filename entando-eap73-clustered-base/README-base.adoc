# Entando JBoss EAP 7.3 Cluster Ready Base Image

The Entando JBoss EAP 7.3 Cluster Ready Base Image directly extends the Entando Base Image
Please consult the parent image's documentation for a better understanding of how to configure this image. The only difference between this
image and the Entando JBoss EAP 7.3 Base Image is that it has enabled the cluster ready caches for the Entando Infinispan plugin.

## Ports

**8080** - {PORT_8080}

**8443** - {PORT_8443}

**8778** - {PORT_8778}

**8888** - {PORT_8888}


## Volumes

**/entando-data**: the standard 'entando-data' volume is mounted at /entando-data. This directory contains the uploaded resources, protected resources and indices, as well as the two
embedded Derby databases for optional use.

## How to run

This image was not intended to be run directly in Docker. Extend the image to support the Openshfit S2I functionality, or
use it as a base image in a Maven build or a Dockerfile
