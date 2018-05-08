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

require 'puppet/util/network_device'
require_relative '../hpe3par'
require_relative 'facts'
require_relative '../../hpe3par_api'


class Puppet::Util::NetworkDevice::Hpe3par::Device

  attr_accessor :transport

  def initialize(url, options = {})
    @transport = HPE3PAR_API.new(url)
    Puppet.debug("Initializing HPE 3PAR Device : #{url}")
  end

  def facts
    Puppet.debug("#{self.class}.facts: connecting to HPE 3PAR device
                 #{@transport.url.host}")
    @facts ||= Puppet::Util::NetworkDevice::Hpe3par::Facts.new(@transport)
    device_facts = @facts.retrieve
    device_facts
  end

end