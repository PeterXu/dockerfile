docker run --name chromium_build --network default \
    -v ~/Workspace/webrtc-android:/webrtc-android \
	-v ~/Workspace/depot_tools_android:/depot_tools \
	-it -d lark.io/cbuild
