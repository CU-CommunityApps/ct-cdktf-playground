FROM python:3.7

RUN apt-get clean && apt-get update && apt-get -qy upgrade \
    && apt-get -qy install locales tzdata apt-utils software-properties-common build-essential nano jq sudo less \
    && locale-gen en_US.UTF-8 \
    && ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata

RUN curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -Rf ./awscliv2.zip ./aws

# install Terraform using tfenv
RUN mkdir -p /opt/tfenv \
    && git clone https://github.com/tfutils/tfenv.git --branch v2.2.3 /opt/tfenv \
    && ln -s /opt/tfenv/bin/* /usr/bin \
    && which tfenv \
    && tfenv install 1.3.1 \
    && tfenv use 1.3.1 \
    && chmod -R a+w /opt/tfenv/version /opt/tfenv/versions

# Install Node.js, CDKTF, yarn
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && npm install --global cdktf-cli@latest \
    && npm install --global yarn \
    && pip3 install pipenv

# clean up after ourselves, keep image as lean as possible
RUN apt-get remove -qy --purge software-properties-common \
    && apt-get autoclean -qy \
    && apt-get autoremove -qy --purge \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Remove Python 3.9 from /usr/bin. If we leave it, cdktf will use it.
RUN rm /usr/bin/python3*

ARG USER_ID=1000
ARG GROUP_ID=1000
ARG USER_NAME=ec2-user

RUN addgroup --gid $GROUP_ID $USER_NAME \
    && adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID $USER_NAME \
    && echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && usermod --append --groups sudo $USER_NAME

# Setup root
RUN echo "alias tf=terraform" >> /root/.bashrc \
    && mkdir /root/.ssh \
    && ssh-keyscan github.com >> /root/.ssh/known_hosts

# Setup USER
USER $USER_ID
RUN echo "alias tf=terraform" >> ~/.bashrc \
    && mkdir ~/.ssh \
    && ssh-keyscan github.com >> ~/.ssh/known_hosts

CMD [ "/bin/bash" ]
