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

describe Puppet::Type.type(:hpe3par_online_clone) do

  before do
    @online_clone_example = {
      :name => 'cifsh'
    }
    described_class.provider(:hpe3par_online_clone).new(@online_clone_example)
  end

  let :online_clone_resource do
    @online_clone_example
  end
  
  it "should have :name be its namevar" do
    expect(described_class.key_attributes).to eq([:name])
  end
  
  it "should fail without namevar name" do
    expect{described_class.new(:ensure => :present)[:name]}.to raise_error(Puppet::Error, 'Title or name must be provided')
  end
  
  it "should validate name of online_clone" do
    expect(described_class.new(:name => 'cifsh', :ensure => :present)[:name]).to eq('cifsh')
  end

  it "should fail if :name is longer than 32 characters" do
    online_clone_name = 'cifshgcjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjbh'
    expect{ described_class.new(:name => online_clone_name, :ensure => :present)[:name]}.to raise_error(Puppet::ResourceError, "Parameter name failed on Hpe3par_online_clone[#{online_clone_name}]: Name of the clone should not be empty or exceed 31 characters")
  end

  it "should fail if :name is empty" do
    expect{ described_class.new(:name => '', :ensure => :present)[:name]}.to raise_error(Puppet::ResourceError, 'Parameter name failed on Hpe3par_online_clone[]: Name of the clone should not be empty or exceed 31 characters')
  end
  
  it "should validate base volume name of online clone" do
    expect(described_class.new(:name => 'cifsh', :base_volume_name => 'base_volume', :ensure => :present)[:base_volume_name]).to eq('base_volume')
  end
  
  it "should validate destination cpg of online clone" do
    expect(described_class.new(:name => 'cifsh', :dest_cpg => 'destination_cpg', :ensure => :present)[:dest_cpg]).to eq('destination_cpg')
  end
  
  it "should validate snap cpg of online clone" do
    expect(described_class.new(:name => 'cifsh', :snap_cpg => 'snapshot_cpg', :ensure => :present)[:snap_cpg]).to eq('snapshot_cpg')
  end

  it "should validate tpvv of online_clone when set to true" do
    expect(described_class.new(:name => 'cifsh', :tpvv => true, :ensure => :present)[:tpvv]).to eq(true)
  end
  
  it "should validate tpvv of online_clone when set to false" do
    expect(described_class.new(:name => 'cifsh', :tpvv => false, :ensure => :present)[:tpvv]).to eq(false)
  end
  
  it "should validate tpvv of online_clone when set to invalid" do
    expect{ described_class.new(:name => 'cifsh', :tpvv => 'invalid', :ensure => :present)[:tpvv] }.to raise_error(Puppet::ResourceError)
  end
  
  it "should validate tdvv of online_clone when set to true" do
    expect(described_class.new(:name => 'cifsh', :tdvv => true, :ensure => :present)[:tdvv]).to eq(true)
  end
  
  it "should validate tdvv of online_clone when set to false" do
    expect(described_class.new(:name => 'cifsh', :tdvv => false, :ensure => :present)[:tdvv]).to eq(false)
  end
  
  it "should validate tdvv of online_clone when set to invalid" do
    expect{ described_class.new(:name => 'cifsh', :tdvv => 'invalid', :ensure => :present)[:tdvv] }.to raise_error(Puppet::ResourceError)
  end
  
  it "should validate compression of online_clone when set to true" do
    expect(described_class.new(:name => 'cifsh', :compression => true, :ensure => :present)[:compression]).to eq(true)
  end
  
  it "should validate compression of online_clone when set to false" do
    expect(described_class.new(:name => 'cifsh', :compression => false, :ensure => :present)[:compression]).to eq(false)
  end
  
  it "should validate compression of online_clone when set to invalid" do
    expect{ described_class.new(:name => 'cifsh', :compression => 'invalid', :ensure => :present)[:compression] }.to raise_error(Puppet::ResourceError)
  end
end
