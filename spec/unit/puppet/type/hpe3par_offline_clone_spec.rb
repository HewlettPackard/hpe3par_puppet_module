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

describe Puppet::Type.type(:hpe3par_offline_clone) do

  before do
    @offline_clone_example = {
      :name => 'cifsh'
    }
    described_class.provider(:hpe3par_offline_clone).new(@offline_clone_example)
  end

  let :offline_clone_resource do
    @offline_clone_example
  end
  
  it "should have :name be its namevar" do
    expect(described_class.key_attributes).to eq([:name])
  end
  
  it "should fail without namevar name" do
    expect{described_class.new(:ensure => :present)[:name]}.to raise_error(Puppet::Error, 'Title or name must be provided')
  end
  
  it "should validate name of offline_clone" do
    expect(described_class.new(:name => 'cifsh', :ensure => :present)[:name]).to eq('cifsh')
  end

  it "should fail if :name is longer than 32 characters" do
    offline_clone_name = 'cifshgcjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjbh'
    expect{ described_class.new(:name => offline_clone_name, :ensure => :present)[:name]}.to raise_error(Puppet::ResourceError, "Parameter name failed on Hpe3par_offline_clone[#{offline_clone_name}]: Name of the clone should not be empty or exceed 31 characters")
  end

  it "should fail if :name is empty" do
    expect{ described_class.new(:name => '', :ensure => :present)[:name]}.to raise_error(Puppet::ResourceError, 'Parameter name failed on Hpe3par_offline_clone[]: Name of the clone should not be empty or exceed 31 characters')
  end
  
  it "should validate base volume name of offline_clone" do
    expect(described_class.new(:name => 'cifsh', :base_volume_name => 'base_volume', :ensure => :present)[:base_volume_name]).to eq('base_volume')
  end
  
  it "should validate destination cpg of offline_clone" do
    expect(described_class.new(:name => 'cifsh', :dest_cpg => 'destination_cpg', :ensure => :present)[:dest_cpg]).to eq('destination_cpg')
  end
  
  it "should validate save_snapshot of offline_clone when set to true" do
    expect(described_class.new(:name => 'cifsh', :save_snapshot => true, :ensure => :present)[:save_snapshot]).to eq(true)
  end
  
  it "should validate save_snapshot of offline_clone when set to false" do
    expect(described_class.new(:name => 'cifsh', :save_snapshot => false, :ensure => :present)[:save_snapshot]).to eq(false)
  end
  
  it "should validate save_snapshot of offline_clone when set to invalid" do
    expect{ described_class.new(:name => 'cifsh', :save_snapshot => 'invalid', :ensure => :present)[:save_snapshot] }.to raise_error(Puppet::ResourceError)
  end
  
  it "should validate priority of offline_clone when set to HIGH" do
    expect(described_class.new(:name => 'cifsh', :priority => 'HIGH', :ensure => :present)[:priority]).to eq(:HIGH)
  end
  
  it "should validate priority of offline_clone when set to invalid" do
    expect{ described_class.new(:name => 'cifsh', :priority => 'invalid', :ensure => :present)[:priority] }.to raise_error(Puppet::ResourceError)
  end
  
  it "should default priority of MEDIUM" do
    expect(described_class.new(:name => 'cifsh', :ensure => :present)[:priority]).to eq(:MEDIUM)
  end
  
  it "should validate skip_zero of offline_clone when set to true" do
    expect(described_class.new(:name => 'cifsh', :skip_zero => true, :ensure => :present)[:skip_zero]).to eq(true)
  end
  
  it "should validate skip_zero of offline_clone when set to false" do
    expect(described_class.new(:name => 'cifsh', :skip_zero => false, :ensure => :present)[:skip_zero]).to eq(false)
  end
  
  it "should validate skip_zero of offline_clone when set to invalid" do
    expect{ described_class.new(:name => 'cifsh', :skip_zero => 'invalid', :ensure => :present)[:skip_zero] }.to raise_error(Puppet::ResourceError)
  end
end
