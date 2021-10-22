#!/bin/sh
# netbeans.sh - starts the Apache NetBeans IDE
# Copyright 2021 John Neffenger
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

# Starts NetBeans
netbeans () {
    "$SNAP/netbeans/bin/netbeans" "$@"
}

# Location of the JDK in the OpenJDK Snap package
snapjdk=$SNAP/../../openjdk/current/jdk

# Uses JAVA_HOME if set; otherwise, OpenJDK Snap if installed
if [ -n "$JAVA_HOME" ]; then
    netbeans --jdkhome "$JAVA_HOME" "$@"
elif [ -d "$snapjdk" ]; then
    netbeans --jdkhome "$snapjdk" "$@"
else
    netbeans "$@"
fi
