docker run --name chromium_build --network host \
	-v /media/mdisk/chromium_store/chromium:/chromium \
	-v /home/peter/.depot_tools:/depot_tools \
	-t -d lark.io/cbuild
