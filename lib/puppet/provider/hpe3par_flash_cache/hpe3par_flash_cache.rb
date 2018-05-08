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

Puppet::Type.type(:hpe3par_flash_cache).provide(:hpe3par_flash_cache,
                                                :parent => Puppet::Provider::HPE3PAR) do
  desc 'Provider implementation for Flash cache.'
  mk_resource_methods

  confine :feature => :hpe3parsdk

  def exists?
    return transport(conn_info).flash_cache_exists?(resource[:debug])
  end

  def create
    begin
      create_flash_cache(resource)
      Puppet.info('Created flash cache successfully')
    rescue Hpe3parSdk::HPE3PARException => ex
      fail(ex.message)
    end

  end

  def destroy
    begin
      transport(conn_info).delete_flash_cache(resource[:debug])
      Puppet.info('Deleted flash cache successfully')
    rescue Hpe3parSdk::HPE3PARException => ex
      fail(ex.message)
    end
  end

  def create_flash_cache(resource)
    transport(conn_info).create_flash_cache(resource[:size_in_gib], resource[:mode], resource[:debug])
  end

end
