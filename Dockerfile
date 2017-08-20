FROM ubuntu:17.04
MAINTAINER Tien Vo <tien.xuan.vo@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

# Add user.
RUN useradd -d /home/selenium -m selenium && \
    chown -R selenium /home/selenium && \
    chgrp -R selenium /home/selenium

# Install applications.
RUN apt-get update -qy && \
    apt-get install -qy --no-install-recommends wget ca-certificates && \
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list && \
    apt-get update -qy && \
    apt-get install -qy --no-install-recommends firefox openjdk-8-jre-headless google-chrome-stable unzip xvfb && \
    sed -i 's|HERE/chrome"|HERE/chrome" --disable-setuid-sandbox --no-sandbox|g' /opt/google/chrome/google-chrome && \
    apt-get -qy autoremove && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get -qy clean

# Download selenium and drivers.
RUN wget -q https://chromedriver.storage.googleapis.com/2.31/chromedriver_linux64.zip -O /home/selenium/chromedriver.zip && \
    unzip /home/selenium/chromedriver.zip -d /home/selenium && \
    chmod 0755 /home/selenium/chromedriver && \
    rm /home/selenium/chromedriver.zip && \
    wget -q https://github.com/mozilla/geckodriver/releases/download/v0.18.0/geckodriver-v0.18.0-linux64.tar.gz -O /home/selenium/geckodriver.tar.gz && \
    tar xfvz /home/selenium/geckodriver.tar.gz -C /home/selenium && \
    chmod 0755 /home/selenium/geckodriver && \
    rm /home/selenium/geckodriver.tar.gz && \
    wget -q http://selenium-release.storage.googleapis.com/3.5/selenium-server-standalone-3.5.1.jar -O /home/selenium/selenium-server-standalone.jar

EXPOSE 4444
USER selenium

CMD xvfb-run java -Dwebdriver.chrome.driver=/home/selenium/chromedriver -Dwebdriver.gecko.driver=/home/selenium/geckodriver -jar /home/selenium/selenium-server-standalone.jar

