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

Puppet::Type.type(:hpe3par_volume).provide(:hpe3par_volume,
                                        :parent => Puppet::Provider::HPE3PAR) do

  desc 'Provider implementation for Virtual Volume.'
  confine :feature => :hpe3parsdk
  mk_resource_methods

  def exists?
    return transport(conn_info).volume_exists?(resource[:volume_name], resource[:debug])
  end

  def create
    begin
      create_volume(resource)
      Puppet.info("Created Volume #{resource[:volume_name]} successfully")
    rescue Hpe3parSdk::HPE3PARException => ex
      fail(ex.message)
    rescue => ex
      fail(ex.message)
    end

  end

  def destroy
    begin
      transport(conn_info).delete_volume(resource[:volume_name], resource[:debug])
      Puppet.info("Deleted Volume #{resource[:volume_name]} successfully")
    rescue Hpe3parSdk::HPE3PARException => ex
      fail(ex.message)
    rescue => ex
      fail(ex.message)
    end
  end

  def grow
    begin
      transport(conn_info).grow_volume(resource[:volume_name], resource[:size], resource[:size_unit], resource[:debug])
      Puppet.info("Growing Volume #{resource[:volume_name]} successfully")
    rescue Hpe3parSdk::HPE3PARException => ex
      fail(ex.message)
    rescue => ex
      fail(ex.message)
    end
  end

  def grow_to_size
    begin
      if transport(conn_info).volume_exists?(resource[:volume_name], resource[:debug])
        if transport(conn_info).get_volume(resource[:volume_name], resource[:debug]).size_mib < transport(conn_info).convert_to_binary_multiple(resource[:size], resource[:size_unit])
          transport(conn_info).grow_volume(resource[:volume_name], transport(conn_info).convert_to_binary_multiple(resource[:size], resource[:size_unit]) - transport(conn_info).get_volume(resource[:volume_name], resource[:debug]).size_mib,'MiB')
          Puppet.info("Growing Volume #{resource[:volume_name]} successfully")
        else
          raise Puppet::Error.new(_("Volume #{resource[:volume_name]} is already equal or the new size is less than the existing size of the volume. Nothing to do."))
        end
      else
        raise Puppet::Error.new(_("Volume #{resource[:volume_name]} doesn't exist."))
      end   
    rescue Hpe3parSdk::HPE3PARException => ex
      fail(ex.message)
    rescue => ex
      fail(ex.message)
    end
  end

  def change_snap_cpg
    begin
      if transport(conn_info).volume_exists?(resource[:volume_name], resource[:debug])
        if transport(conn_info).cpg_exists?(resource[:snap_cpg], resource[:debug]) and 
          transport(conn_info).get_volume(resource[:volume_name], resource[:debug]).snap_cpg != nil
          if transport(conn_info).get_volume(resource[:volume_name], resource[:debug]).snap_cpg != resource[:snap_cpg]
            transport(conn_info).change_snap_cpg(resource[:volume_name],resource[:snap_cpg], resource[:wait_for_task_to_end], resource[:debug])
          else
            Puppet.info("Volume snap CPG #{resource[:snap_cpg]} is already set")
          end
        else
          raise Puppet::Error.new(_("Volume snap CPG for Volume #{resource[:volume_name]} or snap CPG #{resource[:snap_cpg]} itself does not exist."))
        end
      else
        raise Puppet::Error.new(_("Volume #{resource[:volume_name]} doesn't exist."))
      end
          
    rescue Hpe3parSdk::HPE3PARException => ex
      fail(ex.message)
    rescue => ex
      fail(ex.message)
    end
  end

  def change_user_cpg
    begin
      if transport(conn_info).volume_exists?(resource[:volume_name], resource[:debug])and 
        transport(conn_info).cpg_exists?(resource[:cpg], resource[:debug])
        if transport(conn_info).get_volume(resource[:volume_name], resource[:debug]).user_cpg != resource[:cpg]
          transport(conn_info).change_user_cpg(resource[:volume_name],resource[:cpg], resource[:wait_for_task_to_end], resource[:debug])
        else
          Puppet.info("Volume user CPG #{resource[:cpg]} is already set")
        end
      else
        raise Puppet::Error.new(_("Volume #{resource[:volume_name]} or user CPG #{resource[:cpg]} doesn't exist."))
      end   
    rescue Hpe3parSdk::HPE3PARException => ex
      fail(ex.message)
    rescue => ex
      fail(ex.message)
    end
  end

  def convert_type
    begin
      provisioning_type = transport(conn_info).get_volume(resource[:volume_name], resource[:debug]).provisioning_type
      if provisioning_type == 1
        volume_type = 'FPVV'
      elsif provisioning_type == 2
        volume_type = 'TPVV'
      elsif provisioning_type == 6
        volume_type = 'TDVV'
      else
        volume_type = 'UNKNOWN'
      end

      if transport(conn_info).volume_exists?(resource[:volume_name], resource[:debug])
        if (volume_type != transport(conn_info).get_volume_type(resource[:type]) or volume_type == 'UNKNOWN')
          transport(conn_info).convert_volume_type(resource[:volume_name], resource[:cpg],
                          resource[:type], resource[:keep_vv], resource[:compression],
                          resource[:wait_for_task_to_end], resource[:debug])
        else
          Puppet.info("Volume provisioning type #{resource[:type]} is already set")
        end
      else
        raise Puppet::Error.new(_("Volume #{resource[:volume_name]} doesn't exist."))
      end
    rescue Hpe3parSdk::HPE3PARException => ex
      fail(ex.message)
    rescue => ex
      fail(ex.message)
    end
  end

  def modify
    begin 
      transport(conn_info).modify_base_volume(resource[:volume_name],
                         resource[:new_name],
                         resource[:expiration_hours],
                         resource[:retention_hours],
                         resource[:ss_spc_alloc_warning_pct],
                         resource[:ss_spc_alloc_limit_pct],
                         resource[:usr_spc_alloc_warning_pct],
                         resource[:usr_spc_alloc_limit_pct],
                         resource[:rm_ss_spc_alloc_warning],
                         resource[:rm_usr_spc_alloc_warning],
                         resource[:rm_exp_time],
                         resource[:rm_usr_spc_alloc_limit],
                         resource[:rm_ss_spc_alloc_limit],
                         resource[:debug])
    rescue Hpe3parSdk::HPE3PARException => ex
      fail(ex.message)
    rescue => ex
      fail(ex.message)
    end
  end

  def set_snap_cpg
    begin
      if transport(conn_info).volume_exists?(resource[:volume_name], resource[:debug]) and 
        transport(conn_info).cpg_exists?(resource[:snap_cpg], resource[:debug])
        if transport(conn_info).get_volume(resource[:volume_name], resource[:debug]).snap_cpg == nil 
           transport(conn_info).set_snap_cpg(resource[:volume_name], resource[:snap_cpg], resource[:debug])
        else
          raise Puppet::Error.new(_("Volume snap CPG #{resource[:snap_cpg]} is already set"))
        end
      else
        raise Puppet::Error.new(_("Volume #{resource[:volume_name]} or snap CPG #{resource[:snap_cpg]} doesn't exist."))
      end
    rescue Hpe3parSdk::HPE3PARException => ex
      fail(ex.message)
    rescue => ex
      fail(ex.message)
    end
  end

  def create_volume(resource)
    transport(conn_info).create_volume(resource[:volume_name], resource[:cpg], resource[:size], resource[:size_unit], 
	resource[:type], resource[:compression], resource[:snap_cpg], resource[:debug])
  end

end
