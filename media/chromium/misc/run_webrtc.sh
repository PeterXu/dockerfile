export ALL_PROXY=http://127.0.0.1:8001
export HTTP_PROXY=http://127.0.0.1:8001
export HTTPS_PROXY=http://127.0.0.1:8001
export NO_AUTH_BOTO_CONFIG=~/.depot_tools/.boto 

#step1: cd webrtc/
#fetch --nohooks webrtc

#step2: cd webrtc/src
#gclient sync --with_branch_heads

#step3: cd webrtc/src
#gclient sync
