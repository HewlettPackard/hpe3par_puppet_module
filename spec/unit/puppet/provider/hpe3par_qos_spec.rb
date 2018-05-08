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

describe Puppet::Type.type(:hpe3par_qos).provider(:hpe3par_qos) do
  let :qos_obj do
    Puppet::Type.type(:hpe3par_qos).new(
      :name           => 'qos_01',
      :url         => 'https://10.10.10.1'
    )
  end
  
  let :qos_obj1 do
    Puppet::Type.type(:hpe3par_qos).new(
      :name           => 'qos_01',
      :url         => 'https://10.10.10.1',
      :type =>  'VVSET'
    )
  end

  let :provider do
    described_class.new(
      :name => 'hpe3par_qos'
    )
  end
  
  describe "when asking exists?" do
    it "should return true if resource is present" do
      url = 'https://chefsuper:chefSUPER@10.10.10.1:8080'
      hpe3parapi = HPE3PAR_API.new(url)
      described_class.stubs(:transport).returns hpe3parapi
      hpe3parapi.stubs(:qos_rule_exists?).returns true
      Puppet::Type.type(:hpe3par_qos).stubs(:defaultprovider).returns described_class

      qos_obj1.provider.should be_exists
    end

    it "should return false if resource is absent" do
      url = 'https://chefsuper:chefSUPER@10.10.10.1:8080'
      hpe3parapi = HPE3PAR_API.new(url)
      described_class.stubs(:transport).returns hpe3parapi
      hpe3parapi.stubs(:qos_rule_exists?).returns false
      Puppet::Type.type(:hpe3par_qos).stubs(:defaultprovider).returns described_class
    
      qos_obj.provider.should_not be_exists
    end
  end
  
  describe "create, delete, ans modify QOS rule" do  
    it "should create the qos rule" do
      url = 'https://chefsuper:chefSUPER@10.10.10.1:8080'
      hpe3parapi = HPE3PAR_API.new(url)
      described_class.stubs(:transport).returns hpe3parapi
  
      hpe3parapi.stubs(:create_qos_rules).returns true
      Puppet::Type.type(:hpe3par_qos).stubs(:defaultprovider).returns described_class
      qos_obj.provider.create
    end

    it "should delete the qos rule" do
      url = 'https://chefsuper:chefSUPER@10.10.10.1:8080'
      hpe3parapi = HPE3PAR_API.new(url)
      described_class.stubs(:transport).returns hpe3parapi
  
      hpe3parapi.stubs(:delete_qos_rules).returns true
      Puppet::Type.type(:hpe3par_qos).stubs(:defaultprovider).returns described_class
      qos_obj.provider.destroy
    end 

    it "should modify the qos rule" do
      url = 'https://chefsuper:chefSUPER@10.10.10.1:8080'
      hpe3parapi = HPE3PAR_API.new(url)
      described_class.stubs(:transport).returns hpe3parapi
  
      hpe3parapi.stubs(:modify_qos_rules).returns true
      Puppet::Type.type(:hpe3par_qos).stubs(:defaultprovider).returns described_class
      qos_obj.provider.modify
    end
  end
end