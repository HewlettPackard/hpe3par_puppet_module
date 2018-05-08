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

Puppet::Type.newtype(:hpe3par_qos) do
  @doc = 'Quality of Service'

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

  end


  newparam(:qos_target_name, :namevar => true) do
    desc 'The name of the target object on which the new QoS rules will be created.'
    validate do |qos_target_name|
      fail('qos_target_name cannot be empty') unless !qos_target_name.nil?
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

  newproperty(:type) do
    desc 'Type of QoS target.'
    newvalues(:VVSET, :SYS)
  end

  newproperty(:priority) do
    desc 'QoS priority.'
    newvalues(:LOW, :NORMAL, :HIGH)
  end

  newproperty(:bwmin_goal_kb) do
    desc 'Bandwidth rate minimum goal in kilobytes per second.'
    defaultto :'-1.0'

    munge do |value|
      value.to_s.to_i
    end
  end

  newproperty(:bwmax_limit_kb) do
    desc 'Bandwidth rate maximum limit in kilobytes per second.'
    defaultto :'-1.0'

    munge do |value|
      value.to_s.to_i
    end
  end

  newproperty(:iomin_goal) do
    desc 'I/O-per-second minimum goal.'
    defaultto :'-1.0'

    munge do |value|
      value.to_s.to_i
    end
  end

  newproperty(:iomax_limit) do
    desc 'I/O-per-second maximum limit.'
    defaultto :'-1.0'

    munge do |value|
      value.to_s.to_i
    end
  end

  newproperty(:bwmin_goal_op) do
    desc <<-DESC
    When set to ZERO, the bandwidth
    minimum goal is 0.
        When set to NOLIMIT, the bandwidth
    minimum goal is none
    DESC
    newvalues(:ZERO, :NOLIMIT)
  end
  newproperty(:bwmax_limit_op) do
    desc <<-DESC
    When set to ZERO, the bandwidth
    minimum goal is 0.
        When set to NOLIMIT, the bandwidth
    minimum goal is none
    DESC
    newvalues(:ZERO, :NOLIMIT)
  end
  newproperty(:iomin_goal_op) do
    desc <<-DESC
    When set to ZERO, the bandwidth
    minimum goal is 0.
        When set to NOLIMIT, the bandwidth
    minimum goal is none
    DESC
    newvalues(:ZERO, :NOLIMIT)
  end
  newproperty(:iomax_limit_op) do
    desc <<-DESC
    When set to ZERO, the bandwidth
    minimum goal is 0.
        When set to NOLIMIT, the bandwidth
    minimum goal is none
    DESC
    newvalues(:ZERO, :NOLIMIT)
  end

  newproperty(:latency_goal) do
    desc 'Latency goal in milliseconds.'
    defaultto :'-1.0'

    munge do |value|
      value.to_s.to_i
    end
  end

  newparam(:default_latency) do
    desc <<-DESC
    If true, set latencyGoal to the default value.
    If false and the latencyGoal value is positive, then set the value.
    Default is false.
    DESC
    defaultto :false
    newvalues(:true, :false)

    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  newproperty(:enable) do
    desc <<-DESC
    If true, enable the QoS rule for the target object.
    If false, disable the QoS rule for the target object.
    DESC
  end

  newproperty(:latency_goal_usecs) do
    desc 'Latency goal in microseconds.'
    defaultto :'-1.0'

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
