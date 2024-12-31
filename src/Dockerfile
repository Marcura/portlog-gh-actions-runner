FROM myoung34/github-runner:latest

# install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# install OpenTofu 1.8.7
RUN curl -sSL https://github.com/opentofu/opentofu/releases/download/v1.8.7/tofu_1.8.7_linux_amd64.tar.gz -o /tmp/tofu.tar.gz
RUN tar -xzf /tmp/tofu.tar.gz -C /tmp
RUN mv /tmp/tofu /usr/local/bin/tofu
RUN chmod +x /usr/local/bin/tofu
RUN tofu --version  # Verify the installation

# Install Maven
RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
 && curl -fsSL -o /tmp/apache-maven.tar.gz https://dlcdn.apache.org/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.tar.gz \
 && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
 && rm -f /tmp/apache-maven.tar.gz \
 && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME="/usr/share/maven"
ENV MAVEN_CONFIG="$USER_HOME_DIR/.m2"