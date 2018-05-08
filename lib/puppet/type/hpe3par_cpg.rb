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

Puppet::Type.newtype(:hpe3par_cpg) do
  @doc = 'Common Provisioning Group (CPG)'

  ensurable
  apply_to_all

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
    desc 'Name of the CPG.'
    validate do |name|
      fail('Name of the CPG should not be empty or exceed 31 characters') unless name.length > 0 && name.length < 32
    end
  end

  newproperty(:raid_type) do
    desc 'Specifies the RAID type for the logical disk.'
    newvalues(:R0, :R1, :R5, :R6)
    
    munge do |value|
      value.to_s
    end
  end

  newproperty(:set_size) do
    desc 'Specifies the set size in the number of chunklets.'
    defaultto :'-1'

    munge do |value|
      value.to_s.to_i
    end
  end

  newproperty(:high_availability) do
    desc 'Specifies that the layout must support the failure of one port pair, one cage, or one magazine.'
    newvalues(:PORT, :CAGE, :MAG)
  end

  newproperty(:disk_type) do
    desc 'Specifies that physical disks must have the specified device type.'
    newvalues(:FC, :NL, :SSD)
  end

  newproperty(:growth_increment) do
    desc 'Specifies the growth increment the amount of logical disk storage created on each auto-grow operation.'
    defaultto :'-1.0'

    munge do |value|
      value.to_s.to_f
    end
  end

  newparam(:growth_increment_unit) do
    desc 'Unit of value'
    defaultto :GiB
    newvalues(:MiB, :GiB, :TiB)

    munge do |value|
      value.to_s
    end
  end

  newproperty(:growth_limit) do
    desc 'Specifies that the autogrow operation is limited to the specified storage amount that sets the growth limit.'
    defaultto :'-1.0'

    munge do |value|
      value.to_s.to_f
    end
  end

  newparam(:growth_limit_unit) do
    desc 'Unit of value.'
    defaultto :GiB
    newvalues(:MiB, :GiB, :TiB)

    munge do |value|
      value.to_s
    end
  end

  newproperty(:growth_warning) do
    desc 'Specifies that the threshold of used logical disk space when exceeded results in a warning alert.'
    defaultto :'-1.0'

    munge do |value|
      value.to_s.to_f
    end
  end

  newparam(:growth_warning_unit) do
    desc 'Unit of value'
    defaultto :GiB
    newvalues(:MiB, :GiB, :TiB)

    munge do |value|
      value.to_s
    end
  end

  newparam(:domain) do
    desc 'Specifies the domain in which the CPG will reside.'
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
