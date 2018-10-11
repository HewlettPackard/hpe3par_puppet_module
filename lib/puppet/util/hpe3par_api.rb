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

if Puppet.features.hpe3parsdk?
  require 'Hpe3parSdk'
  require 'Hpe3parSdk/exceptions'
  require 'Hpe3parSdk/constants'
  require 'Hpe3parSdk/models'
end

class HPE3PAR_API
  DEBUG_MODE = false

  attr_accessor :url, :rest_url

  def initialize(url, options = {})
    @url = URI.parse(url)
    validate
    @rest_url = "#{@url.scheme}://#{@url.host}:#{@url.port}/api/v1"
  end

  def validate
    raise ArgumentError, "Invalid scheme #{@url.scheme}. Must be https" unless @url.scheme == 'https'
    raise ArgumentError, "User must be specified" unless @url.user
    raise ArgumentError, "Password must be specified" unless @url.password
  end

  def create_cpg(name, domain = nil, growth_increment = nil, growth_increment_unit = nil, growth_limit = nil,
                 growth_limit_unit = nil, growth_warning = nil, growth_warning_unit = nil, raidtype = nil,
                 setSize = nil, highavailability = nil, disktype = nil, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      ldLayout = Hash.new
      diskPatterns = []
      if !disktype.nil? && !disktype.empty?
        disktype = Hpe3parSdk::CPGDiskType.const_get(disktype)
        diskPatterns= [{:diskType => disktype}]
      end

      ldLayout = {
          :RAIDType => raidtype,
          :setSize => setSize,
          :HA => highavailability,
          :diskPatterns => diskPatterns
      }
      ldLayout = cpg_ldlayout_map(ldLayout)
      growth_increment = convert_to_binary_multiple(growth_increment, growth_increment_unit) unless growth_increment.nil?
      growth_limit = convert_to_binary_multiple(growth_limit, growth_limit_unit) unless growth_limit.nil?
      growth_warning = convert_to_binary_multiple(growth_warning, growth_warning_unit) unless growth_warning.nil?

      optional_hash= {
          :domain => domain,
          :growthIncrementMiB => growth_increment,
          :growthLimitMiB => growth_limit,
          :usedLDWarningAlertMiB => growth_warning,
          :LDLayout => ldLayout
      }

      cl.login(@url.user, @url.password)
      cl.create_cpg(name, optional_hash)
    ensure
      cl.logout
    end
  end

  def delete_cpg(name, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)
      cl.delete_cpg(name)
    ensure
      cl.logout
    end
  end

  def create_host_set(host_set_name, domain = nil, setmembers = nil, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)
      cl.create_host_set(host_set_name, domain, nil, setmembers)
    ensure
      cl.logout
    end
  end

  def delete_host_set(host_set_name, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)
      cl.delete_host_set(host_set_name)
    ensure
      cl.logout
    end
  end

  def add_hosts_to_host_set(host_set_name, setmembers, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      current_set_members = get_host_set(host_set_name).setmembers
      if !current_set_members.nil?
        new_set_members = setmembers - current_set_members
      else
        new_set_members = setmembers
      end
      if !new_set_members.nil? and new_set_members.any?
        cl.login(@url.user, @url.password)
        cl.add_hosts_to_host_set(host_set_name, new_set_members)
      end
    ensure
      cl.logout
    end
  end

  def remove_hosts_from_host_set(host_set_name, setmembers, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      current_set_members = get_host_set(host_set_name).setmembers

      if current_set_members != nil
        common_set_members = current_set_members & setmembers
      end

      if !common_set_members.nil? and common_set_members.any?
        cl.login(@url.user, @url.password)
        cl.remove_hosts_from_host_set(host_set_name, common_set_members)
      end
    ensure
      cl.logout
    end
  end

  def create_snapshot(name, base_volume_name, read_only=nil, expiration_time=nil, retention_time=nil, expiration_unit=nil, retention_unit=nil, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)
      optional_hash= {
          :readOnly => read_only,
          :expirationHours => convert_to_hours(expiration_time, expiration_unit),
          :retentionHours => convert_to_hours(retention_time, retention_unit)
      }
      cl.create_snapshot(name, base_volume_name, optional_hash)
    ensure
      cl.logout
    end
  end

  def delete_snapshot(snapshot_name, force_delete=false, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)
      cl.delete_snapshot(snapshot_name)
    ensure
      cl.logout
    end
  end

  def modify_snapshot(name, new_name, expiration_hours, retention_hours, rm_exp_time, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)
      modify_volume(name, new_name, expiration_hours, retention_hours, nil, nil, nil, nil, nil, nil, nil, nil, rm_exp_time, nil, nil, debug)
    ensure
      cl.logout
    end
  end

  def restore_snapshot_offline(snapshot_name, priority, allow_remote_copy_parent, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)
      optional = {:online => false,
                  :allowRemoteCopyParent => allow_remote_copy_parent
      }
      optional[:priority] = Hpe3parSdk::TaskPriority.const_get(priority)
      cl.restore_snapshot(snapshot_name, optional)
    ensure
      cl.logout
    end
  end

  def restore_snapshot_online(snapshot_name, allow_remote_copy_parent, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)
      optional = {:online => true,
                  :allowRemoteCopyParent => allow_remote_copy_parent
      }
      cl.restore_snapshot(snapshot_name, optional)
    ensure
      cl.logout
    end
  end

  def cpg_exists?(name, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)
      cl.cpg_exists?(name)
    ensure
      cl.logout
    end
  end

  def hostset_exists?(name, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)
      cl.host_set_exists?(name)
    ensure
      cl.logout
    end
  end

  def create_qos_rules(target_name, target_type, priority = nil, bwMinGoalKB = nil,
                       bwMaxLimitKB = nil, ioMinGoal= nil, ioMaxLimit = nil, bwMinGoalOP = nil,
                       bwMaxLimitOP = nil, ioMinGoalOP = nil, ioMaxLimitOP = nil, latencyGoal = nil,
                       defaultLatency = nil, enable = nil, latencyGoaluSecs = nil, debug = false)

    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      qos_rules = {
          :bwMinGoalKB => bwMinGoalKB,
          :bwMaxLimitKB => bwMaxLimitKB,
          :ioMinGoal => ioMinGoal,
          :ioMaxLimit => ioMaxLimit,
          :latencyGoal => latencyGoal,
          :defaultLatency => defaultLatency,
          :enable => enable,
          :latencyGoaluSecs => latencyGoaluSecs
      }
      unless priority.nil?
        qos_rules[:priority] = Hpe3parSdk::QoSpriorityEnumeration.const_get(priority)
      end

      unless bwMinGoalOP.nil?
        qos_rules[:bwMinGoalOP] = Hpe3parSdk::QosZeroNoneOperation.const_get(bwMinGoalOP)
      end

      unless bwMaxLimitOP.nil?
        qos_rules[:bwMaxLimitOP] = Hpe3parSdk::QosZeroNoneOperation.const_get(bwMaxLimitOP)
      end
      unless ioMinGoalOP.nil?
        qos_rules[:ioMinGoalOP] = Hpe3parSdk::QosZeroNoneOperation.const_get(ioMinGoalOP)
      end
      unless ioMaxLimitOP.nil?
        qos_rules[:ioMaxLimitOP] = Hpe3parSdk::QosZeroNoneOperation.const_get(ioMaxLimitOP)
      end
      cl.login(@url.user, @url.password)
      cl.create_qos_rules(target_name, qos_rules, target_type = Hpe3parSdk::QoStargetType.const_get(target_type))
    ensure
      cl.logout
    end
  end


  def modify_qos_rules(target_name, target_type = QoStargetTypeConstants::VVSET, priority = nil,
                       bwMinGoalKB = nil, bwMaxLimitKB = nil, ioMinGoal= nil, ioMaxLimit = nil,
                       bwMinGoalOP = nil, bwMaxLimitOP = nil, ioMinGoalOP = nil, ioMaxLimitOP = nil,
                       latencyGoal = nil, defaultLatency = nil, enable = nil, latencyGoaluSecs = nil, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    qos_rules = {
        :bwMinGoalKB => bwMinGoalKB,
        :bwMaxLimitKB => bwMaxLimitKB,
        :ioMinGoal => ioMinGoal,
        :ioMaxLimit => ioMaxLimit,
        :latencyGoal => latencyGoal,
        :defaultLatency => defaultLatency,
        :enable => enable,
        :latencyGoaluSecs => latencyGoaluSecs
    }
    unless priority.nil?
      qos_rules[:priority] = Hpe3parSdk::QoSpriorityEnumeration.const_get(priority)
    end
    unless bwMinGoalOP.nil?
      qos_rules[:bwMinGoalOP] = Hpe3parSdk::QosZeroNoneOperation.const_get(bwMinGoalOP)
    end
    unless bwMaxLimitOP.nil?
      qos_rules[:bwMaxLimitOP] = Hpe3parSdk::QosZeroNoneOperation.const_get(bwMaxLimitOP)
    end
    unless ioMinGoalOP.nil?
      qos_rules[:ioMinGoalOP] = Hpe3parSdk::QosZeroNoneOperation.const_get(ioMinGoalOP)
    end
    unless ioMaxLimitOP.nil?
      qos_rules[:ioMaxLimitOP] = Hpe3parSdk::QosZeroNoneOperation.const_get(ioMaxLimitOP)
    end
    begin
      cl.login(@url.user, @url.password)
      cl.modify_qos_rules(target_name, qos_rules, Hpe3parSdk::QoStargetTypeConstants.const_get(target_type))
    ensure
      cl.logout
    end
  end

  def delete_qos_rules(target_name, target_type, debug = false)

    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)
      cl.delete_qos_rules(target_name, Hpe3parSdk::QoStargetTypeConstants.const_get(target_type))
    ensure
      cl.logout
    end
  end


  def qos_rule_exists?(target_name, target_type, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)
      cl.qos_rule_exists?(target_name, Hpe3parSdk::QoStargetTypeConstants.const_get(target_type))
    ensure
      cl.logout
    end
  end

  def vlun_exists?(volume_name, lunid, host_name=nil, node = nil, slot = nil, card_port = nil, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      port_pos = nil
      if !node.nil? && !slot.nil? && !card_port.nil?
        port_pos={
            :node => node,
            :slot => slot,
            :cardPort => card_port
        }
      end
      cl.login(@url.user, @url.password)
      cl.vlun_exists?(volume_name, lunid, host_name, port_pos)
    ensure
      cl.logout
    end
  end


  def create_vlun(volume_name, lunid = nil, host_name=nil, node = nil, slot = nil,
                  card_port = nil, auto = true, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    port_pos = nil
    if !node.nil? && !slot.nil? && !card_port.nil?
      port_pos={
          :node => node,
          :slot => slot,
          :cardPort => card_port
      }
    end
    begin
      cl.login(@url.user, @url.password)
      cl.create_vlun(volume_name, lunid, host_name, port_pos, no_vcn = nil,
                     override_lower_priority = nil, auto)
    ensure
      cl.logout
    end
  end

  def delete_vlun(volume_name, lunid, host_name = nil, node = nil, slot = nil, card_port = nil, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    port_pos = nil
    if !node.nil? && !slot.nil? && !card_port.nil?
      port_pos={
          :node => node,
          :slot => slot,
          :cardPort => card_port
      }
    end
    begin
      cl.login(@url.user, @url.password)
      cl.delete_vlun(volume_name, lunid, host_name, port_pos)
    ensure
      cl.logout
    end
  end

  def convert_to_binary_multiple(size, size_unit)
    size_MiB = 0
    if size_unit == 'GiB'
      size_MiB = size * 1024
    elsif size_unit == 'TiB'
      size_MiB = size * 1048576
    elsif size_unit == 'MiB'
      size_MiB = size
    end
    return size_MiB.to_i
  end

  def cpg_ldlayout_map(ldlayout_hash)

    if !ldlayout_hash[:RAIDType].nil? && !ldlayout_hash[:RAIDType].empty?
      ldlayout_hash[:RAIDType] = Hpe3parSdk::CPGRAIDType
                                     .const_get(ldlayout_hash[:RAIDType])
    end
    if !ldlayout_hash[:HA].nil? && !ldlayout_hash[:HA].empty?
      ldlayout_hash[:HA] = Hpe3parSdk::CPGHA
                               .const_get(ldlayout_hash[:HA])
    end
    return ldlayout_hash
  end

  def convert_to_hours(time, unit)
    hours = 0
    if unit == 'Days'
      hours = time * 24
    elsif unit == 'Hours'
      hours = time
    end
    return hours
  end


  def create_volume(volume_name, cpg_name, size, size_unit, type = 'thin',
                    compression = false, snap_cpg = nil, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug, app_type: 'puppet_module_3par')
    size_MiB = convert_to_binary_multiple(size, size_unit)
    tpvv = false
    tdvv = false
    if type == 'thin'
      tpvv = true
    elsif type == 'thin_dedupe'
      tdvv = true
    end

    optional_hash= {
        :tpvv => tpvv,
        :tdvv => tdvv,
        :compression => compression,
        :snapCPG => snap_cpg
    }

    begin
      cl.login(@url.user, @url.password)
      cl.create_volume(volume_name, cpg_name, size_MiB,
                       optional_hash)
    rescue Hpe3parSdk::HPE3PARException => ex
      raise ex
    ensure
      cl.logout
    end
  end

  def modify_base_volume(volume_name, new_name=nil, expiration_time=nil, retention_time=nil,
                         ss_spc_alloc_warning_pct=nil, ss_spc_alloc_limit_pct=nil, usr_spc_alloc_warning_pct=nil, usr_spc_alloc_limit_pct=nil,
                         rm_ss_spc_alloc_warning=nil, rm_usr_spc_alloc_warning=nil, rm_exp_time=nil, rm_ss_spc_alloc_limit=nil, rm_usr_spc_alloc_limit=nil, debug = false)
    modify_volume(volume_name, new_name, expiration_time, retention_time, nil, nil,
                  ss_spc_alloc_warning_pct, ss_spc_alloc_limit_pct, usr_spc_alloc_warning_pct, usr_spc_alloc_limit_pct,
                  rm_ss_spc_alloc_warning, rm_usr_spc_alloc_warning, rm_exp_time, rm_ss_spc_alloc_limit, rm_usr_spc_alloc_limit, debug)
  end

  def set_snap_cpg(volume_name, snap_cpg, debug = false)
    modify_volume(volume_name, nil, nil, nil, snap_cpg, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil)
  end

  def modify_volume(volume_name, new_name, expiration_time, retention_time, snap_cpg, user_cpg,
                    ss_spc_alloc_warning_pct, ss_spc_alloc_limit_pct, usr_spc_alloc_warning_pct, usr_spc_alloc_limit_pct,
                    rm_ss_spc_alloc_warning, rm_usr_spc_alloc_warning, rm_exp_time, rm_ss_spc_alloc_limit, rm_usr_spc_alloc_limit, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug, app_type: 'puppet_module_3par')
    begin
      cl.login(@url.user, @url.password)
      volume_mods={:expirationHours => expiration_time,
                   :newName => new_name,
                   :retentionHours => retention_time,
                   :snapCPG => snap_cpg,
                   :ssSpcAllocWarningPct => ss_spc_alloc_warning_pct,
                   :ssSpcAllocLimitPct => ss_spc_alloc_limit_pct,
                   :userCPG => user_cpg,
                   :usrSpcAllocWarningPct => usr_spc_alloc_warning_pct,
                   :usrSpcAllocLimitPct => usr_spc_alloc_limit_pct,
                   :rmSsSpcAllocWarning => rm_ss_spc_alloc_warning,
                   :rmUsrSpcAllocWarning => rm_usr_spc_alloc_warning,
                   :rmExpTime => rm_exp_time,
                   :rmSsSpcAllocLimit => rm_ss_spc_alloc_limit,
                   :rmUsrSpcAllocLimit => rm_usr_spc_alloc_limit
      }
      cl.modify_volume(volume_name, volume_mods)
      Puppet.info("Volume #{volume_name} modified successfully")
    rescue Hpe3parSdk::HTTPConflict => ex
      Puppet.err(ex.message)
      Puppet.err("Unable to rename, since a volume with the name #{new_name} already exists")
      raise ex
    rescue Hpe3parSdk::HPE3PARException => ex
      Puppet.err(ex.message)
      raise ex
    ensure
      cl.logout
    end
  end

  def grow_volume(volume_name, size, size_unit, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)
      size_MiB = convert_to_binary_multiple(size, size_unit)
      cl.grow_volume(volume_name, size_MiB)
      Puppet.info("Volume #{volume_name} growth successful")
    rescue Hpe3parSdk::HPE3PARException => ex
      Puppet.err(ex.message)
      raise ex
    ensure
      cl.logout
    end
  end

  def grow_to_size(volume_name, size, size_unit, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)
      size_MiB = convert_to_binary_multiple(size, size_unit)
      cl.grow_to_size(volume_name, size_MiB)
      Puppet.info("Volume #{volume_name} grown")
    rescue Hpe3parSdk::HPE3PARException => ex
      Puppet.err(ex.message)
      raise ex
    ensure
      cl.logout
    end
  end

  def change_snap_cpg(name, snap_cpg, wait_for_task_to_end, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)
      task = cl.tune_volume(name, Hpe3parSdk::VolumeTuneOperation::SNP_CPG,
                            {:snapCPG => snap_cpg})
      if wait_for_task_to_end
        Puppet.info("Waiting for change snap CPG task of volume #{name} to complete")
        cl.wait_for_task_to_end(task.task_id)
      end
      Puppet.info("Snap CPG of Volume #{name} changed to #{snap_cpg} successfully")
    rescue Hpe3parSdk::HPE3PARException => ex
      Puppet.err(ex.message)
      raise ex
    ensure
      cl.logout
    end
  end

  def change_user_cpg(name, user_cpg, wait_for_task_to_end, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)
      task = cl.tune_volume(name, Hpe3parSdk::VolumeTuneOperation::USR_CPG,
                            {:userCPG => user_cpg})
      if wait_for_task_to_end
        Puppet.info("Waiting for change user CPG task of volume #{name} to complete")
        cl.wait_for_task_to_end(task.task_id)
      end
      Puppet.info("User CPG of Volume #{name} changed to #{user_cpg} successfully")
    rescue Hpe3parSdk::HPE3PARException => ex
      Puppet.err(ex.message)
      raise ex
    ensure
      cl.logout
    end
  end

  def convert_volume_type(name, user_cpg, type,
                          keep_vv = nil, compression = false, wait_for_task_to_end = false, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)
      new_vol_type = get_volume_type(type)
      task = cl.tune_volume(name, Hpe3parSdk::VolumeTuneOperation::USR_CPG,
                            {:userCPG => user_cpg,
                             :conversionOperation => Hpe3parSdk::VolumeConversionOperation.const_get(new_vol_type),
                             :keepVV => keep_vv,
                             :compression => compression
                            })
      if wait_for_task_to_end
        Puppet.info("Waiting for type conversion task of volume #{name} to complete")
        cl.wait_for_task_to_end(task.task_id)
      end

      Puppet.info("Volume #{name} type changed to #{type} successfully")
    rescue Hpe3parSdk::HTTPConflict => ex
      Puppet.err(ex.message)
      Puppet.err('An error occured. This maybe due to the existence of a back-up volume (using the keepvv option) created during a previous run.')
      raise ex
    rescue Hpe3parSdk::HPE3PARException => ex
      Puppet.err(ex.message)
      raise ex
    ensure
      cl.logout
    end
  end

  def get_volume_type(type)
    enum_type = ''
    if type == 'thin'
      enum_type = 'TPVV'
    elsif type == 'thin_dedupe'
      enum_type = 'TDVV'
    elsif type == 'full'
      enum_type = 'FPVV'
    end
    return enum_type
  end

  def delete_volume(volume_name, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)
      cl.delete_volume(volume_name)
    rescue Hpe3parSdk::HPE3PARException => ex
      raise ex
    ensure
      cl.logout
    end
  end

  def volume_exists?(name, debug = false)
    ca = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      ca.login(@url.user, @url.password)
      ca.volume_exists?(name)
    ensure
      ca.logout
    end
  end

  def create_volume_set(volume_set_name, domain=nil, setmembers=nil, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)
      cl.create_volume_set(volume_set_name, domain, nil, setmembers)
    rescue Hpe3parSdk::HPE3PARException => ex
      raise ex
    ensure
      cl.logout
    end
  end

  def delete_volume_set(volume_set_name, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)
      cl.delete_volume_set(volume_set_name)
    rescue Hpe3parSdk::HPE3PARException => ex
      raise ex
    ensure
      cl.logout
    end
  end

  def volume_set_exists?(name, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)
      cl.volume_set_exists?(name)
    ensure
      cl.logout
    end
  end

  def get_host_set(host_set, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)
      cl.get_host_set(host_set)
    rescue Hpe3parSdk::HPE3PARException => ex
      raise ex
    ensure
      cl.logout
    end
  end

  def get_volume(volume_name, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)
      cl.get_volume(volume_name)
    ensure
      cl.logout
    end
  end

  def get_volume_set(volume_set, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)
      cl.get_volume_set(volume_set)
    ensure
      cl.logout
    end
  end

  def create_host(host_name, domain = nil, fcwwns = nil, iscsi_names = nil, persona = nil, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)
      optional = {}
      unless domain.nil?
        optional['domain'] = domain
      end
      unless persona.nil?
        optional['persona'] = Hpe3parSdk::HostPersona.const_get(persona)
      end
      cl.create_host(host_name, iscsi_names, fcwwns, optional)
    rescue Hpe3parSdk::HPE3PARException => ex
      raise ex
    ensure
      cl.logout
    end
  end

  def modify_host(host_name, new_name = nil, persona = nil, domain = nil, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)
      mod_request = {}
      unless domain.nil?
        mod_request['domain'] = domain
      end
      unless new_name.nil?
        mod_request['newName'] = new_name
      end
      unless persona.nil?
        mod_request['persona'] = Hpe3parSdk::HostPersona.const_get(persona)
      end
      cl.modify_host(host_name, mod_request)
      Puppet.info("Host #{host_name} modified successfully")
    rescue Hpe3parSdk::HPE3PARException => ex
      Puppet.err(ex.message)
      raise ex
    ensure
      cl.logout
    end
  end

  def add_initiator_chap(host_name, chap_name, chap_secret, chap_secret_hex, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)
      mod_request = {'chapOperationMode' => Hpe3parSdk::ChapOperationMode.const_get('INITIATOR'),
                     'chapOperation' => Hpe3parSdk::HostEditOperation.const_get('ADD'),
                     'chapName' => chap_name, 'chapSecret' => chap_secret, 'chapSecretHex' => chap_secret_hex}
      cl.modify_host(host_name, mod_request)
      Puppet.info("Host #{host_name} modified to add initiator chap")

    rescue Hpe3parSdk::HPE3PARException => ex
      Puppet.err(ex.message)
      raise ex
    ensure
      cl.logout
    end
  end

  def remove_initiator_chap(host_name, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)
      mod_request = {'chapOperation' => Hpe3parSdk::HostEditOperation.const_get('REMOVE')}
      cl.modify_host(host_name, mod_request)
      Puppet.info("Host #{host_name} modified to remove initiator chap")
    rescue Hpe3parSdk::HPE3PARException => ex
      Puppet.err(ex.message)
      raise ex
    ensure
      cl.logout
    end
  end

  def add_target_chap(host_name, chap_name, chap_secret, chap_secret_hex, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)
      mod_request = {'chapOperationMode' => Hpe3parSdk::ChapOperationMode.const_get('TARGET'),
                     'chapOperation' => Hpe3parSdk::HostEditOperation.const_get('ADD'),
                     'chapName' => chap_name, 'chapSecret' => chap_secret, 'chapSecretHex' => chap_secret_hex}
      cl.modify_host(host_name, mod_request)
      Puppet.info("Host #{host_name} modified to add target chap")
    rescue Hpe3parSdk::HPE3PARException => ex
      Puppet.err(ex.message)
      raise ex
    ensure
      cl.logout
    end
  end

  def remove_target_chap(host_name, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)
      mod_request = {'chapOperation' => Hpe3parSdk::HostEditOperation.const_get('REMOVE'),
                     'chapRemoveTargetOnly' => true}
      cl.modify_host(host_name, mod_request)
      Puppet.info("Host #{host_name} modified to remove target chap")
    rescue Hpe3parSdk::HPE3PARException => ex
      Puppet.err(ex.message)
      raise ex
    ensure
      cl.logout
    end
  end

  def add_fc_path_to_host(host_name, fc_wwns, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)
      mod_request = {'pathOperation' => Hpe3parSdk::HostEditOperation.const_get('ADD'),
                     'FCWWNs' => fc_wwns}
      cl.modify_host(host_name, mod_request)
      Puppet.info("FC path #{fc_wwns} added to host #{host_name}")
    rescue Hpe3parSdk::HPE3PARException => ex
      Puppet.err(ex.message)
      raise ex
    ensure
      cl.logout
    end
  end

  def remove_fc_path_from_host(host_name, fc_wwns, force_path_removal, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)
      mod_request = {'pathOperation' => Hpe3parSdk::HostEditOperation.const_get('REMOVE'),
                     'FCWWNs' => fc_wwns,
                     'forcePathRemoval' => force_path_removal}
      cl.modify_host(host_name, mod_request)
      Puppet.info("FC path #{fc_wwns} removed from host #{host_name}")
    rescue Hpe3parSdk::HPE3PARException => ex
      Puppet.err(ex.message)
      raise ex
    ensure
      cl.logout
    end
  end

  def add_iscsi_path_to_host(host_name, iscsi_names, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)
      mod_request = {'pathOperation' => Hpe3parSdk::HostEditOperation.const_get('ADD'),
                     'iSCSINames' => iscsi_names}
      cl.modify_host(host_name, mod_request)
      Puppet.info("iSCSI path #{iscsi_names} added to host #{host_name}")
    rescue Hpe3parSdk::HPE3PARException => ex
      Puppet.err(ex.message)
      raise ex
    ensure
      cl.logout
    end
  end

  def remove_iscsi_path_from_host(host_name, iscsi_names, force_path_removal, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)
      mod_request = {'pathOperation' => Hpe3parSdk::HostEditOperation.const_get('REMOVE'),
                     'iSCSINames' => iscsi_names,
                     'forcePathRemoval' => force_path_removal}
      cl.modify_host(host_name, mod_request)
      Puppet.info("iSCSI path #{iscsi_names} removed from host #{host_name}")
    rescue Hpe3parSdk::HPE3PARException => ex
      Puppet.err(ex.message)
      raise ex
    ensure
      cl.logout
    end
  end

  def delete_host(host_name, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)
      cl.delete_host(host_name)
    rescue Hpe3parSdk::HPE3PARException => ex
      raise ex
    ensure
      cl.logout
    end
  end

  def host_exists?(name, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)
      cl.host_exists?(name)
    ensure
      cl.logout
    end
  end

  def create_flash_cache(size_in_gib, mode = nil, debug = false)
    mode = mode.to_s
    if mode == 'simulator'
      mode = 1
    else
      mode = 2
    end
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)
      cl.create_flash_cache(size_in_gib, mode)
    ensure
      cl.logout
    end
  end

  def delete_flash_cache(debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)
      cl.delete_flash_cache
    ensure
      cl.logout
    end
  end

  def flash_cache_exists?(debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)
      cl.flash_cache_exists?
    ensure
      cl.logout
    end
  end

  def initiator_chap_exists?(host_name, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)
      initiator_chap_enabled = cl.get_host(host_name).initiator_chap_enabled
      return initiator_chap_enabled
    ensure
      cl.logout
    end
  end

  def remove_volumes_from_volume_set(volume_set_name,
                                     setmembers, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)
      cl.remove_volumes_from_volume_set(volume_set_name, setmembers)
      Puppet.info("Removed volumes #{setmembers} from volume set #{volume_set_name} successfully")
    rescue Hpe3parSdk::HPE3PARException => ex
      Puppet.err(ex.message)
      raise ex
    ensure
      cl.logout
    end
  end

  def add_volumes_to_volume_set(volume_set_name,
                                setmembers, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)
      cl.add_volumes_to_volume_set(volume_set_name, setmembers)
      Puppet.info("Added volumes #{setmembers} to volume set #{volume_set_name} successfully")
    rescue Hpe3parSdk::HPE3PARException => ex
      Puppet.err(ex.message)
      raise ex
    ensure
      cl.logout
    end
  end

  def offline_clone_exists?(name, base_volume_name, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)
      return_val = (volume_exists?(name) and !online_physical_copy_exists?(base_volume_name, name) and offline_physical_copy_exists?(base_volume_name, name))
      return return_val
    ensure
      cl.logout
    end
  end

  def online_physical_copy_exists?(src_name, phy_copy_name, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)
      cl.online_physical_copy_exists?(src_name, phy_copy_name)
    ensure
      cl.logout
    end
  end

  def offline_physical_copy_exists?(src_name, phy_copy_name, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)
      cl.offline_physical_copy_exists?(src_name, phy_copy_name)
    ensure
      cl.logout
    end
  end

  def create_offline_clone(base_volume_name, clone_name,
                           dest_cpg=nil, online=false, save_snapshot=nil, priority=nil,
                           skip_zero=nil, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)
      optional = {:online => online,
                  :skipZero => skip_zero,
                  :saveSnapshot => save_snapshot
      }

      optional[:priority] = Hpe3parSdk::TaskPriority.const_get(priority)

      cl.create_physical_copy(base_volume_name, clone_name, dest_cpg, optional)
    ensure
      cl.logout
    end
  end

  def create_online_clone(base_volume_name, clone_name,
                          dest_cpg=nil, online=true, tpvv=nil, tdvv=nil, snap_cpg=nil,
                          compression=nil, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)
      optional = {:online => online,
                  :tpvv => tpvv,
                  :tdvv => tdvv,
                  :snapCPG => snap_cpg,
                  :compression => compression
      }
      cl.create_physical_copy(base_volume_name, clone_name, dest_cpg, optional)
    ensure
      cl.logout
    end
  end

  def resync_clone(clone_name, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)

      cl.resync_physical_copy(clone_name)
    ensure
      cl.logout
    end
  end

  def delete_clone(clone_name, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)

      cl.delete_volume(clone_name)
    ensure
      cl.logout
    end
  end

  def stop_clone(clone_name, debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)
      cl.stop_offline_physical_copy(clone_name)
    ensure
      cl.logout
    end
  end

  def get_storage_system_info(debug = false)
    cl = Hpe3parSdk::Client.new(@rest_url, debug: debug)
    begin
      cl.login(@url.user, @url.password)
      cl.get_storage_system_info
    ensure
      cl.logout
    end
  end
end
