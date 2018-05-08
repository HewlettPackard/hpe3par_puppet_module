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

describe Puppet::Type.type(:hpe3par_hostset) do

  before do
    @hostset_example = {
      :name => 'cifsh'
    }
    described_class.provider(:hpe3par_hostset).new(@hostset_example)
  end

  let :hostset_resource do
    @hostset_example
  end
  
  it "should have :name be its namevar" do
    expect(described_class.key_attributes).to eq([:name])
  end
  
  it "should fail without namevar name" do
    expect{described_class.new(:ensure => :present)[:name]}.to raise_error(Puppet::Error, 'Title or name must be provided')
  end
  
  it "should validate name of hostset" do
    expect(described_class.new(:name => 'cifsh', :ensure => :present)[:name]).to eq('cifsh')
  end

  it "should fail if :name is longer than 32 characters" do
    hostset_name = 'cifshgcjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjbh'
    expect{ described_class.new(:name => hostset_name, :ensure => :present)[:name]}.to raise_error(Puppet::ResourceError, "Parameter name failed on Hpe3par_hostset[#{hostset_name}]: Name of the hostset should not be empty or exceed 31 characters")
  end

  it "should fail if :name is empty" do
    expect{ described_class.new(:name => '', :ensure => :present)[:name]}.to raise_error(Puppet::ResourceError, 'Parameter name failed on Hpe3par_hostset[]: Name of the hostset should not be empty or exceed 31 characters')
  end
  
  it "should validate the setmembers" do
    expect(described_class.new(:name => 'cifsh', :setmembers => ['member1, member2'], :ensure => :present)[:setmembers]).to eq(['member1, member2'])
  end
  
  it "should validate the empty setmembers" do
    expect(described_class.new(:name => 'cifsh', :setmembers => [], :ensure => :present)[:setmembers]).to eq([])
  end
end
