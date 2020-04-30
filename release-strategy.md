# Branching & Release Strategy

# The Strategy

![Release Strategy](ReleaseCycle.png)

## Branches & Versions
There will be one permanent branch "master". We will follow semantic versioning everywhere.
All major and minor releases to production happen from master.
It is preferable to keep the master super stable so that it is possible to do patch releases from master as well. 
But if the master is not very stable, it is possible to do patch releases from ephemeral hot fix branches.

## Build Once - Deploy 2 times
All releases must be built once after a tag is made. It is first released to a UAT environment where it is
tested. If UAT passes then the tagged build is propagated to production without re-issuing the build command
again. If UAT fails then the requisite changes are made, the build is tagged as a patch release, re-tested and then pushed to production.
 
## UAT Environments
UAT typically happens in PPE for major and minor releases. (unless the PPE happens to be used for something super
 important which should be very rare) For patch releases, UAT happens in PPE if the release is made from the master branch (preferable). An ephemeral UAT environment can be used if the master is unstable. The ephemeral UAT must use the same downstream resources such as KAFKA topics. This ensures that the whole ecosystem is not replicated to accommodate the hotfix
 environment. However end points are distinct from PPE and may need tweaks to upstream systems to test them.
 
## Tags, Software Versions & Naming

Git Tags will be used to mark the version of the source code in GIT. Tags are better than branches because of the following:
1. They are more light weight (at least by perception) and signify the intent better.
2. They are supported by commands such as "git describe" which trace the last tag and the commits made post taking the tag.
3. Tags can be taken from master or from any other branch. It does not matter even if the branch is deleted. 
4. Tags dont need dedicated CI or permanent environments. They are materialized, hotfixed and decommissioned as required.
5. Tags are immutable. Hence they mandate that a new tag be created when a release happens. This keeps the versioning process 
completely consistent. We cannot deploy a new release without creating a new tag and hence a new version of the software.

We will use annotated tags to keep track of our releases. 
A tag is created before a final build is taken for deployment in production. The tag is created in the 
same branch from where the release happens as specified above. The name of the tag is the same as 
that of the semantic version of the release. The same tagged build is validated in UAT (whether it is 
the ephemeral UAT environment or PPE as mentioned in the point above) and then moved to production. 
 
## Deployment Artifacts and Versions

All deployable artifacts that go to production must have a unique tag. There is no exception to this rule. This means that 
the deployment process to production starts with taking a new tag. The same tag, ideally, must be used to create the UAT 
deployable as well. 

On a rare occassion, it might be useful to keep fixing the branch to make the UAT pass and then take a tag to build the 
final production artifact. This is not very recommended since there is a potential for the tagged version of the software
to be different from the tested version. But this is being allowed to make the production deployment process light weight. 

The deployable artifact generated must reflect the tag that was used to make it. has the tag as suffix for its name. For example, price might have an artifact 
with name price-0.0.1.jar where tag name is 0.0.1. This will allow the developers to know the tag that 
generated this deployable.
The generated artifact must support a version end point that can emit the version of the tag. This will allow
an end user to know the version of the current deployable.

## Java Resource Filtering & Generated Artifacts

Gradle and Maven support resource filtering. This means that every resource that is present in src/main/resources is put
through a filter before it gets packaged into the final generated jar file (or WAR or EAR file).

The most common use case for resource filtering is to make variable substitutions in the resource file. For example, if a 
variable called @application.version@ exists in the resource file, then it is substituted with the actual application 
version at the time of generating 

# The Process - Release and Branching Commands

## To release a major or minor version (from master)

Let us say that we decided to release a major or minor version to production. The release needs to be first
tagged and then the build command must be issued.

All major and minor versions are released with patch version as 1. Let us say we want to release 1.0.1 (major 1 ,
minor 0 - as we said patch must always be 1 to begin with)

This should be released from master. First goto the git folder and make sure that we are at the master branch
with the correct changes that need to be tested. Tag the folder using:
```
$ git tag -a -m "1.0.1" 1.0.1
$ git describe --long --dirty
1.0.1
$ gradle clean build
$ <issue the package command for gradle to generate the docker image>
```

Now push the version built to PPE for testing. If PPE cannot be used, set up a UAT environment and use that for testing.
Once the testing is completed successfully, release this to production by using the same docker image.
If there are changes required to make the UAT pass, change the code and commit the code.
Now when the code is built, you will find that the version is no longer 1.0.1 it will be of the form
1.0.1-1-gd789657.dirty instead. This is because the build is issued after modifications are done to the code base after
the tag was taken. Keep changing the code base till all the tests pass.
If the build is tested properly, finally tag the release by incrementing the patch number
```
$ git tag -a -m 1.0.2 1.0.2 # 2 here indicates a patch release
$ gradle clean build
```
This can then be pushed to production after one last round of validation.

## To make a hotfix
Hotfixes are made on a tagged release by making changes to it in a hot fix branch. At the point of making the
hot fix, the master may not be suitable. This is because untested changes have come up in the master. To make
a hot fix, issue the following commands.

```
$ git checkout -b b1.0.2 1.0.2 # this will checkout the tag 1.0.2 to branch b1.0.2
$ <make changes as required>
$ git add .
$ git commit -m ""
$ git tag -a -m 1.0.3 1.0.3
$ gradle clean build

```

# Feature Flags

All feature flags must be standardized into one feature file - features.txt that will be in src/main/resources
This file will be checked into git. At the time of merging the feature branch into master this file might
need to be changed to toggle the feature flags on or off.

All feature flags must be short lived. It is indeed preferable to get rid of them once they are production ready.
Distinction must be made between permanent and temporary feature flags. Temporary feature flags must begin  with
temp- and must be got rid of at the earliest convenient time.

A feature request must be created to get rid of the temp flags in JIRA and must be prioritized once the feature
is main streamed.



