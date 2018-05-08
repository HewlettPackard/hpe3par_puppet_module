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

# This is a sample manifest used for creating hosts

hpe3par_host { 'sample_hname' :
    ensure                    => present,
    host_name                 => 'sample_hname,'
    domain                    => 'sample_domain',
    fc_wwns                   => 'sample_fc_wwn',
    iscsi_names               => 'sample_iscsi_names',
    persona                   => 'sample_persona',
    url                       => 'https://username:paswd@host:port'
  }
