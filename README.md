# Neuvector-scripts
Deploying NeuVector on Red Hat OpenShift is possible with the use of "Operators" where installation/upgradation/modification could be easily controlled, but the other way to deploy NeuVector could be using the legacy manifest file.
In order to upgrade NeuVector cluster on OpenShift, you need some changes in the manifest files and some pre-requisites. This script will help you to upgrade NeuVector cluster hassle-free.

Set/export the required variables:

```
export oc_token=<token-value>
export oc_url=<URL> 
export NV_version=<Mention the version to which NV cluster is to be updated>
export reg=<registry-name:port>   // Mention port if necessary.
```
Note: You can copy the token and url from openshift console under username --> copy login command
