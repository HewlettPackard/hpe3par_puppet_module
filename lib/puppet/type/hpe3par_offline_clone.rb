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

Puppet::Type.newtype(:hpe3par_offline_clone) do
  @doc = 'Virtual Volume Offline clone'

  apply_to_all

  ensurable do
    newvalue(:present) do
      provider.create
    end

    newvalue(:absent) do
      provider.destroy
    end

    newvalue(:resync) do
      provider.resync
    end

    newvalue(:stop) do
      provider.stop
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
    desc 'Name of the Offline clone.'
    validate do |name|
      fail('Name of the clone should not be empty or exceed 31 characters') unless name.length > 0 && name.length < 32
    end
  end

  newproperty(:base_volume_name) do
    desc 'Specifies the destination volume.'
  end

  newproperty(:dest_cpg) do
    desc 'Specifies the destination CPG for an online copy.'
  end

  newparam(:save_snapshot) do
    desc 'Enables (true) or disables (false) saving the the snapshot of the source volume after completing the copy of the volume. Defaults to false'
    newvalues(:true, :false)

    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  newparam(:priority) do
    desc 'Does not apply to online copy.'
    defaultto :MEDIUM
    newvalues(:HIGH, :MEDIUM, :LOW)
  end
  
  newparam(:skip_zero) do
    desc 'Enables (true) or disables (false) copying only allocated portions of the source VV from a thin provisioned source. Use only on a newly created destination, or if the destination was re-initialized to zero. Does not overwrite preexisting data on the destination VV to match the source VV unless the same offset is allocated in the source.'
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
