FROM myoung34/github-runner:latest

# install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# install OpenTofu 1.8.7
RUN curl -sSL https://github.com/opentofu/opentofu/releases/download/v1.8.7/tofu_1.8.7_linux_amd64.tar.gz -o /tmp/tofu.tar.gz
RUN tar -xzf /tmp/tofu.tar.gz -C /tmp
RUN mv /tmp/tofu /usr/local/bin/tofu
RUN chmod +x /usr/local/bin/tofu
RUN tofu --version  # Verify the installation