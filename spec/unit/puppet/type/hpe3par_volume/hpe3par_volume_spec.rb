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

describe Puppet::Type.type(:hpe3par_volume) do
  
  it "should have :volume_name be its namevar" do
    described_class.key_attributes.should == [:volume_name]
  end
  
  context "when validating attributes" do
    [:volume_name, :size, :size_unit, :keep_vv, :new_name, :wait_for_task_to_end, :ssip, :user, :password, :url].each do |param|
      it "should have a #{param} parameter" do
        described_class.attrtype(param).should == :param
      end
    end

    [:ensure, :cpg, :type, :compression, :snap_cpg, :ss_spc_alloc_warning_pct, :ss_spc_alloc_limit_pct, :rm_ss_spc_alloc_warning, 
      :usr_spc_alloc_warning_pct, :usr_spc_alloc_limit_pct, :rm_usr_spc_alloc_warning, :rm_ss_spc_alloc_limit, :rm_usr_spc_alloc_limit,
      :rm_exp_time, :expiration_hours, :retention_hours].each do |prop|
      it "should have a #{prop} property" do
        described_class.attrtype(prop).should == :property
      end
    end  
  end 
  
  context "when validating values" do
    context "for host_name" do
      it "should support an alphanumerical name" do
        described_class.new(:volume_name => 'user1', :ensure => :present)[:volume_name].should == 'user1'
      end
       
      it "should throw an error if name length is greater than 32" do
        volume_name = 'user123456789012345678901234567890'
        expect{described_class.new(:volume_name => volume_name, :ensure => :present)[:volume_name]}.to raise_error(Puppet::ResourceError, 
          "Parameter volume_name failed on Hpe3par_volume[#{volume_name}]: Name of the Volume should not be empty or exceed 32 characters")
      end
       
      it "should throw an error if name length is greater than 32" do
        volume_name = 'user123456789012345678901234567890'
        expect{described_class.new(:volume_name => volume_name, :ensure => :present)[:volume_name]}.to raise_error(Puppet::ResourceError, 
          "Parameter volume_name failed on Hpe3par_volume[#{volume_name}]: Name of the Volume should not be empty or exceed 32 characters")
      end
      
      it "should throw an error if name contains special characters" do
        volume_name = 'user_\#@$%&!?^_vs05'
        expect{described_class.new(:volume_name => volume_name, :ensure => :present)[:volume_name]}.to raise_error(Puppet::ResourceError, 
          "Parameter volume_name failed on Hpe3par_volume[#{volume_name}]: Name of the Volume should not contain special characters")
      end      

      it "should throw an error if name begins with underscore" do
        volume_name = '-user'
        expect{described_class.new(:volume_name => volume_name, :ensure => :present)[:volume_name]}.to raise_error(Puppet::ResourceError, 
          "Parameter volume_name failed on Hpe3par_volume[#{volume_name}]: First character of the Volume name should not begin with hyphen")
      end      
        

        
    end
    
    context "for size_unit" do
      it "should support an only values assigned in the type" do
        expect(described_class.new(:volume_name => 'user1', :size_unit => 'MiB', :ensure => :present)[:size_unit]).to eq("MiB")
      end
       
      it "should throw an error if persona is assigned a value not present in size_unit list" do
        expect{described_class.new(:volume_name => 'user1', :size_unit => 'GENERI', :ensure => :present)[:size_unit]}.to raise_error(Puppet::ResourceError)
      end
      
      it "default value check" do
        expect(described_class.new(:volume_name => 'user1', :ensure => :present)[:size_unit]).to eq("GiB")
      end          
    end
    
    context "for type of the volume" do
      it "should support an only values assigned in the type" do
        expect(described_class.new(:volume_name => 'user1', :type => 'thin_dedupe', :ensure => :present)[:type]).to eq("thin_dedupe")
      end
       
      it "should throw an error if persona is assigned a value not present in type list" do
        expect{described_class.new(:volume_name => 'user1', :type => 'GENERI', :ensure => :present)[:type]}.to raise_error(Puppet::ResourceError)
      end
      
      it "default value check" do
        expect(described_class.new(:volume_name => 'user1', :ensure => :present)[:type]).to eq("thin")
      end          
    end

    context "for compression" do
      it "should support an only values assigned in the type" do
        expect(described_class.new(:volume_name => 'user1', :compression => :false, :ensure => :present)[:compression]).to eq(false)
      end
      
      it "should support an only values assigned in the type" do
        expect(described_class.new(:volume_name => 'user1', :compression => :true, :ensure => :present)[:compression]).to eq(true)
      end
              
      it "should throw an error if compression is assigned a value not present in compression list" do
        expect{described_class.new(:volume_name => 'user1', :compression => 'out_of_range', :ensure => :present)[:compression]}.to raise_error(Puppet::ResourceError)
      end
      
      it "default value check" do
        expect(described_class.new(:volume_name => 'user1', :ensure => :present)[:compression]).to eq(false)
      end          
    end
    
    context "for wait_for_task_to_end" do
      it "should support an only values assigned in the type" do
        expect(described_class.new(:volume_name => 'user1', :wait_for_task_to_end => :false, :ensure => :present)[:wait_for_task_to_end]).to eq(false)
      end
      
      it "should support an only values assigned in the type" do
        expect(described_class.new(:volume_name => 'user1', :wait_for_task_to_end => :true, :ensure => :present)[:wait_for_task_to_end]).to eq(true)
      end
              
      it "should throw an error if wait_for_task_to_end is assigned a value not present in wait_for_task_to_end list" do
        expect{described_class.new(:volume_name => 'user1', :wait_for_task_to_end => 'out_of_range', :ensure => :present)[:wait_for_task_to_end]}.to raise_error(Puppet::ResourceError)
      end
      
      it "default value check" do
        expect(described_class.new(:volume_name => 'user1', :ensure => :present)[:wait_for_task_to_end]).to eq(false)
      end          
    end  
    
    context "for ss_spc_alloc_warning_pct" do
      it "should default the ss_spc_alloc_warning_pct" do
        expect(described_class.new(:volume_name => 'user1', :ensure => :present)[:ss_spc_alloc_warning_pct]).to eq(-1)
      end
      
      it "should validate the ss_spc_alloc_warning_pct" do
        expect(described_class.new(:volume_name => 'user1', :ss_spc_alloc_warning_pct => 6, :ensure => :present)[:ss_spc_alloc_warning_pct]).to eq(6)
      end
    end  
    
    context "for ss_spc_alloc_limit_pct" do
      it "should default the ss_spc_alloc_limit_pct" do
        expect(described_class.new(:volume_name => 'user1', :ensure => :present)[:ss_spc_alloc_limit_pct]).to eq(-1)
      end
      
      it "should validate the ss_spc_alloc_limit_pct" do
        expect(described_class.new(:volume_name => 'user1', :ss_spc_alloc_limit_pct => 6, :ensure => :present)[:ss_spc_alloc_limit_pct]).to eq(6)
      end
    end         

    context "for rm_ss_spc_alloc_warning" do
      it "should support an only values assigned in the type" do
        expect(described_class.new(:volume_name => 'user1', :rm_ss_spc_alloc_warning => :false, :ensure => :present)[:rm_ss_spc_alloc_warning]).to eq(false)
      end
      
      it "should support an only values assigned in the type" do
        expect(described_class.new(:volume_name => 'user1', :rm_ss_spc_alloc_warning => :true, :ensure => :present)[:rm_ss_spc_alloc_warning]).to eq(true)
      end
              
      it "should throw an error if rm_ss_spc_alloc_warning is assigned a value not present in rm_ss_spc_alloc_warning list" do
        expect{described_class.new(:volume_name => 'user1', :rm_ss_spc_alloc_warning => 'out_of_range', :ensure => :present)[:rm_ss_spc_alloc_warning]}.to raise_error(Puppet::ResourceError)
      end
      
      it "default value check" do
        expect(described_class.new(:volume_name => 'user1', :ensure => :present)[:rm_ss_spc_alloc_warning]).to eq(false)
      end          
    end
    
    context "for usr_spc_alloc_warning_pct" do
      it "should default the usr_spc_alloc_warning_pct" do
        expect(described_class.new(:volume_name => 'user1', :ensure => :present)[:usr_spc_alloc_warning_pct]).to eq(-1)
      end
      
      it "should validate the usr_spc_alloc_warning_pct" do
        expect(described_class.new(:volume_name => 'user1', :usr_spc_alloc_warning_pct => 6, :ensure => :present)[:usr_spc_alloc_warning_pct]).to eq(6)
      end
    end 
    
    context "for usr_spc_alloc_limit_pct" do
      it "should default the usr_spc_alloc_limit_pct" do
        expect(described_class.new(:volume_name => 'user1', :ensure => :present)[:usr_spc_alloc_limit_pct]).to eq(-1)
      end
      
      it "should validate the usr_spc_alloc_limit_pct" do
        expect(described_class.new(:volume_name => 'user1', :usr_spc_alloc_limit_pct => 6, :ensure => :present)[:usr_spc_alloc_limit_pct]).to eq(6)
      end
    end         

    context "for rm_usr_spc_alloc_warning" do
      it "should support an only values assigned in the type" do
        expect(described_class.new(:volume_name => 'user1', :rm_usr_spc_alloc_warning => :false, :ensure => :present)[:rm_usr_spc_alloc_warning]).to eq(false)
      end
      
      it "should support an only values assigned in the type" do
        expect(described_class.new(:volume_name => 'user1', :rm_usr_spc_alloc_warning => :true, :ensure => :present)[:rm_usr_spc_alloc_warning]).to eq(true)
      end
              
      it "should throw an error if rm_usr_spc_alloc_warning is assigned a value not present in rm_usr_spc_alloc_warning list" do
        expect{described_class.new(:volume_name => 'user1', :rm_usr_spc_alloc_warning => 'out_of_range', :ensure => :present)[:rm_usr_spc_alloc_warning]}.to raise_error(Puppet::ResourceError)
      end
      
      it "default value check" do
        expect(described_class.new(:volume_name => 'user1', :ensure => :present)[:rm_usr_spc_alloc_warning]).to eq(false)
      end          
    end

    context "for rm_ss_spc_alloc_limit" do
      it "should support an only values assigned in the type" do
        expect(described_class.new(:volume_name => 'user1', :rm_ss_spc_alloc_limit => :false, :ensure => :present)[:rm_ss_spc_alloc_limit]).to eq(false)
      end
      
      it "should support an only values assigned in the type" do
        expect(described_class.new(:volume_name => 'user1', :rm_ss_spc_alloc_limit => :true, :ensure => :present)[:rm_ss_spc_alloc_limit]).to eq(true)
      end
              
      it "should throw an error if rm_ss_spc_alloc_limit is assigned a value not present in rm_ss_spc_alloc_limit list" do
        expect{described_class.new(:volume_name => 'user1', :rm_ss_spc_alloc_limit => 'out_of_range', :ensure => :present)[:rm_ss_spc_alloc_limit]}.to raise_error(Puppet::ResourceError)
      end
      
      it "default value check" do
        expect(described_class.new(:volume_name => 'user1', :ensure => :present)[:rm_ss_spc_alloc_limit]).to eq(false)
      end          
    end
    
    context "for rm_usr_spc_alloc_limit" do
      it "should support an only values assigned in the type" do
        expect(described_class.new(:volume_name => 'user1', :rm_usr_spc_alloc_limit => :false, :ensure => :present)[:rm_usr_spc_alloc_limit]).to eq(false)
      end
      
      it "should support an only values assigned in the type" do
        expect(described_class.new(:volume_name => 'user1', :rm_usr_spc_alloc_limit => :true, :ensure => :present)[:rm_usr_spc_alloc_limit]).to eq(true)
      end
              
      it "should throw an error if rm_usr_spc_alloc_limit is assigned a value not present in rm_usr_spc_alloc_limit list" do
        expect{described_class.new(:volume_name => 'user1', :rm_usr_spc_alloc_limit => 'out_of_range', :ensure => :present)[:rm_usr_spc_alloc_limit]}.to raise_error(Puppet::ResourceError)
      end
      
      it "default value check" do
        expect(described_class.new(:volume_name => 'user1', :ensure => :present)[:rm_usr_spc_alloc_limit]).to eq(false)
      end          
    end
    
    context "for rm_exp_time" do
      it "should support an only values assigned in the type" do
        expect(described_class.new(:volume_name => 'user1', :rm_exp_time => :false, :ensure => :present)[:rm_exp_time]).to eq(false)
      end
      
      it "should support an only values assigned in the type" do
        expect(described_class.new(:volume_name => 'user1', :rm_exp_time => :true, :ensure => :present)[:rm_exp_time]).to eq(true)
      end
              
      it "should throw an error if rm_exp_time is assigned a value not present in rm_exp_time list" do
        expect{described_class.new(:volume_name => 'user1', :rm_exp_time => 'out_of_range', :ensure => :present)[:rm_exp_time]}.to raise_error(Puppet::ResourceError)
      end
      
      it "default value check" do
        expect(described_class.new(:volume_name => 'user1', :ensure => :present)[:rm_exp_time]).to eq(false)
      end          
    end
    
    context "for expiration_hours" do
      it "should default the expiration_hours" do
        expect(described_class.new(:volume_name => 'user1', :ensure => :present)[:expiration_hours]).to eq(-1)
      end
      
      it "should validate the expiration_hours" do
        expect(described_class.new(:volume_name => 'user1', :expiration_hours => 6, :ensure => :present)[:expiration_hours]).to eq(6)
      end
    end
    
    context "for retention_hours" do
      it "should default the retention_hours" do
        expect(described_class.new(:volume_name => 'user1', :ensure => :present)[:retention_hours]).to eq(-1)
      end
      
      it "should validate the retention_hours" do
        expect(described_class.new(:volume_name => 'user1', :retention_hours => 6, :ensure => :present)[:retention_hours]).to eq(6)
      end
    end    
 
  end  
end
