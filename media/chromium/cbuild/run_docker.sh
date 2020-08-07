docker run --name chromium_build --network default \
    -v ~/Workspace:/Workspace \
    -v ~/.depot_tools2:/depot_tools \
    -it -d lark.io/cbuild
