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

Puppet::Type.type(:hpe3par_snapshot).provide(:hpe3par_snapshot,
                                        :parent => Puppet::Provider::HPE3PAR) do

  desc 'Provider implementation for Snapshot.'
  mk_resource_methods
  
  confine :feature => :hpe3parsdk

  def exists?
    return transport(conn_info).volume_exists?(resource[:name], resource[:debug])
  end

  def create
    begin
      transport(conn_info).create_snapshot(resource[:name], resource[:base_volume_name], resource[:read_only], resource[:expiration_time], resource[:retention_time], resource[:expiration_unit], resource[:retention_unit], resource[:debug])

      Puppet.info("Created Snapshot #{resource[:name]} of parent #{resource[:base_volume_name]} successfully")
    rescue Hpe3parSdk::HPE3PARException => ex
      fail(ex.message)
    end

  end

  def destroy
    begin
      transport(conn_info).delete_snapshot(resource[:name], resource[:debug])
      Puppet.info("Deleted Snapshot #{resource[:name]} successfully")
    rescue Hpe3parSdk::HPE3PARException => ex
      fail(ex.message)
    end
  end
  
  def modify
    begin
      transport(conn_info).modify_snapshot(resource[:name], resource[:new_name], resource[:expiration_hours], resource[:retention_hours], resource[:rm_exp_time], resource[:debug])
      Puppet.info("Modified Snapshot #{resource[:name]} successfully")
    rescue Hpe3parSdk::HPE3PARException => ex
      fail(ex.message)
    end
  end
  
  def restore_offline
    begin
      transport(conn_info).restore_snapshot_offline(resource[:name], resource[:priority],resource[:allow_remote_copy_parent], resource[:debug])
      Puppet.info("Restored Snapshot #{resource[:name]} offline successfully")
    rescue Hpe3parSdk::HPE3PARException => ex
      fail(ex.message)
    end
  end
  
  def restore_online
    begin
      transport(conn_info).restore_snapshot_online(resource[:name], resource[:allow_remote_copy_parent], resource[:debug])
      Puppet.info("Restored Snapshot #{resource[:name]} online successfully")
    rescue Hpe3parSdk::HPE3PARException => ex
      fail(ex.message)
    end
  end
end
