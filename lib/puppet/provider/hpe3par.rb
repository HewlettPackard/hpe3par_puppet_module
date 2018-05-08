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

require 'puppet/provider'
require_relative '../util/network_device/hpe3par/device'

class Puppet::Provider::HPE3PAR < Puppet::Provider
  attr_accessor :device

  confine :feature => :hpe3parsdk

  def self.transport(args=nil)
    @device ||= Puppet::Util::NetworkDevice.current
    if not @device and Facter.value(:url)
      Puppet.debug "NetworkDevice::HPE3PAR: connecting via facter URL."
      @device ||= Puppet::Util::NetworkDevice::Hpe3par::Device.new(Facter.value(:url))
    elsif not @device and args and args.length == 1
      Puppet.debug "NetworkDevice::HPE3PAR: connecting via URL argument #{args[0]}."
      @device ||= Puppet::Util::NetworkDevice::Hpe3par::Device.new(args[0])
    end
    raise Puppet::Error, "#{self.class} : device not initialized #{caller.join("\n")}" unless @device
    @transport = @device.transport
  end

  def transport(*args)
    # this calls the class instance of self.transport instead of the object
    # instance which causes an infinite loop.
    self.class.transport(args)
  end

  def conn_info
    if resource[:url]
      resource[:url]
    elsif resource[:ssip] and resource[:user] and resource[:password]
      "https://" + resource[:user] + ":" + resource[:password] + "@" +
          resource[:ssip] + ":8080/"
    else
      nil
    end
  end
end