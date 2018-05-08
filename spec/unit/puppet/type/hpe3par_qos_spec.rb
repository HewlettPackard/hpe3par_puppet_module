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

describe Puppet::Type.type(:hpe3par_qos) do

  before do
    @cpg_example = {
      :qos_target_name => 'cifsh'
    }
    described_class.provider(:hpe3par_qos).new(@qos_example)
  end

  let :qos_resource do
    @cpg_example
  end
  
  it "should have qos_target_name be its namevar" do
    expect(described_class.key_attributes).to eq([:qos_target_name])
  end
  
  it "should fail without namevar name" do
    expect{described_class.new(:ensure => :present)[:qos_target_name]}.to raise_error(Puppet::Error, 'Title or name must be provided')
  end
  
  it "should validate qos_target_name of cpg" do
    expect(described_class.new(:qos_target_name => 'cifsh', :ensure => :present)[:qos_target_name]).to eq('cifsh')
  end
  
  it "should validate the type" do
    expect(described_class.new(:name => 'cifsh', :type =>'SYS', :ensure => :present)[:type]).to eq(:SYS)
  end
  
  it "should fail with invalid type" do
    expect{described_class.new(:name => 'cifsh', :type =>'INVALID', :ensure => :present)[:type]}.to raise_error(Puppet::ResourceError)
  end
  
  it "should validate the priority" do
    expect(described_class.new(:name => 'cifsh', :priority =>'NORMAL', :ensure => :present)[:priority]).to eq(:NORMAL)
  end
  
  it "should fail with invalid priority" do
    expect{described_class.new(:name => 'cifsh', :priority =>'INVALID', :ensure => :present)[:priority]}.to raise_error(Puppet::ResourceError)
  end
  
  it "should validate the bwmin_goal_op" do
    expect(described_class.new(:name => 'cifsh', :bwmin_goal_op =>'NOLIMIT', :ensure => :present)[:bwmin_goal_op]).to eq(:NOLIMIT)
  end
  
  it "should fail with invalid bwmin_goal_op" do
    expect{described_class.new(:name => 'cifsh', :bwmin_goal_op =>'INVALID', :ensure => :present)[:bwmin_goal_op]}.to raise_error(Puppet::ResourceError)
  end
  
  it "should validate the bwmax_limit_op" do
    expect(described_class.new(:name => 'cifsh', :bwmax_limit_op =>'NOLIMIT', :ensure => :present)[:bwmax_limit_op]).to eq(:NOLIMIT)
  end
  
  it "should fail with invalid bwmax_limit_op" do
    expect{described_class.new(:name => 'cifsh', :bwmax_limit_op =>'INVALID', :ensure => :present)[:bwmax_limit_op]}.to raise_error(Puppet::ResourceError)
  end
  
  it "should validate the iomin_goal_op" do
    expect(described_class.new(:name => 'cifsh', :iomin_goal_op =>'NOLIMIT', :ensure => :present)[:iomin_goal_op]).to eq(:NOLIMIT)
  end
  
  it "should fail with invalid iomin_goal_op" do
    expect{described_class.new(:name => 'cifsh', :iomin_goal_op =>'INVALID', :ensure => :present)[:iomin_goal_op]}.to raise_error(Puppet::ResourceError)
  end
  
    it "should validate the iomax_limit_op" do
    expect(described_class.new(:name => 'cifsh', :iomax_limit_op =>'NOLIMIT', :ensure => :present)[:iomax_limit_op]).to eq(:NOLIMIT)
  end
  
  it "should fail with invalid iomax_limit_op" do
    expect{described_class.new(:name => 'cifsh', :iomax_limit_op =>'INVALID', :ensure => :present)[:iomax_limit_op]}.to raise_error(Puppet::ResourceError)
  end
  
  it "should validate enable" do
    expect(described_class.new(:name => 'cifsh', :enable =>'true', :ensure => :present)[:enable]).to eq('true')
  end
    
  it "should validate the bwmin_goal_kb" do
    expect(described_class.new(:name => 'cifsh', :bwmin_goal_kb =>20000, :ensure => :present)[:bwmin_goal_kb]).to eq(20000)
  end
  
  it "should default bwmin_goal_kb" do
    expect(described_class.new(:name => 'cifsh', :ensure => :present)[:bwmin_goal_kb]).to eq(-1)
  end

  it "should validate the bwmax_limit_kb" do
    expect(described_class.new(:name => 'cifsh', :bwmax_limit_kb =>20000, :ensure => :present)[:bwmax_limit_kb]).to eq(20000)
  end
  
  it "should default bwmax_limit_kb" do
    expect(described_class.new(:name => 'cifsh', :ensure => :present)[:bwmax_limit_kb]).to eq(-1)
  end
  
  it "should validate the iomin_goal" do
    expect(described_class.new(:name => 'cifsh', :iomin_goal =>20000, :ensure => :present)[:iomin_goal]).to eq(20000)
  end
  
  it "should default iomin_goal" do
    expect(described_class.new(:name => 'cifsh', :ensure => :present)[:iomin_goal]).to eq(-1)
  end
  
  it "should validate the iomax_limit" do
    expect(described_class.new(:name => 'cifsh', :iomax_limit =>20000, :ensure => :present)[:iomax_limit]).to eq(20000)
  end
  
  it "should default iomax_limit" do
    expect(described_class.new(:name => 'cifsh', :ensure => :present)[:iomax_limit]).to eq(-1)
  end
  
  it "should validate the latency_goal" do
    expect(described_class.new(:name => 'cifsh', :latency_goal =>20000, :ensure => :present)[:latency_goal]).to eq(20000)
  end
  
  it "should default latency_goal" do
    expect(described_class.new(:name => 'cifsh', :ensure => :present)[:latency_goal]).to eq(-1)
  end
  
  it "should validate the latency_goal_usecs" do
    expect(described_class.new(:name => 'cifsh', :latency_goal_usecs =>20000, :ensure => :present)[:latency_goal_usecs]).to eq(20000)
  end
  
  it "should default latency_goal_usecs" do
    expect(described_class.new(:name => 'cifsh', :ensure => :present)[:latency_goal_usecs]).to eq(-1)
  end
  
  it "should validate the default_latency" do
    expect(described_class.new(:name => 'cifsh', :default_latency =>false, :ensure => :present)[:default_latency]).to eq(false)
  end
  
  it "should default default_latency" do
    expect(described_class.new(:name => 'cifsh', :ensure => :present)[:default_latency]).to eq(false)
  end
  
  it "should fail with invalid default_latency" do
    expect{described_class.new(:name => 'cifsh', :default_latency =>'INVALID', :ensure => :present)[:default_latency]}.to raise_error(Puppet::ResourceError)
  end
end
