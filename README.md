# Drone plugin for creating maven settings.xml

Purpose of this docker image is to create a maven settings.xml from a few parameters, that specifically for deploying maven artifacts to some maven repository. This image features:
- a settings.xml template, which is rendered using enviroment variables (see below)
- setup for either a single repo, or two repos (snapshots, releases)
- username and password for the above mentioned repos
- optionally setup a single repo as mirroring central as proxy
- setup some properties, so the no pom.xml local deployment config is needed:
  - *performRelease* (false) set it true (e.g. via `mvn deploy -DperformRelease=true`), to also deploy sources and javadoc
  - *deployAtEnd* (true), so artifacts of multi-module projects get only deployed, after all goals passed
  - *altReleaseDeploymentRepository*, so no pom.xml local repository is needed
  - *altSnapshotDeploymentRepository*, see above

To use this image, nothing is needed beside a repository server, of course. The project's pom.xml could be vanilla and does not need to fulfill any requirements:
- No `repositories` or `pluginRepositories` section needed
- No `maven-deploy-plugin` configuration needed
- Just invoke `mvn deploy`

This image uses the following environment variables for rendering the settings.xml
- *MIRROR*: set to `none` to disable mirroring
- *REPO_URL*: Used as a mirror of central, if mirroring is not disabled, and as release and snapshot repo, if the following two variables are not set
- *RELEASES_URL*: Used as release repo
- *SNAPSHOTS_URL*: Used as snapshots repo
- *USERNAME*: Used as the username for accessing both repos
- *PASSWORD*: Used as the password for accessing both repos
