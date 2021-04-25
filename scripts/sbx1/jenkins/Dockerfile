#Takes the latest LTS jenkins image and installs docker on it
FROM jenkins/jenkins:lts

USER root
RUN apt-get update -qq \
    && apt-get install -qqy apt-transport-https ca-certificates curl gnupg2 software-properties-common
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

# Copy the jobs into the docker image
COPY /jobs /var/jenkin_home/jobs/

RUN apt-get update  -qq \
    && apt-get install docker-ce=17.12.1~ce-0~debian -y
RUN usermod -aG docker jenkins

RUN apt-get update && \
    apt-get install -y \
        python3 \
        python3-pip \
        python3-setuptools \
        groff \
        less \
    && pip3 install --upgrade pip \
    && apt-get clean

RUN pip3 --no-cache-dir install --upgrade awscli

RUN /usr/local/bin/install-plugins.sh simple-theme-plugin ace-editor ant antisamy-markup-formatter apache-httpcomponents-client-4-api authentication-tokens bouncycastle-api branch-api build-timeout cloudbees-folder command-launcher credentials credentials-binding display-url-api docker-commons docker-workflow durable-task email-ext git git-client git-server github github-api github-branch-source handlebars jackson2-api jquery-detached jsch ldap lockable-resources mailer mapdb-api matrix-auth matrix-project pam-auth pipeline-build-step pipeline-github-lib pipeline-graph-analysis pipeline-input-step pipeline-milestone-step pipeline-model-api pipeline-model-declarative-agent pipeline-model-definition pipeline-model-extensions pipeline-rest-api pipeline-stage-step pipeline-stage-tags-metadata pipeline-stage-view plain-credentials resource-disposer scm-api script-security ssh-credentials ssh-slaves structs subversion timestamper token-macro trilead-api workflow-aggregator workflow-api workflow-basic-steps workflow-cps workflow-cps-global-lib workflow-durable-task-step workflow-job workflow-multibranch workflow-scm-step workflow-step-api workflow-support ws-cleanup github-oauth

ENV JENKINS_USER admin
ENV JENKINS_PASS ccaef7493c2f42f1ac637cf59fa83fc6

# Skip initial setup
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

COPY executors.groovy /usr/share/jenkins/ref/init.groovy.d/
COPY default-user.groovy /usr/share/jenkins/ref/init.groovy.d/
COPY emailsettings.groovy /usr/share/jenkins/ref/init.groovy.d/
