# This is a base image that most rhel9-based containers should layer on.
FROM brew.registry.redhat.io/rh-osbs/rhel-els@sha256:cf1bc434a99f7fc6993ad728cbceb72528f031d0c93ea3d183f55728710c6c76

# Start Konflux-specific steps
RUN mkdir -p /tmp/yum_temp; mv /etc/yum.repos.d/*.repo /tmp/yum_temp/
COPY .oit/signed.repo /etc/yum.repos.d/
# End Konflux-specific steps
ENV __doozer=update BUILD_RELEASE=202404220949.p0.gb45ea65.assembly.test.el9 BUILD_VERSION=v0.0.0 OS_GIT_MAJOR=0 OS_GIT_MINOR=0 OS_GIT_PATCH=0 OS_GIT_TREE_STATE=clean OS_GIT_VERSION=0.0.0-202404220949.p0.gb45ea65.assembly.test.el9 SOURCE_GIT_TREE_STATE=clean __doozer_group=openshift-4.17 __doozer_key=openshift-base-rhel9 __doozer_version=v0.0.0 
ENV __doozer=merge OS_GIT_COMMIT=b45ea65 OS_GIT_VERSION=0.0.0-202404220949.p0.gb45ea65.assembly.test.el9-b45ea65 SOURCE_DATE_EPOCH=1654869156 SOURCE_GIT_COMMIT=b45ea65bf6606c558b1a18b92ad878f42a411894 SOURCE_GIT_TAG=b45ea65b SOURCE_GIT_URL=https://github.com/openshift-eng/ocp-build-data 
# we pin to a RHEL EUS (rhel-els) stream for stability.
# rhel9-els from rhel-els-container(https://brewweb.engineering.redhat.com/brew/packageinfo?packageID=77439)

RUN echo 'skip_missing_names_on_install=0' >> /etc/yum.conf \
 && yum update -y  \
 && yum clean all

# EUS / ELS images do not have repositories configured, and anyway they would
# not be publicly accessible without an enabled subscription. Insert public
# ubi9 repos in the base image so the end user can update all images easily.
COPY ubi.repo /etc/yum.repos.d/ubi.repo

LABEL \
        name="openshift/base-rhel9" \
        com.redhat.component="openshift-base-rhel9-container" \
        io.openshift.maintainer.project="OCPBUGS" \
        io.openshift.maintainer.component="Release" \
        release="202404220949.p0.gb45ea65.assembly.test.el9" \
        io.openshift.build.commit.id="b45ea65bf6606c558b1a18b92ad878f42a411894" \
        io.openshift.build.source-location="https://github.com/openshift-eng/ocp-build-data" \
        io.openshift.build.commit.url="https://github.com/openshift-eng/ocp-build-data/commit/b45ea65bf6606c558b1a18b92ad878f42a411894" \
        version="v0.0.0"


# Start Konflux-specific steps
RUN cp /tmp/yum_temp/* /etc/yum.repos.d/
# End Konflux-specific steps
