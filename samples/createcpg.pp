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

# This is a sample manifest used for creating cpg

 hpe3par_cpg { 'sample_cname' :
   ensure                    => present,
   domain                    => 'sample_domain',
   growth_increment          => 'sample_growth_increment',
   growth_increment_unit     => 'sample_growth_increment_unit',
   growth_limit              => 'sample_growth_limit',
   growth_limit_unit         => 'sample_growth_limit_unit',
   growth_warning            => 'sample_growth_warning',
   growth_warning_unit       => 'sample_growth_warning_unit',
   raid_type                 => 'sample_raid_type',
   set_size                  => 'sample_set_size',
   high_availability         => 'sample_high_availability',
   disk_type                 => 'sample_disk_type',
   url                       => 'https://username:paswd@host:port'
   }
