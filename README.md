# Drone plugin for creating maven settings.xml

Purpose of this docker image is to create a maven settings.xml from a few parameters, that specifically for deploying maven artifacts to some maven repository. This image features:
- A settings.xml template, which is rendered using enviroment variables (see below) to the local workspace, so no extra volume is necessary for allowing persistent access over multiple drone steps
- Appends `--settings` parameters to `.mvn/maven.config`, so no additional command line parameter is necessary, when invoking maven
- Strips drone plugin environments variables prefixed with *PLUGIN_*, so simple drone plugin settings could be used (see below for example)
- Setup for either a single repo, or two repos (snapshots, releases)
- username and password for the above mentioned repos
- Optionally setup a single repo as mirroring central as proxy
- setup some properties, so the no pom.xml local deployment config is needed:
  - *performRelease* (false) set it true (e.g. via `mvn deploy -DperformRelease`), to also deploy sources and javadoc
  - *deployAtEnd* (true), so artifacts of multi-module projects get only deployed, after all goals passed
  - *altReleaseDeploymentRepository*, so no pom.xml local repository is needed
  - *altSnapshotDeploymentRepository*, see above

To use this image, nothing is needed beside a repository server, of course. The project's pom.xml could be vanilla and does not need to fulfill any requirements:
- No `repositories` or `pluginRepositories` section needed
- No `maven-deploy-plugin` configuration needed
- Just invoke `mvn deploy`

This image uses the following environment variables for rendering the settings.xml
- *OUTPUT*: changes the output directory and file name of the settings.xml, defaults to `.mvn/release-settings.xml`, which is in the defaulting case also appended to `.mvn/maven.config`
- *MIRROR*: set to `none` to disable mirroring
- *REPO_URL*: Used as a mirror of central, if mirroring is not disabled, and as release and snapshot repo, if the following two variables are not set
- *RELEASES_URL*: Used as release repo
- *SNAPSHOTS_URL*: Used as snapshots repo
- *USERNAME*: Used as the username for accessing both repos
- *PASSWORD*: Used as the password for accessing both repos
- *LOCAL_CACHE*: Used to change the local maven repository, defaults to `${user.home}/.m2/repository`otherwise

Invoke either from command line via:
`docker run --rm -eREPO_URL=http://myrepo -eUSERNAME=xxx -ePASSWORD=xxx kamalook/drone-maven-settings`
where the settings.xml is rendered to stdout or use via drone.

A possible *.drone.yml* could look like:
```
kind: pipeline
name: default

steps:
  - name: init maven
    image: kamalook/drone-maven-settings
    settings:
      releases_url: { from_secret: repo-releases }
      snapshots_url: { from_secret: repo-snapshots }
      username: { from_secret: repo-username }
      password: { from_secret: repo-password }
      mirror: none
  - name: build
    image: maven:3-jdk-11-slim
    commands: [mvn -B -V deploy -DperformRelease]
```
