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

Puppet::Type.type(:hpe3par_offline_clone).provide(:hpe3par_offline_clone,
                                        :parent => Puppet::Provider::HPE3PAR) do
  desc 'Provider implementation for Offline clone.'
  mk_resource_methods
 
  confine :feature => :hpe3parsdk
 
  def exists?
    if resource[:ensure].to_s == 'present'
      begin
        if transport(conn_info).volume_exists?(resource[:name], resource[:debug])
          if !transport(conn_info).offline_clone_exists?(resource[:name], resource[:base_volume_name], resource[:debug])
              return false
          else
            Puppet.info("Target volume #{resource[:name]} busy")
            fail("Target volume #{resource[:name]} busy")
          end
        else
          Puppet.info("Target volume #{resource[:name]} does not exist")
          return true
        end
      rescue Hpe3parSdk::HPE3PARException => ex
        fail(ex.message)  
      end       
    elsif resource[:ensure].to_s == 'absent'
      begin
        if transport(conn_info).volume_exists?(resource[:name], resource[:debug]) 
          if !transport(conn_info).online_physical_copy_exists?(resource[:base_volume_name], resource[:name], resource[:debug]) and !transport(conn_info).offline_physical_copy_exists?(resource[:base_volume_name], resource[:name], resource[:debug])
            return true
          else
            Puppet.info("Target volume #{resource[:name]} busy")
            fail("Target volume #{resource[:name]} busy")
          end
        else
          Puppet.info("Target volume #{resource[:name]} does not exist")
          return false
        end
      rescue Hpe3parSdk::HPE3PARException => ex
        fail(ex.message)
      end
    else
      return true
    end
  end

  def create
    begin
      transport(conn_info).create_offline_clone(resource[:base_volume_name], resource[:name], resource[:dest_cpg], false, resource[:save_snapshot], resource[:priority], resource[:skip_zero], resource[:debug])
      Puppet.info("Created clone #{name} successfully")
    rescue Hpe3parSdk::HPE3PARException => ex
      Puppet.err(ex.message)
    end
  end

  def destroy
    begin
      transport(conn_info).delete_clone(resource[:name], resource[:debug])
    rescue Hpe3parSdk::HPE3PARException => ex
      Puppet.err(ex.message)
    end
  end

  def resync
    begin
      transport(conn_info).resync_clone(resource[:name], resource[:debug])
      Puppet.info("Resynced clone #{name} successfully")
    rescue Hpe3parSdk::HPE3PARException => ex
      Puppet.err(ex.message)
    end
  end
  
  def stop
    begin
      if transport(conn_info).volume_exists?(resource[:name], resource[:debug]) 
        if transport(conn_info).offline_physical_copy_exists?(resource[:base_volume_name], resource[:name], resource[:debug])
          transport(conn_info).stop_clone(resource[:name], resource[:debug])
          Puppet.info("Stopped cloning #{name} successfully")
        else
          Puppet.info("Offline physical copy #{resource[:name]} already created")
          raise "Offline physical copy #{resource[:name]} already created"
        end
      else
        Puppet.info("Target volume #{resource[:name]} does not exist")
      end     
    rescue Hpe3parSdk::HPE3PARException => ex
      Puppet.err(ex.message)
    end
  end
end