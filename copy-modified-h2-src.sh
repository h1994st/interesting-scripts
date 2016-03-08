#!/bin/bash

set -e;

function usage()
{
    echo 'USAGE: '$0' <firefox_source_root_dir_path>'
}

if [ $# != 1 ] ; then
    echo 'Too few arguments!'
    usage;
    exit 1;
fi

if [ ! -d $1 ] && [ ! -d $1'/network/protocol/http' ] ; then
    echo 'Invalid path!'
    usage;
    exit 1;
fi

dest_root_dir=$1
dest_http_protocol_dir=$1'/network/protocol/http'

cp mozconfig $dest_root_dir
cp *.cpp *.h moz.build $dest_http_protocol_dir

echo 'Done!'

