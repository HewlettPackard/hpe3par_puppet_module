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

describe Puppet::Type.type(:hpe3par_snapshot) do

  before do
    @snapshot_example = {
      :name => 'cifsh'
    }
    described_class.provider(:hpe3par_snapshot).new(@snapshot_example)
  end

  let :snapshot_resource do
    @snapshot_example
  end
  
  it "should have :name be its namevar" do
    expect(described_class.key_attributes).to eq([:name])
  end
  
  it "should fail without namevar name" do
    expect{described_class.new(:ensure => :present)[:name]}.to raise_error(Puppet::Error, 'Title or name must be provided')
  end
  
  it "should validate name of snapshot" do
    expect(described_class.new(:name => 'cifsh', :ensure => :present)[:name]).to eq('cifsh')
  end

  it "should fail if :name is longer than 32 characters" do
    snapshot_name = 'cifshgcjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjbh'
    expect{ described_class.new(:name => snapshot_name, :ensure => :present)[:name]}.to raise_error(Puppet::ResourceError, "Parameter name failed on Hpe3par_snapshot[#{snapshot_name}]: Name of the snapshot should not be empty or exceed 31 characters")
  end

  it "should fail if :name is empty" do
    expect{ described_class.new(:name => '', :ensure => :present)[:name]}.to raise_error(Puppet::ResourceError, 'Parameter name failed on Hpe3par_snapshot[]: Name of the snapshot should not be empty or exceed 31 characters')
  end

  it "should validate the base_volume_name" do
    expect(described_class.new(:name => 'cifsh', :base_volume_name => 'base_volume', :ensure => :present)[:base_volume_name]).to eq('base_volume')
  end
  
  it "should validate the snap_cpg" do
    expect(described_class.new(:name => 'cifsh', :base_volume_name => 'snapshot_cpg', :ensure => :present)[:base_volume_name]).to eq('snapshot_cpg')
  end
  
  it "should validate the new_name" do
    expect(described_class.new(:name => 'cifsh', :new_name => 'new_volume', :ensure => :present)[:new_name]).to eq('new_volume')
  end

  it "should validate the expiration_time" do
    expect(described_class.new(:name => 'cifsh', :expiration_time => '1000', :ensure => :present)[:expiration_time]).to eq(1000)
  end

  it "should validate the retention_time" do
    expect(described_class.new(:name => 'cifsh', :retention_time => '1000', :ensure => :present)[:retention_time]).to eq(1000)
  end
  
  it "should validate read_only of snapshot when set to true" do
    expect(described_class.new(:name => 'cifsh', :read_only => true, :ensure => :present)[:read_only]).to eq(true)
  end
  
  it "should validate read_only of snapshot when set to false" do
    expect(described_class.new(:name => 'cifsh', :read_only => false, :ensure => :present)[:read_only]).to eq(false)
  end
  
  it "should validate read_only of snapshot when set to invalid" do
    expect{ described_class.new(:name => 'cifsh', :read_only => 'invalid', :ensure => :present)[:read_only] }.to raise_error(Puppet::ResourceError)
  end
    
  it "should validate expiration_unit of snapshot when set to Days" do
    expect(described_class.new(:name => 'cifsh', :expiration_unit => 'Days', :ensure => :present)[:expiration_unit]).to eq('Days')
  end
  
  it "should default expiration_unit of snapshot" do
    expect(described_class.new(:name => 'cifsh', :ensure => :present)[:expiration_unit]).to eq('Hours')
  end
  
  it "should validate expiration_unit of snapshot when set to invalid" do
    expect{ described_class.new(:name => 'cifsh', :expiration_unit => 'invalid', :ensure => :present)[:expiration_unit] }.to raise_error(Puppet::ResourceError)
  end
    
  it "should validate retention_unit of snapshot when set to Days" do
    expect(described_class.new(:name => 'cifsh', :retention_unit => 'Days', :ensure => :present)[:retention_unit]).to eq('Days')
  end
  
  it "should default retention_unit of snapshot" do
    expect(described_class.new(:name => 'cifsh', :ensure => :present)[:retention_unit]).to eq('Hours')
  end
  
  it "should validate retention_unit of snapshot when set to invalid" do
    expect{ described_class.new(:name => 'cifsh', :retention_unit => 'invalid', :ensure => :present)[:retention_unit] }.to raise_error(Puppet::ResourceError)
  end
    
  it "should validate expiration_hours of snapshot " do
    expect(described_class.new(:name => 'cifsh', :expiration_hours => '1400', :ensure => :present)[:expiration_hours]).to eq(1400)
  end
  
  it "should default expiration_hours of snapshot" do
    expect(described_class.new(:name => 'cifsh', :ensure => :present)[:expiration_hours]).to eq(0)
  end
  
  it "should validate retention_hours of snapshot " do
    expect(described_class.new(:name => 'cifsh', :retention_hours => '1400', :ensure => :present)[:retention_hours]).to eq(1400)
  end
  
  it "should default retention_hours of snapshot" do
    expect(described_class.new(:name => 'cifsh', :ensure => :present)[:retention_hours]).to eq(0)
  end
  
  it "should validate online of snapshot when set to true" do
    expect(described_class.new(:name => 'cifsh', :online => true, :ensure => :present)[:online]).to eq(true)
  end
  
  it "should validate online of snapshot when set to false" do
    expect(described_class.new(:name => 'cifsh', :online => false, :ensure => :present)[:online]).to eq(false)
  end
  
  it "should validate online of snapshot when set to invalid" do
    expect{ described_class.new(:name => 'cifsh', :online => 'invalid', :ensure => :present)[:online] }.to raise_error(Puppet::ResourceError)
  end
  
  it "should validate priority of snapshot when set to HIGH" do
    expect(described_class.new(:name => 'cifsh', :priority => 'HIGH', :ensure => :present)[:priority]).to eq(:HIGH)
  end
  
  it "should validate priority of snapshot when set to invalid" do
    expect{ described_class.new(:name => 'cifsh', :priority => 'invalid', :ensure => :present)[:priority] }.to raise_error(Puppet::ResourceError)
  end
  
  it "should default priority of MEDIUM" do
    expect(described_class.new(:name => 'cifsh', :ensure => :present)[:priority]).to eq(:MEDIUM)
  end
  
  it "should validate allow_remote_copy_parent of snapshot when set to true" do
    expect(described_class.new(:name => 'cifsh', :allow_remote_copy_parent => true, :ensure => :present)[:allow_remote_copy_parent]).to eq(true)
  end
  
  it "should validate allow_remote_copy_parent of snapshot when set to false" do
    expect(described_class.new(:name => 'cifsh', :allow_remote_copy_parent => false, :ensure => :present)[:allow_remote_copy_parent]).to eq(false)
  end
  
  it "should validate allow_remote_copy_parent of snapshot when set to invalid" do
    expect{ described_class.new(:name => 'cifsh', :allow_remote_copy_parent => 'invalid', :ensure => :present)[:allow_remote_copy_parent] }.to raise_error(Puppet::ResourceError)
  end

  it "should validate rm_exp_time of snapshot when set to true" do
    expect(described_class.new(:name => 'cifsh', :rm_exp_time => true, :ensure => :present)[:rm_exp_time]).to eq(true)
  end
  
  it "should validate rm_exp_time of snapshot when set to false" do
    expect(described_class.new(:name => 'cifsh', :rm_exp_time => false, :ensure => :present)[:rm_exp_time]).to eq(false)
  end
  
  it "should validate rm_exp_time of snapshot when set to invalid" do
    expect{ described_class.new(:name => 'cifsh', :rm_exp_time => 'invalid', :ensure => :present)[:rm_exp_time] }.to raise_error(Puppet::ResourceError)
  end

end
