# Dockerfile vars

# ENV
IMAGENAME=user-management
IMAGEFULLNAME=${IMAGENAME}:latest

.PHONY: help build push all

help:
	@echo "Makefile commands:"
	@echo "build"
	@echo "push"
	@echo "all"

.DEFAULT_GOAL := all

build:
	@docker build --pull -t ${IMAGEFULLNAME} .

rebuild:
	@docker build --pull --no-cache -t ${IMAGEFULLNAME} .

run:
	@docker run --rm -it -t -v $(pwd):/usr/src/app ${IMAGEFULLNAME} ./bin/console

# push:
# 	@docker push ${IMAGEFULLNAME}

# all: build push
