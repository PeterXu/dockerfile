FROM chromedp/chromium-builder

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
	&& perl -pi -e 's/us.archive.ubuntu.com/mirrors.ustc.edu.cn/' /etc/apt/sources.list \
	&& apt-get update -y

RUN apt-get install -y neovim

RUN apt-get install -y libc6-i386 lib32gcc1 lib32stdc++6

RUN apt-get install -y lib32z1 lighttpd python-pexpect xvfb x11-utils

RUN apt-get install -y bsdiff

RUN apt-get install -y openjdk-8-jdk

RUN apt-get install -y net-tools

RUN apt-get install -y iputils-ping

RUN apt-get install -y iproute2

RUN rm -rf /depot_tools
