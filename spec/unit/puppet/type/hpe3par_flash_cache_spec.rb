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

describe Puppet::Type.type(:hpe3par_flash_cache) do

  before do
    @fc_example = {
      :name => 'cifsh'
    }
    described_class.provider(:hpe3par_flash_cache).new(@hpe3par_flash_cache)
  end

  let :fc_resource do
    @fc_example
  end
  
  it "should have :name be its namevar" do
    expect(described_class.key_attributes).to eq([:name])
  end
  
  it "should fail without namevar name" do
    expect{described_class.new(:ensure => :present)[:name]}.to raise_error(Puppet::Error, 'Title or name must be provided')
  end
  
  it "should validate name of cpg" do
    expect(described_class.new(:name => 'cifsh', :ensure => :present)[:name]).to eq('cifsh')
  end
  
  it "should validate mode of flash cache" do
    expect(described_class.new(:name => 'cifsh', :mode => 'simulator', :ensure => :present)[:mode]).to eq(:simulator)
  end
  
  it "should default mode of flash cache" do
    expect(described_class.new(:name => 'cifsh', :ensure => :present)[:mode]).to eq(:real)
  end
  
  it "should validate mode of flash cache when set to invalid" do
    expect{ described_class.new(:name => 'cifsh', :mode => 'invalid', :ensure => :present)[:mode] }.to raise_error(Puppet::ResourceError)
  end
end


