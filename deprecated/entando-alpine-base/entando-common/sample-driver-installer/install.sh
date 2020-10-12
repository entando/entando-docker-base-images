#!/usr/bin/env bash
mvn clean package  -Dmaven.repo.local=/app/.m2/repository || { echo "Could not download Sample dependency"; exit 23; }
