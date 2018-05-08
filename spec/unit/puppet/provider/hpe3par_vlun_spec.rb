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

describe Puppet::Type.type(:hpe3par_vlun).provider(:hpe3par_vlun) do

  let :provider do
    described_class.new(
      :name => 'hpe3par_vlun'
    )
  end

  describe "export volume to host" do 
    let :vlun_export_to_host_obj do
      Puppet::Type.type(:hpe3par_vlun).new(
        :name => 'vlun_01',
        :url => 'https://10.10.10.1',
        :volume_name => 'vol_01',
        :host_name => 'host_01',
        :lunid => '6',
        :ensure => :export_volume_to_host
      )  
    end

    it "should export volume to host" do
      url = 'https://chefsuper:chefSUPER@10.10.10.1:8080'
      hpe3parapi = HPE3PAR_API.new(url)
      described_class.stubs(:transport).returns hpe3parapi
      hpe3parapi.stubs(:vlun_exists?).returns false
      hpe3parapi.stubs(:create_vlun).returns true
      Puppet::Type.type(:hpe3par_vlun).stubs(:defaultprovider).returns described_class
      vlun_export_to_host_obj.provider.export_volume_to_host
    end
  end
  
  describe "export volume to hostset" do 
    let :vlun_export_to_hostset_obj do
      Puppet::Type.type(:hpe3par_vlun).new(
        :name           => 'vlun_01',
        :url         => 'https://10.10.10.1',
        :volume_name => 'vol_01',
        :hostset_name => 'hostset_01',
        :ensure => :export_volume_to_hostset
      )  
    end

    it "should export volume to hostset" do
      url = 'https://chefsuper:chefSUPER@10.10.10.1:8080'
      hpe3parapi = HPE3PAR_API.new(url)
      described_class.stubs(:transport).returns hpe3parapi
      hpe3parapi.stubs(:vlun_exists?).returns false
      hpe3parapi.stubs(:create_vlun).returns true
      Puppet::Type.type(:hpe3par_vlun).stubs(:defaultprovider).returns described_class
      vlun_export_to_hostset_obj.provider.export_volume_to_hostset
    end
  end

  describe "export volumeset to hostset" do 
    let :vlun_export_to_host_obj do
      Puppet::Type.type(:hpe3par_vlun).new(
        :name           => 'vlun_01',
        :url         => 'https://10.10.10.1',
        :volumeset_name => 'volset_01',
        :hostset_name => 'hostset_01',
        :ensure => :export_volumeset_to_hostset
      )  
    end

    it "should export volumeset to hostset" do
      url = 'https://chefsuper:chefSUPER@10.10.10.1:8080'
      hpe3parapi = HPE3PAR_API.new(url)
      described_class.stubs(:transport).returns hpe3parapi
      hpe3parapi.stubs(:vlun_exists?).returns false
      hpe3parapi.stubs(:create_vlun).returns true
      Puppet::Type.type(:hpe3par_vlun).stubs(:defaultprovider).returns described_class
      vlun_export_to_host_obj.provider.export_volumeset_to_hostset
    end
  end

  describe "export volume set to host" do 
    let :vlun_export_to_host_obj do
      Puppet::Type.type(:hpe3par_vlun).new(
        :name           => 'vlun_01',
        :url         => 'https://10.10.10.1',
        :volumeset_name => 'volset_01',
        :lunid => '6',
        :host_name => 'host_01',
        :ensure => :export_volumeset_to_host
      )  
    end

    it "should export volume set to host" do
      url = 'https://chefsuper:chefSUPER@10.10.10.1:8080'
      hpe3parapi = HPE3PAR_API.new(url)
      described_class.stubs(:transport).returns hpe3parapi
      hpe3parapi.stubs(:vlun_exists?).returns false
      hpe3parapi.stubs(:create_vlun).returns true
      Puppet::Type.type(:hpe3par_vlun).stubs(:defaultprovider).returns described_class
      vlun_export_to_host_obj.provider.export_volumeset_to_host
    end
  end
    
  describe "unexport volume to host" do 
    let :vlun_export_to_host_obj do
      Puppet::Type.type(:hpe3par_vlun).new(
        :name           => 'vlun_01',
        :url         => 'https://10.10.10.1',
        :volume_name => 'vol_01',
        :host_name => 'host_01',
        :lunid => '6',
        :ensure => :unexport_volume_to_host
      )  
    end

    it "should export volume to host" do
      url = 'https://chefsuper:chefSUPER@10.10.10.1:8080'
      hpe3parapi = HPE3PAR_API.new(url)
      described_class.stubs(:transport).returns hpe3parapi
      hpe3parapi.stubs(:vlun_exists?).returns true
      hpe3parapi.stubs(:delete_vlun).returns true
      Puppet::Type.type(:hpe3par_vlun).stubs(:defaultprovider).returns described_class
      vlun_export_to_host_obj.provider.unexport_volume_to_host
    end
  end

  describe "unexport volume to hostset" do 
    let :vlun_export_to_host_obj do
      Puppet::Type.type(:hpe3par_vlun).new(
        :name           => 'vlun_01',
        :url         => 'https://10.10.10.1',
        :volume_name => 'vol_01',
        :lunid => '6',
        :hostset_name => 'hostset_01',
        :ensure => :unexport_volume_to_hostset
      )  
    end

    it "should unexport volume to hostset" do
      url = 'https://chefsuper:chefSUPER@10.10.10.1:8080'
      hpe3parapi = HPE3PAR_API.new(url)
      described_class.stubs(:transport).returns hpe3parapi
      hpe3parapi.stubs(:vlun_exists?).returns true
      hpe3parapi.stubs(:delete_vlun).returns true
      Puppet::Type.type(:hpe3par_vlun).stubs(:defaultprovider).returns described_class
      vlun_export_to_host_obj.provider.unexport_volume_to_hostset
    end
  end
  
  describe "unexport volume set to host" do 
    let :vlun_export_to_host_obj do
      Puppet::Type.type(:hpe3par_vlun).new(
        :name           => 'vlun_01',
        :url         => 'https://10.10.10.1',
        :volumeset_name => 'volset_01',
        :lunid => '6',
        :host_name => 'host_01',
        :ensure => :unexport_volumeset_to_host
      )  
    end

    it "should export volume set to host" do
      url = 'https://chefsuper:chefSUPER@10.10.10.1:8080'
      hpe3parapi = HPE3PAR_API.new(url)
      described_class.stubs(:transport).returns hpe3parapi
      hpe3parapi.stubs(:vlun_exists?).returns true
      hpe3parapi.stubs(:delete_vlun).returns true
      Puppet::Type.type(:hpe3par_vlun).stubs(:defaultprovider).returns described_class
      vlun_export_to_host_obj.provider.unexport_volumeset_to_host
    end
  end

  describe "export volume set to host set" do 
    let :vlun_export_to_host_obj do
      Puppet::Type.type(:hpe3par_vlun).new(
        :name           => 'vlun_01',
        :url         => 'https://10.10.10.1',
        :volumeset_name => 'volset_01',
        :lunid => '6',
        :hostset_name => 'hostset_01',
        :ensure => :export_volumeset_to_hostset
      )  
    end

    it "should export volume set to host set" do
      url = 'https://chefsuper:chefSUPER@10.10.10.1:8080'
      hpe3parapi = HPE3PAR_API.new(url)
      described_class.stubs(:transport).returns hpe3parapi
      hpe3parapi.stubs(:vlun_exists?).returns true
      hpe3parapi.stubs(:create_vlun).returns true
      Puppet::Type.type(:hpe3par_vlun).stubs(:defaultprovider).returns described_class
      vlun_export_to_host_obj.provider.export_volumeset_to_hostset
    end
  end
end

