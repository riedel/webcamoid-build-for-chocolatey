#!/bin/bash

# Webcamoid, webcam capture application.
# Copyright (C) 2017  Gonzalo Exequiel Pedone
#
# Webcamoid is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Webcamoid is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Webcamoid. If not, see <http://www.gnu.org/licenses/>.
#
# Web-Site: http://webcamoid.github.io/

git clone https://github.com/webcamoid/DeployTools.git

if [ -z "${DISTRO}" ]; then
    distro=${DOCKERIMG#*:}
else
    distro=${DISTRO}
fi

export PATH="${PWD}/.local/bin:${PATH}"
export INSTALL_PREFIX=${PWD}/webcamoid-data-${distro}-${COMPILER}
export PACKAGES_DIR=${PWD}/webcamoid-packages/linux-${distro}-${COMPILER}
export BUILD_PATH=${PWD}/build-${distro}-${COMPILER}
export PYTHONPATH="${PWD}/DeployTools"

cat << EOF > force_plugins_copy.conf
[GStreamer]
haveGStreamer = true

[PipeWire]
havePipeWire = true

[Vlc]
haveVLC = true
EOF

xvfb-run --auto-servernum python3 DeployTools/deploy.py \
    -d "${INSTALL_PREFIX}" \
    -c "${BUILD_PATH}/package_info.conf" \
    -c "${PWD}/force_plugins_copy.conf" \
    -o "${PACKAGES_DIR}"
