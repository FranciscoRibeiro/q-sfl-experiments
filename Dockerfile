FROM maven:3-jdk-7

ARG USER_ID
ARG GROUP_ID

RUN addgroup --gid $GROUP_ID user
RUN adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID user

RUN \
    apt-get update && \
    apt-get install -y wget python3-pip python3-yaml git subversion libdbi-perl && \
    rm -rf /var/lib/apt/lists/*

RUN \
    wget https://github.com/rjust/defects4j/archive/refs/tags/v2.0.0.tar.gz && \
    tar xf v2.0.0.tar.gz && \
    cd defects4j-2.0.0 && \
    ./init.sh

ENV PATH="/defects4j-2.0.0/framework/bin/:${PATH}"
ENV TZ="America/Los_Angeles"

COPY q-sfl/ /q-sfl/
RUN \
    cd /q-sfl/ && \
    mvn -q package

RUN mkdir /data
RUN chown user /data

WORKDIR /home/
RUN chown user /home
COPY scripts/run_experiment.py /home/
COPY experiment.yml /home/

USER user
CMD ["bash"]
