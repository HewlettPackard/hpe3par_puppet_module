# (C) Copyright 2018 Hewlett Packard Enterprise Development LP
# 
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

# = Define: hpe3par::device
#
# Enables the management of a HPE 3PAR Storage System on a Puppet node's device.conf.
#
# This defined type should be used on a proxy node that manages the HPE 3PAR Storage System.
#
# == Parameters:
#
# [*hostname*]
#   The IP or DNS name of the HPE 3PAR Storage System.
#
# [*username*]
#   The username for the HPE 3PAR WSAPI.
#
# [*password*]
#   The password for the HPE 3PAR WSAPI.
define hpe3par::device (
  $hostname,
  $username,
  $password,
  $target = undef,
) {
  validate_string($hostname)
  validate_string($username)
  validate_string($password)

  $device_config = pick($target, $::settings::deviceconfig)

  validate_absolute_path($device_config)

  augeas { "device.conf/${name}":
    lens    => 'Puppet_Device',
    incl    => $device_config,
    context => $device_config,
    changes => [
      "set ${name}/type hpe3par",
      "set ${name}/url https://${username}:${password}@${hostname}:8080",
    ]
  }
}
