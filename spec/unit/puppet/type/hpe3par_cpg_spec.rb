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

describe Puppet::Type.type(:hpe3par_cpg) do

  before do
    @cpg_example = {
      :name => 'cifsh'
    }
    described_class.provider(:hpe3par_cpg).new(@cpg_example)
  end

  let :cpg_resource do
    @cpg_example
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

  it "should fail if :name is longer than 32 characters" do
    cpg_name = 'cifshgcjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjbh'
    expect{ described_class.new(:name => cpg_name, :ensure => :present)[:name]}.to raise_error(Puppet::ResourceError, "Parameter name failed on Hpe3par_cpg[#{cpg_name}]: Name of the CPG should not be empty or exceed 31 characters")
  end

  it "should fail if :name is empty" do
    expect{ described_class.new(:name => '', :ensure => :present)[:name]}.to raise_error(Puppet::ResourceError, 'Parameter name failed on Hpe3par_cpg[]: Name of the CPG should not be empty or exceed 31 characters')
  end
  
  it "should validate the raid type" do
    expect(described_class.new(:name => 'cifsh', :raid_type => 'R0', :ensure => :present)[:raid_type]).to eq('R0')
  end
  
  it "should fail with invalid raid type" do
    expect{described_class.new(:name => 'cifsh', :raid_type => 'INVALID', :ensure => :present)[:raid_type]}.to raise_error(Puppet::ResourceError)
  end
  
  it "should default the set size" do
    expect(described_class.new(:name => 'cifsh', :ensure => :present)[:set_size]).to eq(-1)
  end

  it "should validate the set size" do
    expect(described_class.new(:name => 'cifsh', :set_size => 6, :ensure => :present)[:set_size]).to eq(6)
  end

  it "should fail with invalid high availability" do
    expect{described_class.new(:name => 'cifsh', :high_availability => 'INVALID', :ensure => :present)[:high_availability]}.to raise_error(Puppet::ResourceError)
  end
  
  it "should fail with invalid high availability" do
    expect(described_class.new(:name => 'cifsh', :high_availability => 'PORT', :ensure => :present)[:high_availability]).to eq(:PORT)
  end
  
  it "should fail with invalid disk type" do
    expect{described_class.new(:name => 'cifsh', :disk_type => 'INVALID', :ensure => :present)[:disk_type]}.to raise_error(Puppet::ResourceError)
  end
  
  it "should fail with invalid disk type" do
    expect(described_class.new(:name => 'cifsh', :disk_type => 'NL', :ensure => :present)[:disk_type]).to eq(:NL)
  end
  
  it "should default to growth increment unit" do
    expect(described_class.new(:name => 'cifsh', :ensure => :present)[:growth_increment_unit]).to eq('GiB')
  end

  it "should validate the growth increment unit" do
    expect(described_class.new(:name => 'cifsh', :growth_increment_unit =>'MiB', :ensure => :present)[:growth_increment_unit]).to eq('MiB')
  end
  
  it "should with invalid growth increment unit" do
    expect{described_class.new(:name => 'cifsh', :growth_increment_unit =>'INVALID', :ensure => :present)[:growth_increment_unit]}.to raise_error(Puppet::ResourceError)
  end
  
  it "should default to growth limit " do
    expect(described_class.new(:name => 'cifsh', :ensure => :present)[:growth_limit]).to eq(-1.0)
  end

  it "should validate the growth limit" do
    expect(described_class.new(:name => 'cifsh', :growth_limit =>'20000', :ensure => :present)[:growth_limit]).to eq(20000)
  end
  
  it "should default to growth limit unit" do
    expect(described_class.new(:name => 'cifsh', :ensure => :present)[:growth_limit_unit]).to eq('GiB')
  end

  it "should validate the growth limit unit" do
    expect(described_class.new(:name => 'cifsh', :growth_limit_unit =>'MiB', :ensure => :present)[:growth_limit_unit]).to eq('MiB')
  end
  
  it "should with invalid growth limit unit" do
    expect{described_class.new(:name => 'cifsh', :growth_increment_unit =>'INVALID', :ensure => :present)[:growth_limit_unit]}.to raise_error(Puppet::ResourceError)
  end

  it "should default to growth warning " do
    expect(described_class.new(:name => 'cifsh', :ensure => :present)[:growth_warning]).to eq(-1.0)
  end

  it "should validate the growth warning" do
    expect(described_class.new(:name => 'cifsh', :growth_warning =>'20000', :ensure => :present)[:growth_warning]).to eq(20000)
  end
  
  it "should default to growth warning unit" do
    expect(described_class.new(:name => 'cifsh', :ensure => :present)[:growth_warning_unit]).to eq('GiB')
  end

  it "should validate the growth warning unit" do
    expect(described_class.new(:name => 'cifsh', :growth_warning_unit =>'MiB', :ensure => :present)[:growth_warning_unit]).to eq('MiB')
  end
  
  it "should with invalid growth warning unit" do
    expect{described_class.new(:name => 'cifsh', :growth_warning_unit =>'INVALID', :ensure => :present)[:growth_warning_unit]}.to raise_error(Puppet::ResourceError)
  end
  
  it "should validate domain" do
    expect(described_class.new(:name => 'cifsh', :domain =>'my_domain', :ensure => :present)[:domain]).to eq('my_domain')
  end
end
