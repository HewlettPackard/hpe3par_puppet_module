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

# This is a sample manifest used for creating vlun

hpe3par_vlun { 'sample_vname' :
  ensure                    => export_volume_to_host,
  volume_name               => 'sample_vname',
  lunid                     => 'sample_lunid',
  host_name                 => 'sample_hname',
  node_val                  => 'sample_node_val',
  slot                      => 'sample_slot',
  card_port                 => 'sample_card_port',
  autolun                   => 'sample_autolun',
  url                       => 'https://username:paswd@host:port'
  }
