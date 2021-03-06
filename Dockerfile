FROM ubuntu:16.04
MAINTAINER Rafał Dziuryk <rafaldziuryk@gmail.com>

ENV ANDROID_COMPILE_SDK: 25
ENV ANDROID_BUILD_TOOLS: 25.0.3
ENV ANDROID_SDK_TOOLS_REV: 3859397  # "26.0.1"

# Install java8
RUN apt update && \
    apt install -y wget && \
    apt install -y software-properties-common && \
    add-apt-repository -y ppa:webupd8team/java && \
    (echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections) && \
    apt update && \
    apt install -y oracle-java8-installer && \
    apt clean && rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
# Install Android SDK
RUN mkdir $HOME/.android && \
    echo 'count=0' > $HOME/.android/repositories.cfg}

# Install Deps
RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y --force-yes expect git wget unzip && apt-get clean && rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN wget --output-document=android-sdk.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip && \
     mkdir $PWD/android-sdk-linux && \
     unzip -qq android-sdk.zip -d $PWD/android-sdk-linux && \
     export ANDROID_HOME=$PWD/android-sdk-linux && \
     export PATH=$PATH:$ANDROID_HOME/platform-tools/ && \
     echo y | $ANDROID_HOME/tools/bin/sdkmanager --update  && \
     echo y | $ANDROID_HOME/tools/bin/sdkmanager 'tools' && \
     echo y | $ANDROID_HOME/tools/bin/sdkmanager 'platform-tools' && \
     echo y | $ANDROID_HOME/tools/bin/sdkmanager 'build-tools;'$ANDROID_BUILD_TOOLS && \
     echo y | $ANDROID_HOME/tools/bin/sdkmanager 'platforms;android-'$ANDROID_COMPILE_SDK && \
     echo y | $ANDROID_HOME/tools/bin/sdkmanager 'extras;android;m2repository' && \
     echo y | $ANDROID_HOME/tools/bin/sdkmanager 'extras;google;google_play_services' && \
     echo y | $ANDROID_HOME/tools/bin/sdkmanager 'extras;google;m2repository' && \
     echo y | $ANDROID_HOME/tools/bin/sdkmanager 'cmake;'$ANDROID_CMAKE_REV && \
     chmod +x ./gradlew

# Copy install tools
COPY tools /opt/tools
ENV PATH ${PATH}:/opt/tools

# Cleaning
RUN apt clean

# GO to workspace
RUN mkdir -p /opt/workspace
WORKDIR /opt/workspace
