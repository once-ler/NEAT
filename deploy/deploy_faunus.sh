#!/bin/bash

DEBUG=0
BASEDIR=$(cd $(dirname $0); pwd)

faunus_images=( "htaox/faunus:0.4.4")
NAMESERVER_IMAGE="amplab/dnsmasq-precise"

start_shell=0
VOLUME_MAP=""

image_type="?"
image_version="?"
NUM_WORKERS=2

# source $BASEDIR/start_nameserver.sh
source $BASEDIR/start_faunus_cluster.sh

function check_root() {
    if [[ "$USER" != "root" ]]; then
        echo "please run as: sudo $0"
        exit 1
    fi
}

function print_help() {
    echo "usage: $0 -i <image> [-w <#workers>] [-v <data_directory>] [-c]"
    echo ""
    echo "  image:    faunus image from:"
    echo -n "               "
    for i in ${faunus_images[@]}; do
        echo -n "  $i"
    done
    echo ""    
}

function parse_options() {
    while getopts "i:w:cv:h" opt; do
        case $opt in
        i)
            echo "$OPTARG" | grep "faunus:" > /dev/null;
	    if [ "$?" -eq 0 ]; then
                image_type="faunus"
            fi            
	    image_name=$(echo "$OPTARG" | awk -F ":" '{print $1}')
            image_version=$(echo "$OPTARG" | awk -F ":" '{print $2}') 
          ;;
        w)
            NUM_WORKERS=$OPTARG
          ;;
        h)
            print_help
            exit 0
          ;;
        c)
            start_shell=1
          ;;
        v)
            VOLUME_MAP=$OPTARG
          ;;
        esac
    done

    if [ "$image_type" == "?" ]; then
        echo "missing or invalid option: -i <image>"
        exit 1
    fi

    if [ ! "$VOLUME_MAP" == "" ]; then
        echo "data volume chosen: $VOLUME_MAP"
        VOLUME_MAP="-v $VOLUME_MAP:/data"
    fi
}

check_root

if [[ "$#" -eq 0 ]]; then
    print_help
    exit 1
fi

parse_options $@

if [ "$image_type" == "faunus" ]; then
    faunus_VERSION="$image_version"
    echo "*** Starting faunus $faunus_VERSION ***"
else
    echo "not starting anything"
    exit 0
fi

# start_nameserver $NAMESERVER_IMAGE
# wait_for_nameserver

# The nameserver should be the one used for the HBase cluster
NAMESERVER_IP=172.17.0.2

start_master ${image_name}-master $image_version
wait_for_master

start_workers ${image_name}-worker $image_version
echo ""
print_cluster_info
#After all the servers are up, we can start the services in sequence
start_faunus
