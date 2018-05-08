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

require 'spec_helper'

describe Puppet::Type.type(:hpe3par_vlun) do

  before do
    @vlun_example = {
      :name => 'cifsh'
    }
    described_class.provider(:hpe3par_vlun).new(@vlun_example)
  end

  let :vlun_resource do
    @vlun_example
  end
  
  it "should have :name be its namevar" do
    expect(described_class.key_attributes).to eq([:name])
  end
  
  it "should fail without namevar name" do
    expect{described_class.new(:ensure => :export_volume_to_host)[:name]}.to raise_error(Puppet::Error, 'Title or name must be provided')
  end
  
  it "should validate name of vlun" do
    expect(described_class.new(:name => 'cifsh', :ensure => :export_volume_to_host)[:name]).to eq('cifsh')
  end
  
  it "should validate volume_name of vlun" do
    expect(described_class.new(:name => 'cifsh', :volume_name => 'vol_01', :ensure => :export_volume_to_host)[:volume_name]).to eq('vol_01')
  end
  
  it "should validate lunid of vlun" do
    expect(described_class.new(:name => 'cifsh', :lunid => '8', :ensure => :export_volume_to_host)[:lunid]).to eq('8')
  end
  
  it "should validate volumeset_name of vlun" do
    expect(described_class.new(:name => 'cifsh', :volumeset_name => 'volset_01', :ensure => :export_volume_to_host)[:volumeset_name]).to eq('volset_01')
  end 

  it "should validate hostset_name of vlun" do
    expect(described_class.new(:name => 'cifsh', :hostset_name => 'hostset_01', :ensure => :export_volume_to_host)[:hostset_name]).to eq('hostset_01')
  end
  
  it "should validate host_name of vlun" do
    expect(described_class.new(:name => 'cifsh', :host_name => 'host_01', :ensure => :export_volume_to_host)[:host_name]).to eq('host_01')
  end    
  
  it "should validate slot of vlun" do
    expect(described_class.new(:name => 'cifsh', :slot => 'slot_01', :ensure => :export_volume_to_host)[:slot]).to eq('slot_01')
  end
  
  it "should validate card_port of vlun" do
    expect(described_class.new(:name => 'cifsh', :card_port => 'cp_01', :ensure => :export_volume_to_host)[:card_port]).to eq('cp_01')
  end 

  it "should validate node_val of vlun" do
    expect(described_class.new(:name => 'cifsh', :node_val => 'nv_01', :ensure => :export_volume_to_host)[:node_val]).to eq('nv_01')
  end
  
  it "should validate autolun of vlun" do
    expect(described_class.new(:name => 'cifsh', :autolun => 'true', :ensure => :export_volume_to_host)[:autolun]).to eq('true')
  end 
end
