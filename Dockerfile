FROM openshift/golang-builder:v1.21.7-202403061534.el9.gab74a9a.el9

# Konflux specific steps
RUN mkdir -p /tmp/yum_temp; mv /etc/yum.repos.d/*.repo /tmp/yum_temp/
COPY cp .oit/signed.repo /etc/yum.repos.d
RUN cp /tmp/yum_temp/* /etc/yum.repos.d/*

ENV __doozer=update BUILD_RELEASE=202404050838.p0.g8f7ac0f.assembly.test.el9 BUILD_VERSION=v0.0.0 CI_RPM_SVC=base-4-16-rhel9.ocp.svc OS_GIT_MAJOR=0 OS_GIT_MINOR=0 OS_GIT_PATCH=0 OS_GIT_TREE_STATE=clean OS_GIT_VERSION=0.0.0-202404050838.p0.g8f7ac0f.assembly.test.el9 SOURCE_GIT_TREE_STATE=clean __doozer_group=openshift-4.16 __doozer_key=ci-openshift-golang-builder-latest.rhel9 __doozer_version=v0.0.0 
ENV __doozer=merge OS_GIT_COMMIT=8f7ac0f OS_GIT_VERSION=0.0.0-202404050838.p0.g8f7ac0f.assembly.test.el9-8f7ac0f SOURCE_DATE_EPOCH=1712916536 SOURCE_GIT_COMMIT=8f7ac0f8825d4f74662d57d569bf56ef2379d168 SOURCE_GIT_TAG=openshift-4.0-archived-3180-g8f7ac0f8 SOURCE_GIT_URL=https://github.com/openshift-eng/ocp-build-data 

# Used by builds scripts to detect whether they are running in the context
# of OpenShift CI or elsewhere (e.g. brew).
ENV OPENSHIFT_CI="true"

ENV GOARM=5 \
    LOGNAME=deadbeef \
    GOCACHE=/go/.cache \
    GOPATH=/go \
    LOGNAME=deadbeef
ENV PATH=$PATH:$GOPATH/bin

# make go related directories writeable since builds in CI will run as non-root.
RUN mkdir -p $GOPATH && \
    chmod g+xw -R $GOPATH && \
    chmod g+xw -R $(go env GOROOT)

# Ensure that repo files can be written by non-root users at runtime so that repos
# can be resolved on build farms and written into yum.repos.d.
RUN chmod 777 /etc/yum.repos.d/

# Install the dnf/yum wrapper that will work for CI workloads.
ENV DNF_WRAPPER_DIR=/bin/dnf_wrapper
ADD ci_images/dnf_wrapper.sh /tmp
ADD ci_images/install_dnf_wrapper.sh /tmp
RUN chmod +x /tmp/*.sh && \
    /tmp/install_dnf_wrapper.sh
# Ensure dnf wrapper scripts appear before anything else in the $PATH
ENV PATH=$DNF_WRAPPER_DIR:$PATH
# Add the doozer repos so that someone connected to the VPN can use those
# repositories. The dnf_wrapper will enable these repos if it detects
# it is not running on a build farm.
ADD .oit/unsigned.repo $DNF_WRAPPER_DIR/

LABEL \
        io.k8s.description="golang 1.21 builder image for Red Hat CI" \
        name="openshift/ci-openshift-golang-builder-latest-rhel9" \
        com.redhat.component="ci-openshift-golang-builder-latest-container" \
        io.openshift.maintainer.project="OCPBUGS" \
        io.openshift.maintainer.component="Release" \
        release="202404050838.p0.g8f7ac0f.assembly.test.el9" \
        io.openshift.build.commit.id="8f7ac0f8825d4f74662d57d569bf56ef2379d168" \
        io.openshift.build.source-location="https://github.com/openshift-eng/ocp-build-data" \
        io.openshift.build.commit.url="https://github.com/openshift-eng/ocp-build-data/commit/8f7ac0f8825d4f74662d57d569bf56ef2379d168" \
        version="v0.0.0"

