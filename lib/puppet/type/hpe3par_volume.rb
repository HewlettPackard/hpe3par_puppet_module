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

Puppet::Type.newtype(:hpe3par_volume) do
  @doc = 'Virtual Volume'

  apply_to_all

  ensurable do
    newvalue(:present) do
      provider.create
    end

    newvalue(:absent) do
      provider.destroy
    end

    newvalue(:modify) do
      provider.modify
    end

    newvalue(:grow) do
      provider.grow
    end

    newvalue(:grow_to_size) do
      provider.grow_to_size
    end

    newvalue(:change_snap_cpg) do
      provider.change_snap_cpg
    end

    newvalue(:change_user_cpg) do
      provider.change_user_cpg
    end

    newvalue(:convert_type) do
      provider.convert_type
    end

    newvalue(:set_snap_cpg) do
      provider.set_snap_cpg
    end

  end

  def munge_boolean(value)
    case value
      when true, 'true', :true #, 'yes', 'on'
        true
      when false, 'false', :false #, 'no', 'off'
        false
      else
        fail('munge_boolean only takes booleans')
    end
  end

  newparam(:volume_name, :namevar => true) do
    desc 'Name of the Virtual Volume.'
    validate do |volume_name|
      fail('Name of the Volume should not be empty or exceed 32 characters') unless volume_name.length > 0 && volume_name.length < 32
      fail('Name of the Volume should not contain special characters') unless volume_name.count("^a-zA-Z0-9_.-").zero?
      fail('First character of the Volume name should not begin with hyphen') unless volume_name[0].count("-").zero?
    end
  end

  newproperty(:cpg) do
    desc('Specifies the name of the CPG from which the volume user space will be allocated.')
  end

  newparam(:size) do
    desc('Specifies the size of the volume')
  end

  newparam(:size_unit) do
    desc('Specifies the unit of the volume size')
    defaultto :GiB
    newvalues(:MiB, :GiB, :TiB)

    munge do |value|
      value.to_s
    end
  end

  newproperty(:type) do
    desc('Specifies the type of the volume')
    defaultto :thin
    newvalues(:thin, :thin_dedupe, :full)

    munge do |value|
      value.to_s
    end
  end

  newproperty(:compression) do
    desc('Specifes whether the compression is on or off')
    defaultto :false
    newvalues(:true, :false)

    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  newproperty(:snap_cpg) do
    desc('Specifies the name of the CPG from which the snapshot space will be allocated.')
  end

  newparam(:keep_vv) do
    desc('Name of the new volume where the original logical disks are saved.')
  end

  newparam(:new_name) do
    desc('Specifies the new name for the volume.')
  end

  newparam(:wait_for_task_to_end) do
    desc <<-DESC
    Setting to true makes the resource to wait until a task (asynchronous operation, for ex: convert type) ends.
    DESC
    defaultto :false
    newvalues(:true, :false)

    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  newproperty(:ss_spc_alloc_warning_pct) do
    desc <<-DESC
      Generates a warning alert when the reserved snapshot space of the virtual volume
      exceeds the indicated percentage of the virtual volume size.
    DESC
    defaultto :'-1'
    munge do |value|
      value.to_s.to_i
    end
  end

  newproperty(:ss_spc_alloc_limit_pct) do
    desc <<-DESC
      Prevents the snapshot space of  the virtual volume
      from growing beyond the indicated percentage of the virtual volume size.
    DESC
    defaultto :'-1'
    munge do |value|
      value.to_s.to_i
    end
  end

  newproperty(:rm_ss_spc_alloc_warning) do
    desc <<-DESC
      Enables (false) or disables (true) removing the snapshot space allocation warning.
      If false, and warning value is a positive number, then set.
    DESC
    defaultto :false
    newvalues(:true, :false)

    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  newproperty(:usr_spc_alloc_warning_pct) do
    desc <<-DESC
      Generates a warning alert when the user data space of the TPVV exceeds
      the specified percentage of the virtual volume size.
    DESC
    defaultto :'-1'
    munge do |value|
      value.to_s.to_i
    end
  end

  newproperty(:usr_spc_alloc_limit_pct) do
    desc <<-DESC
    Prevents the user space of the TPVV from growing beyond the indicated percentage of the virtual volume size.
    After reaching this limit, any new writes to the virtual volume will fail.
    DESC
    defaultto :'-1'
    munge do |value|
      value.to_s.to_i
    end
  end

  newproperty(:rm_usr_spc_alloc_warning) do
    desc <<-DESC
     Enables (false) or disables (true) removing the user space allocation warning.
     If false, and warning value is a positive number, then set
    DESC
    defaultto :false
    newvalues(:true, :false)

    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  newproperty(:rm_ss_spc_alloc_limit) do
    desc <<-DESC
     Enables (false) or disables (true) removing the snapshot space allocation limit.
     If false, and limit value is 0, setting  ignored.If false, and limit value is a positive number, then set
    DESC
    defaultto :false
    newvalues(:true, :false)

    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  newproperty(:rm_usr_spc_alloc_limit) do
    desc <<-DESC
      Enables (false) or disables (true)false) the allocation limit.
      If false, and limit value is a positive number, then set.
    DESC
    defaultto :false
    newvalues(:true, :false)

    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  newproperty(:rm_exp_time) do
    desc <<-DESC
       Enables (false) or disables (true) resetting the expiration time.
       If false, and expiration time value is a positive number, then set.
    DESC
    defaultto :false
    newvalues(:true, :false)

    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  newproperty(:expiration_hours) do
    desc('Remaining time, in hours, before the volume expires.')
    defaultto :'-1'
    munge do |value|
      value.to_s.to_i
    end
  end

  newproperty(:retention_hours) do
    desc('Sets the number of hours to retain the volume.')
    defaultto :'-1'
    munge do |value|
      value.to_s.to_i
    end
  end

  newparam(:ssip) do
    desc 'The storage system IP address or FQDN.'
  end

  newparam(:user) do
    desc 'The storage system user name.'
  end

  newparam(:password) do
    desc 'The password for the storage system User.'
  end

  newparam(:url) do
    desc <<-DESC
    If using URL do not use ssip, user, and password.
    URL in the form of https://user:password@ssip:8080/
    DESC
  end
  
  newparam(:debug) do
    desc 'If true, Debug mode set to true.'
    newvalues(:true, :false)
    defaultto :false

    munge do |value|
      @resource.munge_boolean(value)
    end
  end 
 
end
