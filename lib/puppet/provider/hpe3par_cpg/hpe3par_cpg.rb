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

Puppet::Type.type(:hpe3par_cpg).provide(:hpe3par_cpg,
                                        :parent => Puppet::Provider::HPE3PAR) do
  desc 'Provider implementation for CPG.'
  mk_resource_methods
 
 confine :feature => :hpe3parsdk

  def exists?
    return transport(conn_info).cpg_exists?(resource[:name], resource[:debug])
  end

  def create
    validate_set_size(resource[:raid_type], resource[:set_size])
    begin
      create_cpg(resource)
      Puppet.info("Created CPG #{name} successfully")
    rescue Hpe3parSdk::HPE3PARException => ex
      fail(ex.message)
    end

  end

  def destroy
    begin
      transport(conn_info).delete_cpg(resource[:name], resource[:debug])
      Puppet.info("Deleted CPG #{name} successfully")
    rescue Hpe3parSdk::HPE3PARException => ex
      fail(ex.message)
    end
  end

  def create_cpg(resource)
    transport(conn_info).create_cpg(resource[:name], resource[:domain], resource[:growth_increment],
                                    resource[:growth_increment_unit], resource[:growth_limit], resource[:growth_limit_unit],
                                    resource[:growth_warning], resource[:growth_warning_unit], resource[:raid_type],
                                    resource[:set_size], resource[:high_availability], resource[:disk_type], resource[:debug])
  end

  def validate_set_size(raid_type, set_size)
    if !raid_type.nil? && !set_size.nil?
      set_size_array = Hpe3parSdk::RaidTypeSetSizeMap.const_get(raid_type)
      fail("Incorrect set size #{set_size} for RAID type #{raid_type}.
             The valid values are: #{set_size_array}") unless set_size_array.include? set_size
    end
  end

end