#!/bin/bash
set -e


export HOME=/opt
export WORKSPACE=$HOME/openfalcon
mkdir -p $WORKSPACE
#rm -rf $WORKSPACE/*

fmod_name(){
    [ $# -eq 1 ] && str=${1#*-} && echo ${str%%-*}
}

modules=""
fmod_list() {
    pkgpath="files"
    rm -f $pkgpath/*.tar.gz
    pkg=/tmp/of-release-v0.1.0.tar.gz
    [ ! -f $pkg ] && echo "[ERROR] no open-falcon pkg: $pkg" && exit 1
    tar xf $pkg -C $pkgpath
    modules="$(ls $pkgpath/*.tar.gz)"
}

fmod_bin() {
    for mod in $modules; do
        name=$(fmod_name $mod)
        [ "$name" = "" ] && echo "[WARN] no valid mod: $mod" && exit 1
        mkdir -p $WORKSPACE/$name
        tar xf $mod -C $WORKSPACE/$name
    done
}

fmod_conf() {
    for mod in $modules; do
        mpath="$WORKSPACE/$(fmod_name $mod)"
        [ -f $mpath/cfg.example.json ] && cp -n $mpath/cfg.example.json $mpath/cfg.json
    done
}


# decompress falcon
fmod_list

# decompress modules
fmod_bin

# default config 
fmod_conf


exit 0
