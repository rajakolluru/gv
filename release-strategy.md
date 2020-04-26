# Branching & Release Strategy

# The Strategy

## Branches & Versions
There will be one permanent branch "master". We will follow semantic versioning everywhere.
All major and minor releases to production happen from master. All patch releases to production happen from
 ephemeral hot fix branches.

## Build Once - Deploy 2 times
All releases must be built once after a tag is made. It is first released to a UAT environment where it is
tested. If UAT passes then the tagged build is propagated to production without re-issuing the build command
again. If UAT fails then the build is tagged as a patch release, re-tested and then pushed to production.
 
## UAT Environments
UAT typically happens in PPE for major and minor releases. (unless the PPE happens to be used for something super
 important which should be very rare) For patch releases, all UAT happens in an ephemeral UAT
 environment that uses the same downstream resources such as KAFKA topics. However end points exposed by UAT is 
 distinct from PPE.
 
## Tags & Naming
A tag is created before a final build is taken for deployment in production. The tag is created in the 
same branch from where the release happens as specified above. The name of the tag is the same as 
that of the semantic version of the release. The same tagged build is validated in UAT (whether it is 
 the ephemeral UAT environment or PPE as mentioned in the point above) and then moved to production. 
 
## Deployment Artifacts and Versions
The deployable artifact generated has the tag as suffix for its name. For example, price might have an artifact 
with name price-0.0.1.jar where tag name is 0.0.1. This will allow the developers to know the tag that 
generated this deployable.
The generated artifact must support a version end point that can emit the version of the tag. This will allow
an end user to know the version of the current deployable.

# The Process - Release and Branching Commands

## To release a major or minor version (from master)

Let us say that we decided to release a major or minor version to production. The following steps need to be
followed:

1. Tag the release

All major and minor versions are released with patch version as 1. Let us say we want to release 1.0.1 (major 1 ,
minor 0 - as we said patch must always be 1 to begin with)

This should be released from master. First goto the git folder and make sure that we are at the master branch
with the correct changes that need to be tested. Tag the folder using:
```
$ git tag -a -m "1.0.1" 1.0.1
```
This creates a tag based out of the master called 1.0.1
```
$ git describe --always --long --dirty
1.0.1
```

Now push the version built to PPE for testing. If PPE is busy, set up a UAT environment and use that for testing.
Once the testing is completed successfully, release this to production by using the same docker image.
If there are changes required to make the UAT pass, keep building the sources once again. After each commit, the
output of git describe will change