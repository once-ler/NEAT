#!/bin/bash

DEBUG=0
BASEDIR=$(cd $(dirname $0); pwd)

elasticsearch_images=( "htaox/elasticsearch:0.90.13")
NAMESERVER_IMAGE="amplab/dnsmasq-precise"

start_shell=0
VOLUME_MAP=""

image_type="?"
image_version="?"
NUM_WORKERS=2

source $BASEDIR/start_nameserver.sh
source $BASEDIR/start_elasticsearch_cluster.sh

function check_root() {
    if [[ "$USER" != "root" ]]; then
        echo "please run as: sudo $0"
        exit 1
    fi
}

function print_help() {
    echo "usage: $0 -i <image> [-w <#workers>] [-v <data_directory>] [-c]"
    echo ""
    echo "  image:    elasticsearch image from:"
    echo -n "               "
    for i in ${elasticsearch_images[@]}; do
        echo -n "  $i"
    done
    echo ""    
}

function parse_options() {
    while getopts "i:w:cv:h" opt; do
        case $opt in
        i)
            echo "$OPTARG" | grep "elasticsearch:" > /dev/null;
	    if [ "$?" -eq 0 ]; then
                image_type="elasticsearch"
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

if [ "$image_type" == "elasticsearch" ]; then
    ELASTICSEARCH_VERSION="$image_version"
    echo "*** Starting elasticsearch $ELASTICSEARCH_VERSION ***"
else
    echo "not starting anything"
    exit 0
fi

start_nameserver $NAMESERVER_IMAGE
wait_for_nameserver

start_master ${image_name}-master $image_version
wait_for_master

start_workers ${image_name}-worker $image_version
sleep 3
echo ""
print_cluster_info