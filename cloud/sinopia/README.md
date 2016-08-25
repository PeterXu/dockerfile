sinopia
=======

### install
npm install -g sinopia

### set internel source
npm set registry http://lark.io:4873
npm adduser --registry http://lark.io:4873
npm login
npm publish

### switch private registry
npm install -g nrm
nrm add local http://lark.io:4873 
nrm use local

### switch back:
nrm use npm

### auth




react-native dev
================

### install the latest nodejs
### install android sdk/ndk

### set internel source
npm set registry http://lark.io:4873

### install react-native cli
npm install -g react-native-cli

### use test demo
```
mkdir reactproj 
cd reactproj
react-native init AwesomeProject
cd AwesomeProject
```

### start local services(server:8081)
react-native start

### install apk to android device
react-native run-android

### config server ip/port in android apps
a. 'adb shell input keyevent 82' or shaking the device
b. set ip/port(server:8081) in "Dev Settings/Debug server host for device/go back/reload js"

