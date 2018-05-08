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

# This is a sample manifest used for creating volumes

  hpe3par_volume { 'sample_volume':
    ensure                    => present,
    cpg                       => 'test_cpg',
    snap_cpg                  => 'sample_snap_cpg',
    type                      => 'sample_type',
    size                      => 'sample_size',
    size_unit                 => 'sample_size_unit',
    compression               => 'sample_compression',
    expiration_hours          => 'sample_expiration_hours',
    retention_hours           => 'sample_retention_hours',
    usr_spc_alloc_warning_pct => 'sample_usr_spc_alloc_warning_pct',
    usr_spc_alloc_limit_pct   => 'sample_usr_spc_alloc_limit_pct',
    ss_spc_alloc_limit_pct    => 'sample_ss_spc_alloc_limit_pct',
    ss_spc_alloc_warning_pct  => 'sample_ss_spc_alloc_warning_pct',
    url                       => 'https://username:paswd@host:port'
    }
