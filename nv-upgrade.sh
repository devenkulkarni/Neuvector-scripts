#!/bin/bash
oc_token=$1
oc_url=$2
NV_version=$3
reg=$4

if [ -z "$ocToken" ] || [ -z "$ocUrl" ] || [ -z "$version" ]; then
    echo "[### Usage ###] bash upgradeVersion.sh openshift_token openshift_login_url version"
    echo "[### Info ###] You can copy the token and url from openshift console under username --> copy login command"
    echo "[### Info ###] Must have podman and oc in local machine, login should be cluster admin"
    exit 1
fi

# login to oc
oc login --token="$oc_token" --server="$oc_url"
loginStatus=$?
if [ $loginStatus -ne 0 ]; then
    echo "[### Error ###] oc login failed, script stopped"
    exit 1
fi

# pull from docker hub
podman pull neuvector/manager:${NV_version}
podman pull neuvector/controller:${NV_version}
podman pull neuvector/enforcer:${NV_version}

# push to openshift
podman login ${reg} -u cluster-admin -p $(oc whoami -t)

podman tag neuvector/enforcer:${version} ${reg}/neuvector/enforcer:${NV_version}
podman tag neuvector/controller:${version} ${reg}/neuvector/controller:${NV_version}
podman tag neuvector/manager:${version} ${reg}/neuvector/manager:${NV_version}

podman push ${HOST}/neuvector/enforcer:${NV_version}
podman push ${HOST}/neuvector/controller:${NV_version}
podman push ${HOST}/neuvector/manager:${NV_version}

# perform image update and rolling restart
oc project neuvector

oc set image DaemonSet/neuvector-enforcer-pod neuvector-enforcer-pod=${reg}/neuvector/enforcer:${NV_version} -n neuvector
oc set image Deployment/neuvector-controller-pod neuvector-controller-pod=${reg}/neuvector/controller:${NV_version} -n neuvector
oc set image Deployment/neuvector-manager-pod neuvector-manager-pod=${reg}/neuvector/manager:${NV_version} -n neuvector

# logout
podman logout ${reg}
oc logout
