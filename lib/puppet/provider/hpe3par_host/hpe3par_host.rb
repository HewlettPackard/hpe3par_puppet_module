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

Puppet::Type.type(:hpe3par_host).provide(:hpe3par_host,
                                        :parent => Puppet::Provider::HPE3PAR) do
  desc 'Provider implementation for 3PAR Host.'
  confine :feature => :hpe3parsdk
  mk_resource_methods
  
  def exists?
    return transport(conn_info).host_exists?(resource[:host_name], resource[:debug])
  end

  def create
    begin
      if !resource[:fc_wwns].nil? and !resource[:iscsi_names].nil?
        raise ArgumentError, 'Both attribute fc_wwns and iscsi_names cannot be given at the same time for host creation'
      end
      create_host(resource)
      Puppet.info("Created Host #{resource[:host_name]} successfully")
    rescue Hpe3parSdk::HPE3PARException => ex
      fail(ex.message)
    rescue => ex
      fail(ex.message)
    end
  end

  def destroy
    begin
      transport(conn_info).delete_host(resource[:host_name], resource[:debug])
      Puppet.info("Deleted Host #{resource[:host_name]} successfully")
    rescue Hpe3parSdk::HPE3PARException => ex
      fail(ex.message)
    rescue => ex
      fail(ex.message)      
    end
  end

  def create_host(resource)
    transport(conn_info).create_host(resource[:host_name], resource[:domain], resource[:fc_wwns], resource[:iscsi_names], resource[:persona], resource[:debug])
  end

  def modify
    begin
      transport(conn_info).modify_host(resource[:host_name], resource[:new_name], resource[:persona], resource[:domain], resource[:debug])
      Puppet.info("Modified Host #{resource[:host_name]} successfully")
    rescue Hpe3parSdk::HPE3PARException => ex
      fail(ex.message)
    rescue => ex
      fail(ex.message)
    end
  end

  def add_initiator_chap
    raise ArgumentError, 'Attribute name is required for host modification' unless resource[:chap_name]
    raise ArgumentError, 'Attribute name is required for host modification' unless resource[:chap_secret]
    if resource[:chap_secret_hex] && resource[:chap_secret].length != 32
      raise Puppet::Error.new(_("Attribute chap_secret must be 32 hexadecimal characters if chap_secret_hex is true"))
    end

    if !resource[:chap_secret_hex] &&  (resource[:chap_secret].length < 12 || resource[:chap_secret].length > 16)
      raise Puppet::Error.new(_("Attribute chap_secret must be 12 to 16 character if chap_secret_hex is false"))
    end

    begin
      transport(conn_info).add_initiator_chap(resource[:host_name], resource[:chap_name], resource[:chap_secret], resource[:chap_secret_hex], resource[:debug])
      Puppet.info("Added initiator to Host #{resource[:host_name]} successfully")
    rescue Hpe3parSdk::HPE3PARException => ex
      fail(ex.message)
    rescue => ex
      fail(ex.message)
    end
  end

  def remove_initiator_chap
    begin
      transport(conn_info).remove_initiator_chap(resource[:host_name], resource[:debug])
      Puppet.info("Removed initiator from Host #{resource[:host_name]} successfully")
    rescue Hpe3parSdk::HPE3PARException => ex
      fail(ex.message)
    rescue => ex
      fail(ex.message)
    end
  end

  def add_target_chap
    begin
      raise ArgumentError, 'Attribute name is required for host modification' unless resource[:chap_name]
      raise ArgumentError, 'Attribute name is required for host modification' unless resource[:chap_secret]
      if resource[:chap_secret_hex] && resource[:chap_secret].length != 32
        raise Puppet::Error.new(_("Attribute chap_secret must be 32 hexadecimal characters if chap_secret_hex is true"))
      end

      if !resource[:chap_secret_hex] && (resource[:chap_secret].length < 12 || resource[:chap_secret].length > 16)
        raise Puppet::Error.new(_("Attribute chap_secret must be 12 to 16 character if chap_secret_hex is false"))
      end

      if transport(conn_info).initiator_chap_exists?(resource[:host_name])
        transport(conn_info).add_target_chap(resource[:host_name], resource[:chap_name], resource[:chap_secret], resource[:chap_secret_hex], resource[:debug])
        Puppet.info("Added target chap #{resource[:chap_name]} to Host #{resource[:name]}")
      else
        Puppet.info("Initiator CHAP needs to be enabled before target CHAP is set for host #{resource[:host_name]}")
      end
    rescue Hpe3parSdk::HPE3PARException => ex
      fail(ex.message)
    rescue => ex
      fail(ex.message)
    end

  end

  def remove_target_chap
    begin
      transport(conn_info).remove_target_chap(resource[:host_name], resource[:debug])
      Puppet.info("Remove target chap from Host #{resource[:host_name]}")
    rescue Hpe3parSdk::HPE3PARException => ex
      fail(ex.message)
    rescue => ex
      fail(ex.message)     
    end
  end

  def add_fc_path_to_host
    begin
      raise ArgumentError, 'Attribute fc_wwns is required to add fc path to host' unless resource[:fc_wwns]
      transport(conn_info).add_fc_path_to_host(resource[:host_name], resource[:fc_wwns], resource[:debug])
      Puppet.info("Remove target chap from Host #{resource[:host_name]}")
    rescue Hpe3parSdk::HPE3PARException => ex
      fail(ex.message)
    rescue => ex
      fail(ex.message)
    end
  end

  def remove_fc_path_from_host
    begin
      raise ArgumentError, 'Attribute fc_wwns is required to remove fc path to host' unless resource[:fc_wwns]
      transport(conn_info).remove_fc_path_from_host(resource[:host_name], resource[:fc_wwns], resource[:force_path_removal], resource[:debug])
      Puppet.info("Remove target chap from Host #{resource[:host_name]}")
    rescue Hpe3parSdk::HPE3PARException => ex
      fail(ex.message)
    rescue => ex
      fail(ex.message)
    end
  end

  def add_iscsi_path_to_host
    begin
      raise ArgumentError, 'Attribute iscsi_names is required to add iscsi path to host' unless resource[:iscsi_names]
      transport(conn_info).add_iscsi_path_to_host(resource[:host_name], resource[:iscsi_names], resource[:debug])
      Puppet.info("Remove target chap from Host #{resource[:host_name]}")
    rescue Hpe3parSdk::HPE3PARException => ex
      fail(ex.message)
    rescue => ex
      fail(ex.message)
    end
  end

  def remove_iscsi_path_from_host
    begin
      raise ArgumentError, 'Attribute iscsi_names is required to remove iscsi path to host' unless resource[:iscsi_names]
      transport(conn_info).remove_iscsi_path_from_host(resource[:host_name], resource[:iscsi_names], resource[:force_path_removal], resource[:debug])
      Puppet.info("Remove target chap from Host #{resource[:host_name]}")
    rescue Hpe3parSdk::HPE3PARException => ex
      fail(ex.message)
    rescue => ex
      fail(ex.message)
    end
  end

end
