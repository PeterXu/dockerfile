FROM chromedp/chromium-builder

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
	&& perl -pi -e 's/us.archive.ubuntu.com/archive.ubuntu.com/' /etc/apt/sources.list \
	&& apt-get update -y

RUN apt-get install -y neovim

RUN apt-get install -y libc6-i386 lib32gcc1 lib32stdc++6

RUN rm -rf /depot_tools
