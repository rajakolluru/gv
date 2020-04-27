
# Pre-requisites for running this Makefile
# Make sure that git is installed
# install gradle
# java

export PROJECTNAME="pricedomain"
.DEFAULT_GOAL := all

## build: Build the executable with the version extracted from GIT
.PHONY: build
build:
	gradle build

## run: Run the executable using the Application plugin
.PHONY: run
run:
	gradle run

# check-tag: internal tag does not need to show in documentation
.PHONY: check-tag
check-tag:
	@  ! test -n "$(tag)" && { echo "tag needs to be specified. Use 'make <target> tag=xxx'";exit 1;}

## tag: Tag the source with tag name xxx. Use "make tag tag=0.1.1"
.PHONY: tag
tag: check-tag
	git tag $(tag)

## create-hotfix: Creates a hotfix branch for tag xxx. Use it like "make create-hotfix tag=xxx"
.PHONY: create-hotfix
create-hotfix: check-tag
	git checkout -b b$(tag) $(tag)
	@echo "Created a hotfix branch b$(tag) and checked it out for you"


.PHONY: all
all: help

## help: type for getting this help
.PHONY: help
help: Makefile
	@echo
	@echo " Choose a command to run in "$(PROJECTNAME)":"
	@echo
	@sed -n 's/^##//p' $< | column -t -s ':' |  sed -e 's/^/ /'
	@echo
