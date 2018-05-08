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

describe Puppet::Type.type(:hpe3par_online_clone).provider(:hpe3par_online_clone) do

  describe "when asking exists?" do
    let :clone_obj do
      Puppet::Type.type(:hpe3par_online_clone).new(
        :name           => 'clone01',
        :url         => 'https://10.10.10.1',
        :ensure => 'present'
    )
    end
    it "should return true if resource is present" do
      url = 'https://chefsuper:chefSUPER@10.10.10.1:8080'
      hpe3parapi = HPE3PAR_API.new(url)
      described_class.stubs(:transport).returns hpe3parapi
      hpe3parapi.stubs(:volume_exists?).returns true
      Puppet::Type.type(:hpe3par_online_clone).stubs(:defaultprovider).returns described_class
      clone_obj.provider.should be_exists
    end
  end
  
  describe "when asking absent?" do
    let :clone_obj do
      Puppet::Type.type(:hpe3par_online_clone).new(
        :name           => 'clone01',
        :url         => 'https://10.10.10.1',
        :ensure => 'absent'
    )
    end
    it "should return true if resource is present" do
      url = 'https://chefsuper:chefSUPER@10.10.10.1:8080'
      hpe3parapi = HPE3PAR_API.new(url)
      described_class.stubs(:transport).returns hpe3parapi
      hpe3parapi.stubs(:volume_exists?).returns false
      Puppet::Type.type(:hpe3par_online_clone).stubs(:defaultprovider).returns described_class
      clone_obj.provider.should_not be_exists
    end
  end
  
  describe "create, delete, resync and stop" do
    let :clone_obj do
      Puppet::Type.type(:hpe3par_online_clone).new(
        :name           => 'clone01',
        :url         => 'https://10.10.10.1'
      )
    end
    
    it "should create online clone" do
      url = 'https://chefsuper:chefSUPER@10.10.10.1:8080'
      hpe3parapi = HPE3PAR_API.new(url)
      described_class.stubs(:transport).returns hpe3parapi
      hpe3parapi.stubs(:create_online_clone).returns true
      Puppet::Type.type(:hpe3par_online_clone).stubs(:defaultprovider).returns described_class
      clone_obj.provider.create
    end
    it "should delete online clone" do
      url = 'https://chefsuper:chefSUPER@10.10.10.1:8080'
      hpe3parapi = HPE3PAR_API.new(url)
      described_class.stubs(:transport).returns hpe3parapi
      hpe3parapi.stubs(:delete_clone).returns true
      Puppet::Type.type(:hpe3par_online_clone).stubs(:defaultprovider).returns described_class
      clone_obj.provider.destroy
    end

    it "should resync online clone" do
      url = 'https://chefsuper:chefSUPER@10.10.10.1:8080'
      hpe3parapi = HPE3PAR_API.new(url)
      described_class.stubs(:transport).returns hpe3parapi
      hpe3parapi.stubs(:resync_clone).returns true
      Puppet::Type.type(:hpe3par_online_clone).stubs(:defaultprovider).returns described_class
      clone_obj.provider.resync
    end
  end
end
