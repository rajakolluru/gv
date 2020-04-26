# Branching & Release Strategy

## Branches & Versions
There will be one permanent branch "master". We will follow semantic versioning everywhere.
All major and minor releases to production happen from master. All patch releases to production happen from
 ephemeral hot fix branches.
 
## UAT Environments
All UAT happens in PPE for major and minor releases. For patch releases, all UAT happens in an ephemeral UAT 
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

# Release and Branching Commands


