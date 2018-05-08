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

Puppet::Type.type(:hpe3par_qos).provide(:hpe3par_qos,
                                        :parent => Puppet::Provider::HPE3PAR) do
  desc 'Provider implementation for QOS.'
  mk_resource_methods

  confine :feature => :hpe3parsdk

  def exists?
      return transport(conn_info).qos_rule_exists?(resource[:qos_target_name], resource[:type], resource[:debug])
  end

  def create
    begin
      if resource[:latency_goal] != -1 && resource[:latency_goal_usecs] != -1
        raise ArgumentError, 'Attributes latency_goal and latency_goal_usecs cannot be given at the same time for qos rules creation'
      end
      create_qos(resource)
      Puppet.info("Created qos  #{name} successfully")
    rescue Hpe3parSdk::HPE3PARException => ex
      fail(ex.message)
    rescue Exception => ex
      fail(ex.message)
    end

  end

  def modify
    begin
      modify_qos(resource)
      Puppet.info("Modified qos  #{name} successfully")
    rescue Hpe3parSdk::HPE3PARException => ex
      fail(ex.message)
    rescue Exception => ex
      fail(ex.message)
    end

  end


  def destroy
    begin
      transport(conn_info).delete_qos_rules(resource[:qos_target_name], resource[:type], resource[:debug])
      Puppet.info("Deleted qos #{name} successfully")
    rescue Hpe3parSdk::HPE3PARException => ex
      fail(ex.message)
    rescue Exception => ex
      fail(ex.message)
    end
  end

  def create_qos(resource)
    transport(conn_info).create_qos_rules(resource[:qos_target_name], resource[:type], resource[:priority], resource[:bwmin_goal_kb], resource[:bwmax_limit_kb], resource[:iomin_goal], resource[:iomax_limit], resource[:bwmax_limit_op], resource[:bwmin_goal_op], resource[:iomin_goal_op], resource[:iomax_limit_op], resource[:latency_goal], resource[:default_latency], resource[:enable], resource[:latency_goal_usecs], resource[:debug])
  end


  def modify_qos(resource)
    transport(conn_info).modify_qos_rules(resource[:qos_target_name], resource[:type], resource[:priority], resource[:bwmin_goal_kb], resource[:bwmax_limit_kb], resource[:iomin_goal], resource[:iomax_limit], resource[:bwmax_limit_op], resource[:bwmin_goal_op], resource[:iomin_goal_op], resource[:iomax_limit_op], resource[:latency_goal], resource[:default_latency], resource[:enable], resource[:latency_goal_usecs], resource[:debug])

  end
end
