FROM ubuntu:17.04
MAINTAINER Tien Vo <tien.xuan.vo@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

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
RUN wget -q https://chromedriver.storage.googleapis.com/2.31/chromedriver_linux64.zip -O /chromedriver.zip && \
    unzip /chromedriver.zip && \
    chmod 0755 /chromedriver && \
    rm /chromedriver.zip && \
    wget -q https://github.com/mozilla/geckodriver/releases/download/v0.18.0/geckodriver-v0.18.0-linux64.tar.gz -O /geckodriver.tar.gz && \
    tar xfvz /geckodriver.tar.gz && \
    chmod 0755 /geckodriver && \
    rm /geckodriver.tar.gz && \
    wget -q http://selenium-release.storage.googleapis.com/3.5/selenium-server-standalone-3.5.2.jar -O /selenium-server-standalone.jar

EXPOSE 4444

CMD xvfb-run -s "-screen 0 1366x768x16" java -Dwebdriver.chrome.driver=/chromedriver -Dwebdriver.gecko.driver=/geckodriver -jar /selenium-server-standalone.jar

