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

Puppet::Type.newtype(:hpe3par_snapshot) do
  @doc = 'Virtual Volume Snapshot'

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

    newvalue(:restore_offline) do
      provider.restore_offline
    end

    newvalue(:restore_online) do
      provider.restore_online
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

  newparam(:name, :namevar => true) do
    desc 'Specifies a snapshot volume name up to 31 characters in length.'
    validate do |name|
      fail('Name of the snapshot should not be empty or exceed 31 characters') unless name.length > 0 && name.length < 32
    end
  end

  newproperty(:base_volume_name) do
    desc 'Specifies the source volume'
  end

  newproperty(:read_only) do
    desc 'true: Specifies that the copied volume is read-only. false: (default) The volume is read/write.'
    newvalues(:true, :false)

    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  newproperty(:expiration_time) do
    desc 'Specifies the relative time from the current time that the volume expires. Value is a positive integer and in the range of 1 to 43,800 hours, or 1825 days.'
    munge do |value|
      value.to_s.to_i
    end
  end

  newproperty(:retention_time) do
    desc 'Specifies the relative time from the current time that the volume will expire. Value is a positive integer and in the range of 1 to 43,800 hours, or 1825 days.'
    munge do |value|
      value.to_s.to_i
    end
  end

  newparam(:expiration_unit) do
    desc 'Unit of value'
    defaultto :Hours
    newvalues(:Hours, :Days)
    munge do |value|
      value.to_s
    end
  end

  newparam(:retention_unit) do
    desc 'Unit of value'
    defaultto :Hours
    newvalues(:Hours, :Days)
    munge do |value|
      value.to_s
    end
  end

  newparam(:expiration_hours) do
    desc 'Specifies the relative time from the current time that the volume expires. Value is a positive integer and in the range of 1 to 43,800 hours, or 1825 days.'
    defaultto :'0'

    munge do |value|
      value.to_s.to_i
    end
  end

  newparam(:retention_hours) do
    desc 'Specifies the relative time from the current time that the volume expires. Value is a positive integer and in the range of 1 to 43,800 hours, or 1825 days.'
    defaultto :'0'

    munge do |value|
      value.to_s.to_i
    end
  end

  newproperty(:online) do
    desc 'Enables (true) or disables (false) executing the promote operation on an online volume.'
    newvalues(:true, :false)

    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  newparam(:priority) do
    desc 'Does not apply to online promote operation or to stop promote operation.'
    defaultto :MEDIUM
    newvalues(:HIGH, :MEDIUM, :LOW)
  end

  newparam(:allow_remote_copy_parent) do
    desc 'Allows the promote operation to proceed even if the RW parent volume is currently in a Remote Copy volume group, if that group has not been started. If the Remote Copy group has been started, this command fails.'
    newvalues(:true, :false)

    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  newproperty(:new_name) do
    desc 'New name of the volume.'
  end

  newproperty(:snap_cpg) do
    desc 'Snap CPG name.'
  end

  newproperty(:rm_exp_time) do
    desc 'Enables (false) or disables (true) resetting the expiration time. If false, and expiration time value is a positive number, then set.'
    newvalues(:true, :false)

    munge do |value|
      @resource.munge_boolean(value)
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
