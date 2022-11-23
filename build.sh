#!/bin/sh

flatbuffers_dir="flatbuffers"
schema="schema.fbs"
virtualenv="venv"

setup_venv () {
    # setup virtual environment and install needed python packages
    pip3 install virtualenv

    if ! [ -d $virtualenv ]; then
	echo "setting up virtual environment ..."
	python3 -m virtualenv $virtualenv
    fi

    echo "installing packages"

    . $virtualenv/bin/activate
    pip3 install $flatbuffers_dir/python/
    pip3 install tensorflow
    pip3 install keras
    pip3 install numpy
    pip3 install pillow
}

setup_flatbuffers () {
    if ! [ -d $flatbuffers_dir ]; then
        git submodule update --init flatbuffers
    fi
    cd $flatbuffers_dir
    cmake -G "Unix Makefiles"
    make -j4

    cd ..

    # build schema file
    if ! [ -e $schema ]; then
	mv ../$schema $schema
    fi

    if ! [ -d tflite ]; then
	echo "building tflite schema"
	./$flatbuffers_dir/flatc -p $schema
    fi
}

print_usage () {
    echo "Usage: $0 [all|flatbuffers|venv]"
    echo ""
    echo "Options:"
    echo "  -h, --help   print this message"
}

if [ "$1" = "all" ]; then
    setup_flatbuffers
    setup_venv
else
    case "$1" in
	-h|--help)
	    print_usage
	    exit 0
	    ;;
	flatbuffers)
	    setup_flatbuffers
	    ;;
	venv)
	    setup_venv
	    ;;
	*)
	    print_usage
	    exit 0
	    ;;
    esac
fi

