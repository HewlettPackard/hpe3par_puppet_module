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

require 'rspec'
require 'spec_helper'
require 'puppet/provider'
require 'puppet/util'
require 'puppet/util//hpe3par_api'

describe Puppet::Type.type(:hpe3par_hostset).provider(:hpe3par_hostset) do
  let :hostset_obj do
    Puppet::Type.type(:hpe3par_hostset).new(
      :name           => 'hostset_01',
      :url         => 'https://10.10.10.1'
    )
  end

  let :provider do
    described_class.new(
      :name => 'hpe3par_hostset'
    )
  end
  
  describe "when asking exists?" do
    it "should return true if resource is present" do
      url = 'https://chefsuper:chefSUPER@10.10.10.1:8080'
      hpe3parapi = HPE3PAR_API.new(url)
      described_class.stubs(:transport).returns hpe3parapi
      hpe3parapi.stubs(:hostset_exists?).returns true
      Puppet::Type.type(:hpe3par_hostset).stubs(:defaultprovider).returns described_class
      hostset_obj.provider.should be_exists
    end

    it "should return false if resource is absent" do
      url = 'https://chefsuper:chefSUPER@10.10.10.1:8080'
      hpe3parapi = HPE3PAR_API.new(url)
      described_class.stubs(:transport).returns hpe3parapi
      hpe3parapi.stubs(:hostset_exists?).returns false
      Puppet::Type.type(:hpe3par_hostset).stubs(:defaultprovider).returns described_class
    
      hostset_obj.provider.should_not be_exists
    end
  end
  
  describe "create, delete, add hosts and remove hosts" do  
    it "should create the hostset" do
      url = 'https://chefsuper:chefSUPER@10.10.10.1:8080'
      hpe3parapi = HPE3PAR_API.new(url)
      described_class.stubs(:transport).returns hpe3parapi
  
      hpe3parapi.stubs(:create_host_set).returns true
      Puppet::Type.type(:hpe3par_hostset).stubs(:defaultprovider).returns described_class
      hostset_obj.provider.create
    end

    it "should delete the hostset" do
      url = 'https://chefsuper:chefSUPER@10.10.10.1:8080'
      hpe3parapi = HPE3PAR_API.new(url)
      described_class.stubs(:transport).returns hpe3parapi
  
      hpe3parapi.stubs(:delete_host_set).returns true
      Puppet::Type.type(:hpe3par_hostset).stubs(:defaultprovider).returns described_class
      hostset_obj.provider.destroy
    end 

    it "should add hosts the hostset" do
      url = 'https://chefsuper:chefSUPER@10.10.10.1:8080'
      hpe3parapi = HPE3PAR_API.new(url)
      described_class.stubs(:transport).returns hpe3parapi
  
      hpe3parapi.stubs(:add_hosts_to_host_set).returns true
      Puppet::Type.type(:hpe3par_hostset).stubs(:defaultprovider).returns described_class
      hostset_obj.provider.add_host
    end

    it "should delete the hostset" do
      url = 'https://chefsuper:chefSUPER@10.10.10.1:8080'
      hpe3parapi = HPE3PAR_API.new(url)
      described_class.stubs(:transport).returns hpe3parapi
  
      hpe3parapi.stubs(:remove_hosts_from_host_set).returns true
      Puppet::Type.type(:hpe3par_hostset).stubs(:defaultprovider).returns described_class
      hostset_obj.provider.remove_host
    end
  end
end
