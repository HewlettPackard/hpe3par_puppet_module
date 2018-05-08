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

Puppet::Type.newtype(:hpe3par_volume_set) do
  @doc = 'Virtual Volume Set'

  apply_to_all

  ensurable do

    newvalue(:present) do
      provider.create
    end

    newvalue(:absent) do
      provider.destroy
    end

    newvalue(:add_volume) do
      provider.add_volume
    end

    newvalue(:remove_volume) do
      provider.remove_volume
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

  newparam(:volume_set_name, :namevar => true) do
    desc 'Name of the Virtual Volume set.'
    validate do |volume_set_name|
      fail('Name of the Volume Set should not be empty or exceed 27 characters') unless volume_set_name.length > 0 && volume_set_name.length < 28
      fail('Name of the Volume Set should not contain special characters') unless volume_set_name.count("^a-zA-Z0-9_.-").zero?
      fail('First character of the Volume Set should not begin with hyphen') unless volume_set_name[0].count("-").zero?
    end  
  end

  newproperty(:domain) do
    desc 'The domain into which VV set is to be added.'
  end

  newproperty(:setmembers, :array_matching => :all) do
    desc 'The virtual volume to be added'
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

