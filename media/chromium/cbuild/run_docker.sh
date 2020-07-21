docker run --name chromium_build --network host \
    -v ~/Workspace/webrtc-android:/webrtc-android \
	-v ~/.depot_tools:/depot_tools \
	-it -d lark.io/cbuild
