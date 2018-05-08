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

require_relative '../hpe3par'

class Puppet::Util::NetworkDevice::Hpe3par::Facts

  attr_reader :transport

  def initialize(transport)
    @transport = transport
  end

  def retrieve
    Puppet.debug("Retrieving Facts from device #{@url}")
    @facts = {}
    @facts[:storage_system] = @transport.get_storage_system_info
    @facts
  end
end
