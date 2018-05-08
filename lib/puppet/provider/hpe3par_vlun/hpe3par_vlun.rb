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

Puppet::Type.type(:hpe3par_vlun).provide(:hpe3par_vlun,
                                        :parent => Puppet::Provider::HPE3PAR) do
  desc 'Provider implementation for VLUN.'
  mk_resource_methods

  confine :feature => :hpe3parsdk

  def exists?

  end

  def check_exists?(resource)
    if resource[:ensure].to_s  == "export_volume_to_host" || resource[:ensure].to_s  == "unexport_volume_to_host"
        return transport(conn_info).vlun_exists?(resource[:volume_name], resource[:lunid], resource[:host_name], resource[:node_val], resource[:slot], resource[:card_port], resource[:debug])
    end
    if resource[:ensure].to_s  == "export_volume_to_hostset" || resource[:ensure].to_s  == "unexport_volume_to_hostset"
      if !resource[:volume_name].nil? && !resource[:volume_name].empty?
        return transport(conn_info).vlun_exists?(resource[:volume_name], resource[:lunid], resource[:hostset_name], resource[:node_val], resource[:slot], resource[:card_port], resource[:debug])
      else
        raise ArgumentError, 'volume name is missing'
      end
    end
    if resource[:ensure].to_s  == "export_volumeset_to_host" || resource[:ensure].to_s  == "unexport_volumeset_to_host"
      if (!resource[:host_name].nil? && !resource[:host_name].empty?) || (!resource[:node_val].nil? && !resource[:slot].nil? && !resource[:card_port].nil?)
        return transport(conn_info).vlun_exists?(resource[:volumeset_name], resource[:lunid], resource[:host_name], resource[:node_val], resource[:slot], resource[:card_port], resource[:debug])
      else
        raise ArgumentError, 'host name or port is missing'
      end
    end
    if resource[:ensure].to_s  == "export_volumeset_to_hostset" ||  resource[:ensure].to_s  == "unexport_volumeset_to_hostset"
        return transport(conn_info).vlun_exists?(resource[:volumeset_name], resource[:lunid], resource[:hostset_name], resource[:node_val], resource[:slot], resource[:card_port], resource[:debug])
    end
  end

  def export_volume_to_host
    begin
      if !resource[:volume_name].nil? && !resource[:volume_name].empty?
        if (!resource[:host_name].nil? && !resource[:host_name].empty?) || (!resource[:node_val].nil? && !resource[:slot].nil? && !resource[:card_port].nil?)
          if !resource[:lunid].nil? || !resource[:autolun].nil?
            if !resource[:autolun]
              exists = check_exists?(resource)
            else
              exists = false
            end
            if !exists
              transport(conn_info).create_vlun(resource[:volume_name], resource[:lunid],  resource[:host_name], resource[:node_val] ,resource[:slot],  resource[:card_port] ,resource[:autolun], resource[:debug])
              Puppet.info("Created vlun #{name} successfully")
            else
              Puppet.info("Resource exists. Nothing to do")
            end
          else
            raise ArgumentError, 'lun id  or autolun must be specified'
          end
        else
          raise ArgumentError, 'host name or port is required to export'
        end
      else
        raise ArgumentError, 'volume name can not be empty'
      end
    rescue Hpe3parSdk::HPE3PARException => ex
      fail(ex.message)
    rescue Exception => ex
      fail(ex.message)
    end
  end

  def export_volume_to_hostset
    begin
      if !resource[:hostset_name].nil? && !resource[:hostset_name].empty?
        resource[:hostset_name] = "set:"+ resource[:hostset_name]
        if !resource[:lunid].nil? || !resource[:autolun]
          exists = check_exists?(resource)
        else
          exists = false
        end
        if !exists
          transport(conn_info).create_vlun(resource[:volume_name], resource[:lunid],  resource[:hostset_name], resource[:node_val] ,resource[:slot],  resource[:card_port] ,resource[:autolun], resource[:debug])
          Puppet.info("Created vlun #{name} successfully")
        else
          Puppet.info("Resource exists. Nothing to do")
        end
      else
        raise ArgumentError, 'hostset name  is missing'
      end
    rescue Hpe3parSdk::HPE3PARException => ex
      fail(ex.message)
    rescue Exception => ex
      fail(ex.message)
    end
  end

  def export_volumeset_to_host
    begin
      if !resource[:volumeset_name].nil? && !resource[:volumeset_name].empty?
        resource[:volumeset_name] = "set:" + resource[:volumeset_name]
        if !resource[:lunid].nil? || !resource[:autolun]
          exists = check_exists?(resource)
        else
          exists = false
        end
        if !exists
          transport(conn_info).create_vlun(resource[:volumeset_name], resource[:lunid],  resource[:host_name], resource[:node_val] ,resource[:slot],  resource[:card_port] ,resource[:autolun], resource[:debug])
          Puppet.info("Created vlun #{name} successfully")
        else
          Puppet.info("Resource exists. Nothing to do")
        end
      else
        raise ArgumentError, 'volumeset name  is missing'
      end
    rescue Hpe3parSdk::HPE3PARException => ex
      fail(ex.message)
    rescue Exception => ex
      fail(ex.message)
    end
  end

  def export_volumeset_to_hostset
    begin
      if !resource[:volumeset_name].nil? && !resource[:volumeset_name].empty? && !resource[:hostset_name].nil? && !resource[:hostset_name].empty?
        resource[:volumeset_name] = "set:" + resource[:volumeset_name]
        resource[:hostset_name] = "set:" + resource[:hostset_name]
        if !resource[:lunid].nil? || !resource[:autolun]
          exists = check_exists?(resource)
        else
          exists = false
        end
        if !exists
          transport(conn_info).create_vlun(resource[:volumeset_name], resource[:lunid],  resource[:hostset_name], resource[:node_val] ,resource[:slot],  resource[:card_port] ,resource[:autolun], resource[:debug])
          Puppet.info("Created vlun #{name} successfully")
        else
          Puppet.info("Resource exists. Nothing to do")
        end
      else
        raise ArgumentError, 'volumeset name or hostset name  is missing'
      end
    rescue Hpe3parSdk::HPE3PARException => ex
      fail(ex.message)
    rescue Exception => ex
      fail(ex.message)
    end
  end

  def unexport_volume_to_host
    begin
    if !resource[:volume_name].nil? && !resource[:volume_name].empty?
      if (!resource[:host_name].nil? && !resource[:host_name].empty?) || (!resource[:node_val].nil? && !resource[:slot].nil? && !resource[:card_port].nil?)
        if !resource[:lunid].nil?
          exists = check_exists?(resource)
        else
          raise ArgumentError, 'lun is required to unexport'
        end
        if exists
          transport(conn_info).delete_vlun(resource[:volume_name], resource[:lunid], resource[:host_name], resource[:node_val], resource[:slot], resource[:card_port], resource[:debug])
          Puppet.info("Deleted vlun #{name} successfully")
        else
          Puppet.info("Resource doesnt exists")
        end
      else
        raise ArgumentError, 'host name or port is required to export'
      end
    else
      raise ArgumentError, 'Volume name is required'
    end
    rescue Hpe3parSdk::HPE3PARException => ex
      fail(ex.message)
    rescue Exception => ex
      fail(ex.message)
    end
  end

  def unexport_volume_to_hostset
    begin
      if !resource[:hostset_name].nil? && !resource[:hostset_name].empty?
        resource[:hostset_name] = "set:"+ resource[:hostset_name]
        if !resource[:lunid].nil?
          exists = check_exists?(resource)
        else
          raise ArgumentError, 'lun is required to unexport'
        end
        if exists
          transport(conn_info).delete_vlun(resource[:volume_name], resource[:lunid], resource[:hostset_name], resource[:node_val], resource[:slot], resource[:card_port], resource[:debug])
          Puppet.info("Deleted vlun #{name} successfully")
        else
          Puppet.info("Resource does not exists")
        end
      else
        raise ArgumentError, 'hostset name cannot be empty'
      end
    rescue Hpe3parSdk::HPE3PARException => ex
      fail(ex.message)
    rescue Exception => ex
      fail(ex.message)
    end
  end

  def unexport_volumeset_to_host
    begin
      if !resource[:volumeset_name].nil? && !resource[:volumeset_name].empty?
        resource[:volumeset_name] = "set:" + resource[:volumeset_name]
        if !resource[:lunid].nil?
          exists = check_exists?(resource)
        else
          raise ArgumentError, 'lun is required to unexport'
        end
        if exists
          transport(conn_info).delete_vlun(resource[:volumeset_name], resource[:lunid], resource[:host_name], resource[:node_val], resource[:slot], resource[:card_port], resource[:debug])
          Puppet.info("Deleted vlun #{name} successfully")
        else
          Puppet.info("Resource does not exists. Nothing to do")
        end
     else
        raise ArgumentError, 'volulmeset name cannot be empty'
     end
    rescue Hpe3parSdk::HPE3PARException => ex
      fail(ex.message)
    rescue Exception => ex
      fail(ex.message)
    end
  end

  def unexport_volumeset_to_hostset
    begin
      if !resource[:hostset_name].nil? && !resource[:hostset_name].empty? && !resource[:volumeset_name].nil? && !resource[:volumeset_name].empty?
        resource[:volumeset_name] = "set:" + resource[:volumeset_name]
        resource[:hostset_name] = "set:" + resource[:hostset_name]
        if !resource[:lunid].nil?
          exists = check_exists?(resource)
        else
          raise ArgumentError, 'lun is required to unexport'
        end
        if exists
          transport(conn_info).delete_vlun(resource[:volumeset_name], resource[:lunid], resource[:hostset_name], resource[:node_val], resource[:slot], resource[:card_port], resource[:debug])
          Puppet.info("Deleted vlun #{name} successfully")
        else
          Puppet.info("Resource does not exists. Nothing to do")
        end
      else
        raise ArgumentError, 'volulmeset name or hostset name cannot be empty'
      end
    rescue Hpe3parSdk::HPE3PARException => ex
      fail(ex.message)
    rescue Exception => ex
      fail(ex.message)
    end
  end
end
