export ALL_PROXY=http://127.0.0.1:8001
export HTTP_PROXY=http://127.0.0.1:8001
export NO_AUTH_BOTO_CONFIG=/depot_tools/.boto

# step0: cd chromium/
#fetch --nohooks chromium

# step1: cd chromium/src
#gclient sync

# step2: cd chromium/src
#gclient runhooks
