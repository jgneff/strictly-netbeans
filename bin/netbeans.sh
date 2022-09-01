#!/bin/sh
# netbeans.sh - starts the Apache NetBeans IDE
# Copyright 2021-2022 John Neffenger
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
set -o errexit

# Checks for required environment variables
: "${SNAP:?}"
: "${SNAP_USER_DATA:?}"
: "${SNAP_USER_COMMON:?}"
: "${SNAP_VERSION:?}"

# Starts NetBeans
netbeans () {
    "$SNAP/netbeans/bin/netbeans" \
        --userdir "$SNAP_USER_DATA/$SNAP_VERSION" \
        --cachedir "$SNAP_USER_COMMON/$SNAP_VERSION" "$@"
}

# Creates the Maven user settings file if not found
if [ ! -e "$SNAP_USER_COMMON/settings.xml" ]; then
    cp "$SNAP/conf/settings-user.xml" "$SNAP_USER_COMMON/settings.xml"
fi

# Uses JAVA_HOME if set; otherwise, uses OpenJDK Snap if connected
if [ -n "$JAVA_HOME" ]; then
    netbeans --jdkhome "$JAVA_HOME" "$@"
elif [ -d "$SNAP/jdk" ]; then
    netbeans --jdkhome "$SNAP/jdk" "$@"
else
    netbeans "$@"
fi
