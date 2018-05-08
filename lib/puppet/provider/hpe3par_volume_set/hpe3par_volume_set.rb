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

Puppet::Type.type(:hpe3par_volume_set).provide(:hpe3par_volume_set,
                                        :parent => Puppet::Provider::HPE3PAR) do

  desc 'Provider implementation for Virtual Volume Set.'

  confine :feature => :hpe3parsdk
  mk_resource_methods

  def exists?
    return transport(conn_info).volume_set_exists?(resource[:volume_set_name], resource[:debug])
  end

  def create
    begin
      create_volume_set(resource)
      Puppet.info("Created Volume Set #{name} successfully")
    rescue Hpe3parSdk::HPE3PARException => ex
      fail(ex.message)
    rescue => ex
      fail(ex.message)
    end

  end

  def destroy
    begin
      transport(conn_info).delete_volume_set(resource[:volume_set_name], resource[:debug])
      Puppet.info("Deleted Volume Set #{name} successfully")
    rescue Hpe3parSdk::HPE3PARException => ex
      fail(ex.message)
    rescue => ex
      fail(ex.message)
    end
  end

  def add_volume
    begin 
      set_members = transport(conn_info).get_volume_set(resource[:volume_set_name]).setmembers
      if !set_members.nil?
        new_set_members = resource[:setmembers] - set_members
      else
        new_set_members = resource[:setmembers]
      end
      if !new_set_members.nil? and new_set_members.any?
        transport(conn_info).add_volumes_to_volume_set(resource[:volume_set_name], new_set_members, resource[:debug])
      else
        Puppet.info("No new members to add to the Volume set #{resource[:name]}. Nothing to do.")
      end
    rescue Hpe3parSdk::HPE3PARException => ex
      fail(ex.message)
    rescue => ex
      fail(ex.message)
    end
  end

  def remove_volume
    begin
      set_members = transport(conn_info).get_volume_set(resource[:volume_set_name], resource[:debug]).setmembers
      if set_members != nil
        common_set_members = set_members & resource[:setmembers]
        if !common_set_members.nil? and common_set_members.any?
            transport(conn_info).remove_volumes_from_volume_set(resource[:volume_set_name],
                                           common_set_members, resource[:debug])
        else
          Puppet.info("No members to remove from the Volume set #{resource[:name]}. Nothing to do.")
        end
      else
        Puppet.info("No members to remove from the Volume set #{resource[:name]}. Nothing to do.")
      end
    rescue Hpe3parSdk::HPE3PARException => ex
      fail(ex.message)
    rescue => ex
      fail(ex.message)
    end
  end

  def create_volume_set(resource)
    transport(conn_info).create_volume_set(resource[:volume_set_name], resource[:domain], resource[:setmembers], resource[:debug])
  end

end
