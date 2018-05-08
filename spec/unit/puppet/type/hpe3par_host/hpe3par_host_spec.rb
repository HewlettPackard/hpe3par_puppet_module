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
require 'puppet/provider'
require 'puppet/util//hpe3par_api'

describe Puppet::Type.type(:hpe3par_host) do
  
  it "should have :host_name be its namevar" do
    described_class.key_attributes.should == [:host_name]
  end
  
  context "when validating attributes" do
    [:host_name, :ssip, :user, :password, :url].each do |param|
      it "should have a #{param} parameter" do
        described_class.attrtype(param).should == :param
      end
    end

    [:ensure, :domain, :fc_wwns, :iscsi_names, :persona, :new_name, :force_path_removal, :chap_name, :chap_secret, :chap_secret_hex].each do |prop|
      it "should have a #{prop} property" do
        described_class.attrtype(prop).should == :property
      end
    end  
  end 
  
  context "when validating values" do
    context "for host_name" do
      it "should support an alphanumerical name" do
        described_class.new(:host_name => 'user1', :ensure => :present)[:host_name].should == 'user1'
      end
       
      it "should throw an error if name length is greater than 32" do
        host_name = 'user123456789012345678901234567890'
        expect{described_class.new(:host_name => host_name, :ensure => :present)[:host_name]}.to raise_error(Puppet::ResourceError, 
          "Parameter host_name failed on Hpe3par_host[#{host_name}]: Name of the Host should not be empty or exceed 32 characters")
      end
       
      it "should throw an error if name length is greater than 32" do
        host_name = 'user123456789012345678901234567890'
        expect{described_class.new(:host_name => host_name, :ensure => :present)[:host_name]}.to raise_error(Puppet::ResourceError, 
          "Parameter host_name failed on Hpe3par_host[#{host_name}]: Name of the Host should not be empty or exceed 32 characters")
      end    
    end
    
    context "for persona" do
      it "should support an only values assigned in the type" do
        expect(described_class.new(:host_name => 'user1', :persona => 'GENERIC', :ensure => :present)[:persona]).to eq(:GENERIC)
      end
       
      it "should throw an error if persona is assigned a value not present in persona list" do
        expect{described_class.new(:host_name => 'user1', :persona => 'GENERI', :ensure => :present)[:persona]}.to raise_error(Puppet::ResourceError)
      end
      
      it "default value check" do
        expect(described_class.new(:host_name => 'user1', :ensure => :present)[:persona]).to eq(:GENERIC_ALUA)
      end          
    end
    
    context "for force_path_removal" do
      it "should support an only values assigned in the type" do
        expect(described_class.new(:host_name => 'user1', :force_path_removal => :false, :ensure => :present)[:force_path_removal]).to eq(false)
      end
      
      it "should support an only values assigned in the type" do
        expect(described_class.new(:host_name => 'user1', :force_path_removal => :true, :ensure => :present)[:force_path_removal]).to eq(true)
      end
              
      it "should throw an error if persona is assigned a value not present in persona list" do
        expect{described_class.new(:host_name => 'user1', :force_path_removal => 'out_of_range', :ensure => :present)[:force_path_removal]}.to raise_error(Puppet::ResourceError)
      end
      
      it "default value check" do
        expect(described_class.new(:host_name => 'user1', :ensure => :present)[:force_path_removal]).to eq(nil)
      end          
    end
        
    context "for chap_secret_hex" do
      it "should support an only values assigned in the type" do
        expect(described_class.new(:host_name => 'user1', :chap_secret_hex => :false, :ensure => :present)[:chap_secret_hex]).to eq(false)
      end
       
      it "should support an only values assigned in the type" do
        expect(described_class.new(:host_name => 'user1', :chap_secret_hex => :true, :ensure => :present)[:chap_secret_hex]).to eq(true)
      end       
       
      it "should throw an error if chap_secret_hex is assigned a value not present in chap_secret_hex list" do
        expect{described_class.new(:host_name => 'user1', :chap_secret_hex => 'out_of_range', :ensure => :present)[:chap_secret_hex]}.to raise_error(Puppet::ResourceError)
      end
      
      it "default value check" do
        expect(described_class.new(:host_name => 'user1', :ensure => :present)[:chap_secret_hex]).to eq(nil)
      end          
    end
        
  end  
  
end
