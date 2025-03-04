#!/bin/bash
#
# Copyright (C) 2007 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Set up prog to be the path of this script, including following symlinks,
# and set up progdir to be the fully-qualified pathname of its directory.

prog="$0"
while [ -h "${prog}" ]; do
    fullprog=`/bin/ls -ld "${prog}"`
    fullprog=`expr "${fullprog}" : ".* -> \(.*\)$"`
    if expr "x${fullprog}" : 'x/' >/dev/null; then
        prog="${fullprog}"
    else
        progdir=`dirname "${prog}"`
        prog="${progdir}/${fullprog}"
    fi
done

oldwd=`pwd`
progdir=`dirname "${prog}"`
cd "${progdir}"
progdir=`pwd`
prog="${progdir}"/`basename "${prog}"`
cd "${oldwd}"

jarfile=`basename "${prog}"`.jar
jardir="${progdir}"

if [ ! -r "${jardir}/${jarfile}" ]; then
    jardir=`dirname "${progdir}"`/framework
fi

if [ ! -r "${jardir}/${jarfile}" ]; then
    echo `basename "${prog}"`": can't find ${jarfile}"
    exit 1
fi

declare -a javaOpts=()
while expr "x$1" : 'x-J' >/dev/null; do
    opt=`expr "$1" : '-J-\{0,1\}\(.*\)'`
    javaOpts+=("-${opt}")
    shift
done

exec java "${javaOpts[@]}" -jar ${jardir}/${jarfile} "$@"
