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

Puppet::Type.newtype(:hpe3par_host) do
  @doc = 'HPE 3PAR Host'

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

    newvalue(:add_initiator_chap) do
      provider.add_initiator_chap
    end

    newvalue(:remove_initiator_chap) do
      provider.remove_initiator_chap
    end

    newvalue(:add_target_chap) do
      provider.add_target_chap
    end

    newvalue(:remove_target_chap) do
      provider.remove_target_chap
    end

    newvalue(:add_fc_path_to_host) do
      provider.add_fc_path_to_host
    end

    newvalue(:remove_fc_path_from_host) do
      provider.remove_fc_path_from_host
    end

    newvalue(:add_iscsi_path_to_host) do
      provider.add_iscsi_path_to_host
    end

    newvalue(:remove_iscsi_path_from_host) do
      provider.remove_iscsi_path_from_host
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

  newparam(:host_name, :namevar => true) do
    desc 'Name of the 3PAR host.'
    validate do |host_name|
      fail('Name of the Host should not be empty or exceed 32 characters') unless host_name.length > 0 && host_name.length < 32
    end
  end

  newproperty(:domain) do
    desc 'Specifies the domain in which the host is created.'
  end

  newproperty(:fc_wwns, :array_matching => :all) do
    desc 'Specifies the WWNs to be specified for the host.'
  end

  newproperty(:iscsi_names, :array_matching => :all) do
    desc 'Specifies the ISCSI names to be set for the host.'
  end

  newproperty(:persona) do
    desc 'Specifies the domain in which the host is created.'
    newvalues(:GENERIC, :GENERIC_ALUA, :GENERIC_LEGACY, :HPUX_LEGACY, :AIX_LEGACY, :EGENERA, :ONTAP_LEGACY, :VMWARE, :OPENVMS, :HPUX, :WINDOWS_SERVER)
    defaultto :GENERIC_ALUA
  end

  newproperty(:new_name) do
    desc 'Specifies the new name for the host'
  end

  newproperty(:force_path_removal) do
    desc 'If true, remove WWN(s) or iSCSI(s) even if there are VLUNs that are exported to the host.'
    newvalues(:true, :false)

    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  newproperty(:chap_name) do
    desc 'The chap name.'
  end

  newproperty(:chap_secret) do
    desc 'The chap secret for the host or the target.'
  end

  newproperty(:chap_secret_hex) do
    desc 'If true, then chapSecret is treated as Hex.'
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
