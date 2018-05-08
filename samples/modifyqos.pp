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

## This is a sample manifest used for modify qos

hpe3par_qos { 'sample_volume_set' :
  bwmin_goal_kb          =>  200,
  bwmax_limit_kb         =>  200,
  iomin_goal             =>  100 ,
  bwmin_goal_op          => 'NOLIMIT',
  iomin_goal_op          => 'NOLIMIT',
  iomax_limit_op         => 'NOLIMIT',
  iomax_limit            =>  100,
  bwmax_limit_op         => 'NOLIMIT',
  enable                 =>  true,
  priority               => 'HIGH',
  url                    => 'https://username:paswd@host:port',
  ensure                 =>  modify
}
