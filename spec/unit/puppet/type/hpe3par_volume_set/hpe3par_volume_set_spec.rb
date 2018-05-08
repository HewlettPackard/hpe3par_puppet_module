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

describe Puppet::Type.type(:hpe3par_volume_set) do
  
  it "should have volume_set_name be its namevar" do
    described_class.key_attributes.should == [:volume_set_name]
  end
  
  context "when validating attributes" do
    [:volume_set_name, :ssip, :user, :password, :url].each do |param|
      it "should have a #{param} parameter" do
        described_class.attrtype(param).should == :param
      end
    end

    [:ensure, :domain, :setmembers].each do |prop|
      it "should have a #{prop} property" do
        described_class.attrtype(prop).should == :property
      end
    end  
  end 
  
  context "when validating values" do
    context "for volume_set_name" do
      it "should support an alphanumerical name" do
        described_class.new(:volume_set_name => 'user1', :ensure => :present)[:volume_set_name].should == 'user1'
      end
       
      it "should throw an error if name length is greater than 27" do
        volume_set_name = 'user123456789012345678901234567890'
        expect{described_class.new(:volume_set_name => volume_set_name, :ensure => :present)[:volume_set_name]}.to raise_error(Puppet::ResourceError, 
          "Parameter volume_set_name failed on Hpe3par_volume_set[#{volume_set_name}]: Name of the Volume Set should not be empty or exceed 27 characters")
      end
       
      it "should throw an error if name contains special characters" do
        volume_set_name = 'user_\#@$%&!?^_vs05'
        expect{described_class.new(:volume_set_name => volume_set_name, :ensure => :present)[:volume_set_name]}.to raise_error(Puppet::ResourceError, 
          "Parameter volume_set_name failed on Hpe3par_volume_set[#{volume_set_name}]: Name of the Volume Set should not contain special characters")
      end 
      
      it "should throw an error if name starts with hyphen character" do
        volume_set_name = '-user'
        expect{described_class.new(:volume_set_name => volume_set_name, :ensure => :present)[:volume_set_name]}.to raise_error(Puppet::ResourceError, 
          "Parameter volume_set_name failed on Hpe3par_volume_set[#{volume_set_name}]: First character of the Volume Set should not begin with hyphen")
      end
    end
 
  end  
end
