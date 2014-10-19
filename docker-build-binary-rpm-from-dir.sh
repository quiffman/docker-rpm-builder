#!/bin/bash

function abspath() { pushd . > /dev/null; if [ -d "$1" ]; then cd "$1"; dirs -l +0; else cd "`dirname \"$1\"`"; cur_dir=`dirs -l +0`; if [ "$cur_dir" == "/" ]; then echo "$cur_dir`basename \"$1\"`"; else echo "$cur_dir/`basename \"$1\"`"; fi; fi; popd > /dev/null; }

set -e
USAGE="Usage:\n$0 IMAGETAG SRCDIR <...additional docker options..>\n"
IMAGETAG=$1
[ -n "$1" ] || { echo "ERROR: Missing IMAGETAG param" ; echo -e $USAGE ; exit 1 ;}
shift 1
SRCDIR=$1
[[ -n "$1" && -d $1 && -r $1 && -x $1 && -w $1 ]] || { echo "ERROR: Missing SRCDIR or wrong permissions - must be an rwx directory" ; echo -e $USAGE ; exit 1 ;}
shift 1
SRCDIR=$(abspath ${SRCDIR})
echo "Now building project from $SRCDIR on image $IMAGETAG"

CURRENTDIR=$(dirname $(abspath $0))

docker run $* -v ${CURRENTDIR}/docker-scripts:/docker-scripts -v ${SRCDIR}:/src -w /docker-scripts ${IMAGETAG} ./rpmbuild-in-docker.sh $(id -u):$(id -g)
