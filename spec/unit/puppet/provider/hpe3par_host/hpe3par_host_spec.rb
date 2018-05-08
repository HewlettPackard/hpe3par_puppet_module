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

require 'rspec'
require 'spec_helper'
require 'puppet/provider'
require 'puppet/util//hpe3par_api'

describe Puppet::Type.type(:hpe3par_host).provider(:hpe3par_host) do
  let :host_obj do
    Puppet::Type.type(:hpe3par_host).new(
      :host_name   => 'puppet_host',
      :fc_wwns     => ['1000D89D676F3854'],
      :url         => 'https://chefsuper:chefSUPER@10.10.10.1:8080'
    )
  end

  describe "Unit testing for module hpe3par_host" do
    
    context "validating exists method" do
      it "validating positive case" do
        hpe3parapi = HPE3PAR_API.new(host_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:host_exists?).returns true
        host_obj.provider.should be_exists
      end

      it "validating negative case" do
        hpe3parapi = HPE3PAR_API.new(host_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:host_exists?).returns false  
        host_obj.provider.should_not be_exists
      end
    end
    
    context "validating create host method" do
      it "validate positive case for create host method" do
        hpe3parapi = HPE3PAR_API.new(host_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:create_host).returns true
        host_obj.provider.create
      end
      
      it "validate negative case for create host method" do
        hpe3parapi = HPE3PAR_API.new(host_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:create_host).raises Hpe3parSdk::HPE3PARException
        expect{ host_obj.provider.create }.to raise_error(Exception)   
      end    
      
      let :host_obj_both_iscsi_wwn_given do
        Puppet::Type.type(:hpe3par_host).new(
          :host_name   => 'puppet_host',
          :fc_wwns     => ['1000D89D676F3854'],
          :iscsi_names => ['1000D89D676F3854'],
          :url         => 'https://chefsuper:chefSUPER@10.10.10.1:8080'
        )
      end 
      
      it "validate create host method when both ISCSI and WWN's are given" do
        hpe3parapi = HPE3PAR_API.new(host_obj_both_iscsi_wwn_given[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:create_host).returns true 
        expect{ host_obj_both_iscsi_wwn_given.provider.create }.to raise_error(Exception)
      end
    end
       
    context "validate delete method" do 
      it "validate positive case for delete method" do
        hpe3parapi = HPE3PAR_API.new(host_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:delete_host).returns true
        host_obj.provider.destroy
      end     
      
      it "validate negative case for delete host method" do
        hpe3parapi = HPE3PAR_API.new(host_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:delete_host).raises Hpe3parSdk::HPE3PARException
        expect{ host_obj.provider.destroy }.to raise_error(Exception)   
      end       
      
    end
    
    context "validate modify method" do
      it "validate positive case for modify method" do
        hpe3parapi = HPE3PAR_API.new(host_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:modify_host).returns true
        host_obj.provider.modify
      end 
      
      it "validate negative case for modify method" do
        hpe3parapi = HPE3PAR_API.new(host_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:modify_host).raises Hpe3parSdk::HPE3PARException
        expect{ host_obj.provider.modify }.to raise_error(Exception)   
      end
    end

    context "validate add and remove fc path" do 
      let :host_obj_fc_path_present do
        Puppet::Type.type(:hpe3par_host).new(
          :host_name   => 'puppet_host',
          :fc_wwns     => ['1000D89D676F3854'],
          :url         => 'https://chefsuper:chefSUPER@10.10.10.1:8080'
        )
      end 
      
      let :host_obj_fc_path_absent do
        Puppet::Type.type(:hpe3par_host).new(
          :host_name   => 'puppet_host',
          :url         => 'https://chefsuper:chefSUPER@10.10.10.1:8080'
        )
      end     
      
      context "Test cases specific to fc_path" do
        it "positive test for validating add_fc_path_to_host" do
          hpe3parapi = HPE3PAR_API.new(host_obj_fc_path_present[:url])
          described_class.stubs(:transport).returns hpe3parapi
          hpe3parapi.stubs(:add_fc_path_to_host).returns true
          host_obj_fc_path_present.provider.add_fc_path_to_host
        end 
        
        it "negative test for validating add_fc_path_to_host [case: fc path is not provided]" do
          expect{ host_obj_fc_path_absent.provider.add_fc_path_to_host }.to raise_error(Exception)
        end
    
        it "negative test for validating add_fc_path_to_host [case: function throwing a exception]" do
          hpe3parapi = HPE3PAR_API.new(host_obj_fc_path_present[:url])
          described_class.stubs(:transport).returns hpe3parapi
          hpe3parapi.stubs(:add_fc_path_to_host).raises Hpe3parSdk::HPE3PARException
          expect{ host_obj_fc_path_present.provider.add_fc_path_to_host }.to raise_error(Exception)
        end
   
        it "positive test for validating remove fc path from the host" do
          hpe3parapi = HPE3PAR_API.new(host_obj_fc_path_present[:url])
          described_class.stubs(:transport).returns hpe3parapi
          hpe3parapi.stubs(:remove_fc_path_from_host).returns true
          host_obj_fc_path_present.provider.remove_fc_path_from_host
        end 
        
        it "negative test for validating remove fc path from the host [case: fc path is not provided]" do
          expect{ host_obj_fc_path_absent.provider.remove_fc_path_from_host }.to raise_error(Exception)
        end   
            
        it "negative test for validating remove fc path from the host [case: function throwing a exception]" do
          hpe3parapi = HPE3PAR_API.new(host_obj_fc_path_present[:url])
          described_class.stubs(:transport).returns hpe3parapi
          hpe3parapi.stubs(:remove_fc_path_from_host).raises Hpe3parSdk::HPE3PARException
          expect{ host_obj_fc_path_present.provider.remove_fc_path_from_host }.to raise_error(Exception)
        end 
      end   
    end
    
    context "validate add and remove iscsi names" do 
      let :host_obj_iscsi_names_present do
        Puppet::Type.type(:hpe3par_host).new(
          :host_name   => 'puppet_host',
          :iscsi_names => ['1000D89D676F3854'],
          :url         => 'https://chefsuper:chefSUPER@10.10.10.1:8080'
        )
      end 
      
      let :host_obj_iscsi_names_absent do
        Puppet::Type.type(:hpe3par_host).new(
          :host_name   => 'puppet_host',
          :url         => 'https://chefsuper:chefSUPER@10.10.10.1:8080'
        )
      end     
  
      context "Test specific adding iscsi path" do
        it "positive test for validating add_iscsi_path_to_host" do
          hpe3parapi = HPE3PAR_API.new(host_obj_iscsi_names_present[:url])
          described_class.stubs(:transport).returns hpe3parapi
          hpe3parapi.stubs(:add_iscsi_path_to_host).returns true
          host_obj_iscsi_names_present.provider.add_iscsi_path_to_host
        end 
        
        it "negative test for validating add_iscsi_path_to_host [case: iscsi path is not provided]" do
          expect{ host_obj_iscsi_names_absent.provider.add_iscsi_path_to_host }.to raise_error(Exception)
        end
    
        it "negative test for validating add_iscsi_path_to_host [case: function throwing a exception]" do
          hpe3parapi = HPE3PAR_API.new(host_obj_iscsi_names_present[:url])
          described_class.stubs(:transport).returns hpe3parapi
          hpe3parapi.stubs(:add_iscsi_path_to_host).raises Hpe3parSdk::HPE3PARException
          expect{ host_obj_iscsi_names_present.provider.add_iscsi_path_to_host }.to raise_error(Exception)
        end
      end      
   
      context "Test specific removing iscsi path" do
        
        it "positive test for validating remove iscsi path from the host" do
          hpe3parapi = HPE3PAR_API.new(host_obj_iscsi_names_present[:url])
          described_class.stubs(:transport).returns hpe3parapi
          hpe3parapi.stubs(:remove_iscsi_path_from_host).returns true
          host_obj_iscsi_names_present.provider.remove_iscsi_path_from_host
        end 
        
        it "negative test for validating remove iscsi path from the host [case: iscsi path is not provided]" do
          expect{ host_obj_iscsi_names_absent.provider.remove_iscsi_path_from_host }.to raise_error(Exception)
        end   
            
        it "negative test for validating remove iscsi path from the host [case: function throwing a exception]" do
          hpe3parapi = HPE3PAR_API.new(host_obj_iscsi_names_present[:url])
          described_class.stubs(:transport).returns hpe3parapi
          hpe3parapi.stubs(:remove_iscsi_path_from_host).raises Hpe3parSdk::HPE3PARException
          expect{ host_obj_iscsi_names_present.provider.remove_iscsi_path_from_host }.to raise_error(Exception)
        end   
      end
    end
      
    context "validate add and remove initiator chap" do
      let :host_obj_initiator_chap do
        Puppet::Type.type(:hpe3par_host).new(
          :host_name   => 'puppet_host',
          :chap_name   => 'puppet_chap_name',
          :chap_secret => '12345678901234567890123456789012',
          :chap_secret_hex => true,
          :url         => 'https://chefsuper:chefSUPER@10.10.10.1:8080'
        )
      end
      
      let :host_obj_initiator_chap_neg_a do
        Puppet::Type.type(:hpe3par_host).new(
          :host_name   => 'puppet_host',
          :chap_secret => '12345678901234567890123456789012',
          :chap_secret_hex => true,
          :url         => 'https://chefsuper:chefSUPER@10.10.10.1:8080'
        )
      end      
            
      let :host_obj_initiator_chap_neg_b do
        Puppet::Type.type(:hpe3par_host).new(
          :host_name   => 'puppet_host',
          :chap_name   => 'puppet_chap_name',
          :chap_secret_hex => true,
          :url         => 'https://chefsuper:chefSUPER@10.10.10.1:8080'
        )
      end      
             
      
      let :host_obj_initiator_chap_neg_c do
        Puppet::Type.type(:hpe3par_host).new(
          :host_name   => 'puppet_host',
          :chap_name   => 'puppet_chap_name',
          :chap_secret => '123456789012345678901234567',
          :chap_secret_hex => true,
          :url         => 'https://chefsuper:chefSUPER@10.10.10.1:8080'
        )
      end      
            
      let :host_obj_initiator_chap_neg_d do
        Puppet::Type.type(:hpe3par_host).new(
          :host_name   => 'puppet_host',
          :chap_name   => 'puppet_chap_name',
          :chap_secret => '12345678901234567890123456789012',
          :chap_secret_hex => false,
          :url         => 'https://chefsuper:chefSUPER@10.10.10.1:8080'
        )
      end      
                          
                          
      context "validate add initiator chap" do
        it "positive test for adding initiator chap with chap_secret length 32" do  
          hpe3parapi = HPE3PAR_API.new(host_obj_initiator_chap[:url])
          described_class.stubs(:transport).returns hpe3parapi
          hpe3parapi.stubs(:add_initiator_chap).returns true
          host_obj_initiator_chap.provider.add_initiator_chap         
        end
        
        it "negative test for validating adding initiator chap [case: chap_name is not provided]" do
          expect{ host_obj_initiator_chap_neg_a.provider.add_initiator_chap }.to raise_error(Exception)
        end   

        it "negative test for validating adding initiator chap [case: chap secret is not provided]" do
          expect{ host_obj_initiator_chap_neg_b.provider.add_initiator_chap }.to raise_error(Exception)
        end  
        
        it "negative test for validating adding initiator chap [case: chap_name is not provided]" do
          expect{ host_obj_initiator_chap_neg_c.provider.add_initiator_chap }.to raise_error(Exception)
        end   

        it "negative test for validating adding initiator chap [case: chap secret is not provided]" do
          expect{ host_obj_initiator_chap_neg_d.provider.add_initiator_chap }.to raise_error(Exception)
        end 
              
        it "negative test for adding initiator chap [case: add_initiator_chap raises HPE3PAR exception]" do
          hpe3parapi = HPE3PAR_API.new(host_obj_initiator_chap[:url])
          described_class.stubs(:transport).returns hpe3parapi
          hpe3parapi.stubs(:add_initiator_chap).raises Hpe3parSdk::HPE3PARException
          expect{ host_obj_initiator_chap.provider.add_initiator_chap }.to raise_error(Exception)             
        end
      end
      
      context "validate remove initiator chap" do
        it "positive test for removing initiator chap with chap_secret length 32" do
          hpe3parapi = HPE3PAR_API.new(host_obj_initiator_chap[:url])
          described_class.stubs(:transport).returns hpe3parapi
          hpe3parapi.stubs(:remove_initiator_chap).returns true
          host_obj_initiator_chap.provider.remove_initiator_chap           
        end
              
        it "negative test for removing initiator chap [case: remove_initiator_chap raises HPE3PAR exception]" do
          hpe3parapi = HPE3PAR_API.new(host_obj_initiator_chap[:url])
          described_class.stubs(:transport).returns hpe3parapi
          hpe3parapi.stubs(:remove_initiator_chap).raises Hpe3parSdk::HPE3PARException
          expect{ host_obj_initiator_chap.provider.remove_initiator_chap }.to raise_error(Exception)             
        end        
      end
      
      context "validate add target chap" do
        it "positive test for adding target chap with chap_secret length 32" do  
          hpe3parapi = HPE3PAR_API.new(host_obj_initiator_chap[:url])
          described_class.stubs(:transport).returns hpe3parapi
          hpe3parapi.stubs(:add_target_chap).returns true
          hpe3parapi.stubs(:initiator_chap_exists?).returns true
          host_obj_initiator_chap.provider.add_target_chap         
        end
        
        it "negative test for validating adding target chap [case: chap_name is not provided]" do
          expect{ host_obj_initiator_chap_neg_a.provider.add_target_chap }.to raise_error(Exception)
        end   

        it "negative test for validating adding target chap [case: chap secret is not provided]" do
          expect{ host_obj_initiator_chap_neg_b.provider.add_target_chap }.to raise_error(Exception)
        end  
        
        it "negative test for validating adding target chap [case: chap_secret_hex = true and chap_secret length < 32]" do
          expect{ host_obj_initiator_chap_neg_c.provider.add_target_chap }.to raise_error(Exception)
        end   

        it "negative test for validating adding target chap [case: chap_secret_hex = true and chap_secret length < 12 or > 16]" do
          expect{ host_obj_initiator_chap_neg_d.provider.add_target_chap }.to raise_error(Exception)
        end 
              
        it "negative test for adding target chap [case: add_target_chap raises HPE3PAR exception]" do
          hpe3parapi = HPE3PAR_API.new(host_obj_initiator_chap[:url])
          described_class.stubs(:transport).returns hpe3parapi
          hpe3parapi.stubs(:initiator_chap_exists?).returns true
          hpe3parapi.stubs(:add_target_chap).raises Hpe3parSdk::HPE3PARException
          expect{ host_obj_initiator_chap.provider.add_target_chap }.to raise_error(Exception)             
        end
              
        it "negative test for adding target chap [case: add_target_chap raises HPE3PAR exception]" do
          hpe3parapi = HPE3PAR_API.new(host_obj_initiator_chap[:url])
          described_class.stubs(:transport).returns hpe3parapi
          hpe3parapi.stubs(:initiator_chap_exists?).raises Hpe3parSdk::HPE3PARException
          expect{ host_obj_initiator_chap.provider.add_target_chap }.to raise_error(Exception)             
        end        
      end
      
      context "validate remove target chap" do
        it "positive test for removing target chap with chap_secret length 32" do
          hpe3parapi = HPE3PAR_API.new(host_obj_initiator_chap[:url])
          described_class.stubs(:transport).returns hpe3parapi
          hpe3parapi.stubs(:remove_target_chap).returns true
          host_obj_initiator_chap.provider.remove_target_chap           
        end
              
        it "negative test for removing target chap [case: remove_target_chap raises HPE3PAR exception]" do
          hpe3parapi = HPE3PAR_API.new(host_obj_initiator_chap[:url])
          described_class.stubs(:transport).returns hpe3parapi
          hpe3parapi.stubs(:remove_target_chap).raises Hpe3parSdk::HPE3PARException
          expect{ host_obj_initiator_chap.provider.remove_target_chap }.to raise_error(Exception)             
        end        
      end
    end
        
  end
end