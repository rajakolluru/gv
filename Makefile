
# Pre-requisites for running this Makefile
# Make sure that git is installed
# install gradle
# install java (of course)

export PROJECTNAME="pricedomain"
.DEFAULT_GOAL := help

## build: Build the executable with the version extracted from GIT
.PHONY: build
build:
	gradle build

## clean: Clean files
.PHONY: clean
clean:
	gradle clean

## run: Run the executable using the Application plugin
.PHONY: run
run:
	gradle run

# check-tag: internal tag does not need to show in documentation
.PHONY: check-tag
check-tag:
	@ if ! test -n "$(tag)"; then echo "tag needs to be specified. Use 'make $(MAKECMDGOALS) tag=<tagname>'"; exit 1 ; fi

## tag: Tag the source with tag name xxx. Use "make tag tag=<tagname>"
.PHONY: tag
tag: check-tag
	git tag -a -m $(tag) $(tag)
	@echo "Created a  tag $(tag) for the release. Now you can run 'make build'"

## create-hotfix: Creates a hotfix branch for tag xxx. Use it like "make create-hotfix tag=<tagname>"
.PHONY: create-hotfix
create-hotfix: check-tag
	git checkout -b b$(tag) $(tag)
	@echo "Created a hotfix branch b$(tag) and checked it out for you"


## find-latest-tag: Finds the latest tag for this project
.PHONY: find-latest-tag
find-latest-tag:
	@git describe | cut -d- -f1


## help: type for getting this help
.PHONY: help
help: Makefile
	@echo
	@echo " Choose a command to run in "$(PROJECTNAME)":"
	@echo
	@sed -n 's/^##//p' $< | column -t -s ':' |  sed -e 's/^/ /'
	@echo
