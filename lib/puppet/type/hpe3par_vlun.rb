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

Puppet::Type.newtype(:hpe3par_vlun) do
  @doc = 'VLUN'

  apply_to_all

  ensurable do

    newvalue(:export_volume_to_host) do
      provider.export_volume_to_host
    end

    newvalue(:unexport_volume_to_host) do
      provider.unexport_volume_to_host
    end

    newvalue(:export_volume_to_hostset) do
      provider.export_volume_to_hostset
    end

    newvalue(:unexport_volume_to_hostset) do
      provider.unexport_volume_to_hostset
    end

    newvalue(:export_volumeset_to_host) do
      provider.export_volumeset_to_host
    end

    newvalue(:unexport_volumeset_to_host) do
      provider.unexport_volumeset_to_host
    end

    newvalue(:export_volumeset_to_hostset) do
      provider.export_volumeset_to_hostset
    end

    newvalue(:unexport_volumeset_to_hostset) do
      provider.unexport_volumeset_to_hostset
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
  end

  newproperty(:volume_name) do
    desc 'Volume name.'
  end

  newproperty(:lunid) do
    desc 'LUN ID.'
  end

  newproperty(:volumeset_name) do
    desc 'Name of the VV set to export.'
  end

  newproperty(:hostset_name) do
    desc 'Name of the hostset.'
  end

  newproperty(:host_name) do
    desc 'Name of the host.'
  end

  newproperty(:slot) do
    desc 'PCI bus slot in the node.'
  end

  newproperty(:card_port) do
    desc 'Port number on the FC card.'
  end

  newproperty(:node_val) do
    desc 'System node.'
  end

  newproperty(:autolun) do
    desc 'States whether the lun nmber should be autosigned.'
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
