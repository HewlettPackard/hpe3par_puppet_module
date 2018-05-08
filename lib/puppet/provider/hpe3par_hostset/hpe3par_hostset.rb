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
if Puppet.features.hpe3parsdk?
  require 'Hpe3parSdk'
  require 'Hpe3parSdk/exceptions'
end

Puppet::Type.type(:hpe3par_hostset).provide(:hpe3par_hostset,
                                        :parent => Puppet::Provider::HPE3PAR) do

  desc 'Provider implementation for Host set.'
  mk_resource_methods
  
  confine :feature => :hpe3parsdk

  def exists?
    return transport(conn_info).hostset_exists?(resource[:name], resource[:debug])
  end

  def create
    begin
      transport(conn_info).create_host_set(resource[:name], resource[:domain], resource[:setmembers], resource[:debug])
      Puppet.info("Created Host Set #{name} successfully")
    rescue Hpe3parSdk::HPE3PARException => ex
      fail(ex.message)
    end

  end

  def destroy
    begin
      transport(conn_info).delete_host_set(resource[:name], resource[:debug])
      Puppet.info("Deleted Host Set #{name} successfully")
    rescue Hpe3parSdk::HPE3PARException => ex
      fail(ex.message)
    end
  end
  
  def add_host
    begin
      transport(conn_info).add_hosts_to_host_set(resource[:name], resource[:setmembers], resource[:debug])
      Puppet.info("Added hosts to Host Set #{name} successfully")
    rescue Hpe3parSdk::HPE3PARException => ex
      fail(ex.message)
    end
  end
  
  def remove_host
    begin
      transport(conn_info).remove_hosts_from_host_set(resource[:name], resource[:setmembers], resource[:debug])
      Puppet.info("Removed hosts from Host Set #{name} successfully")
    rescue Hpe3parSdk::HPE3PARException => ex
      fail(ex.message)
    end
  end
end
