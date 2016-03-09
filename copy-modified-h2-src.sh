#!/bin/bash

set -e;

function usage()
{
    echo 'USAGE: '$0' <command> [...]';
    echo '';
    echo 'COMMANDS:';
    echo '    install <src dir path>      Copy files to firefox source code directory';
    echo '    config                      Generate configuration file';
}

if [ $# -lt 1 ] ; then
    echo 'Too few arguments!';
    usage;
    exit 1;
fi

if [ $# -gt 2 ] ; then
    echo 'Too many arguments!';
    usage;
    exit 1;
fi

if [ $1 != 'install' ] && [ $1 != 'config' ] ; then
    echo 'Invalid command!';
    usage;
    exit 1;
fi

if [ $1 = 'install' ] && [ $# -eq 1 ] ; then
    echo 'Too few arguments!';
    usage;
    exit 1;
fi

if [ $1 = 'install' ] && [ $# -eq 2 ] ; then
    dest_root_dir=$2;
    dest_http_protocol_dir=$2'/netwerk/protocol/http/';

    if [ ! -d $dest_root_dir ] || [ ! -d $dest_http_protocol_dir ] ; then
        echo 'Invalid path!';
        usage;
        exit 1;
    fi

    cp mozconfig $dest_root_dir;
    cp *.cpp *.h moz.build $dest_http_protocol_dir;
elif [ $1 = 'config' ] ; then
    cp mozconfig.example mozconfig;
fi

echo 'Done!'
