#!/usr/bin/env python

# Copyright 1996-2020 Cyberbotics Ltd.
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

"""This launcher simply start Webots."""

import optparse
import os
import sys
import subprocess

optParser = optparse.OptionParser()
optParser.add_option("--world", dest="world", default="", help="Path to the world to load.")
optParser.add_option("--mode", dest="mode", default="realtime", help="Startup mode.")
optParser.add_option("--no-gui", dest="noGui", default="false", help="Start Webots with minimal GUI.")
optParser.add_option("--stream", dest="stream", default="false", help="Start Webots streaming server.")
options, args = optParser.parse_args()

if 'WEBOTS_HOME' not in os.environ:
    sys.exit('WEBOTS_HOME environment variable not defined.')

# run webots with Xvfb if no display is available
if 'DISPLAY' not in os.environ:
    if 'XVFB_RUN' in os.environ:
        command = [os.environ['XVFB_RUN'], '-a']
    else:
        command = ['xvfb-run', '-a']
else:
    command = []
# command = [os.path.join(os.environ['WEBOTS_HOME'], 'webots'), '--mode=' + options.mode, options.world]
command.append(os.path.join(os.environ['WEBOTS_HOME'], 'webots'))
command.append('--mode=' + options.mode)
command.append(options.world)

if options.stream.lower() != 'false':
    if options.stream.lower() == 'true':
        command.append('--stream="port=1234;mode=x3d;monitorActivity"')
    else:
        command.append('--stream="' + options.stream + '"')

if options.noGui.lower() == 'true':
    command.append('--stdout')
    command.append('--stderr')
    command.append('--batch')
    command.append('--no-sandbox')
    command.append('--minimize')
    command.append('--no-rendering')

print(command)
subprocess.call(command)
