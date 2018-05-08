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

describe Puppet::Type.type(:hpe3par_volume_set).provider(:hpe3par_volume_set) do
  let :volume_set_obj do
    Puppet::Type.type(:hpe3par_volume_set).new(
      :volume_set_name  => 'puppet_volume',
      :setmembers       => [{"id" => 1064,"name" => "C20DUM1","domain" => "SAPLVM","qosEnabled"=> false}],
      :url              => 'https://chefsuper:chefSUPER@10.10.10.1:8080'
    )
  end

  describe "Unit testing for module hpe3par_volume" do
    
    context "validating exists method" do
      it "validating positive case" do
        hpe3parapi = HPE3PAR_API.new(volume_set_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:volume_set_exists?).returns true
        volume_set_obj.provider.should be_exists
      end

      it "validating negative case" do
        hpe3parapi = HPE3PAR_API.new(volume_set_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:volume_set_exists?).returns false
        volume_set_obj.provider.should_not be_exists
      end
    end
    
    context "validating create volume method" do
      it "validate positive case for create volume method" do
        hpe3parapi = HPE3PAR_API.new(volume_set_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:create_volume_set).returns true
        volume_set_obj.provider.create
      end
           
      it "validate HPE3PAR exception case for create volume method" do
        hpe3parapi = HPE3PAR_API.new(volume_set_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:create_volume_set).raises Hpe3parSdk::HPE3PARException
        expect{ volume_set_obj.provider.create }.to raise_error(Exception)   
      end 
    end    

    context "validate delete method" do 
      it "validate positive case for delete method" do
        hpe3parapi = HPE3PAR_API.new(volume_set_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:delete_volume_set).returns true
        volume_set_obj.provider.destroy
      end
      
      it "validate HPE3PAR exception case for delete method" do
        hpe3parapi = HPE3PAR_API.new(volume_set_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:delete_volume_set).raises Hpe3parSdk::HPE3PARException
        expect{ volume_set_obj.provider.delete }.to raise_error(Exception)  
      end       
    end
    
    context "validate add_volume method" do 
      it "validate positive case for add_volume method  [Case: volume set has 1 volumes, try to add the same volume]" do
        hpe3parapi = HPE3PAR_API.new(volume_set_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        my_vol = mock()
        hpe3parapi.stubs(:get_volume_set).returns my_vol
        my_vol.stubs(:setmembers).returns [{"id"=> 1064,"name"=> "C20DUM1","domain"=> "SAPLVM","qosEnabled"=> false}]
        hpe3parapi.stubs(:add_volumes_to_volume_set).returns true
        volume_set_obj.provider.add_volume
      end
      
      it "validate positive case for add_volume method  [Case: volume set has 1 volumes, try to add the differernt volume]" do
        hpe3parapi = HPE3PAR_API.new(volume_set_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        my_vol = mock()
        hpe3parapi.stubs(:get_volume_set).returns my_vol
        my_vol.stubs(:setmembers).returns [{"id"=> 1065,"name"=> "C20DUM3","domain"=> "SAPLVM","qosEnabled"=> false}]
        hpe3parapi.stubs(:add_volumes_to_volume_set).returns true
        volume_set_obj.provider.add_volume
      end      
      
      it "validate positive case for add_volume method [Case: volume set has 0 volumes, try to add a volume]" do
        hpe3parapi = HPE3PAR_API.new(volume_set_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        my_vol = mock()
        hpe3parapi.stubs(:get_volume_set).returns my_vol
        my_vol.stubs(:setmembers).returns nil
        hpe3parapi.stubs(:add_volumes_to_volume_set).returns true
        volume_set_obj.provider.add_volume
      end
           
      it "validate HPE3PAR exception case for add_volume method [Case: add_volumes_to_volume_set raises a exception]" do
        hpe3parapi = HPE3PAR_API.new(volume_set_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        my_vol = mock()
        hpe3parapi.stubs(:get_volume_set).returns my_vol
        my_vol.stubs(:setmembers).returns []
        hpe3parapi.stubs(:add_volumes_to_volume_set).raises Hpe3parSdk::HPE3PARException
        expect{ volume_set_obj.provider.add_volume }.to raise_error(Exception)
      end                         
    end
    
    context "validate remove_volume method" do
      context "Positive test cases for remove_volume method" do
        it "validate positive case for remove_volume method [Case: volume set has 1 volumes]" do
          hpe3parapi = HPE3PAR_API.new(volume_set_obj[:url])
          described_class.stubs(:transport).returns hpe3parapi
          my_vol = mock()
          hpe3parapi.stubs(:get_volume_set).returns my_vol
          my_vol.stubs(:setmembers).returns [{"id"=> 1064,"name"=> "C20DUM1","domain"=> "SAPLVM","qosEnabled"=> false}]
          hpe3parapi.stubs(:remove_volumes_from_volume_set).returns true
          volume_set_obj.provider.remove_volume
        end
        
        it "validate positive case for remove_volume method [Case: volume set has 1 volumes, try to remove a different volume.]" do
          hpe3parapi = HPE3PAR_API.new(volume_set_obj[:url])
          described_class.stubs(:transport).returns hpe3parapi
          my_vol = mock()
          hpe3parapi.stubs(:get_volume_set).returns my_vol
          my_vol.stubs(:setmembers).returns [{"id"=> 1065,"name"=> "C20DUM1","domain"=> "SAPLVM","qosEnabled"=> false}]
          hpe3parapi.stubs(:remove_volumes_from_volume_set).returns true
          volume_set_obj.provider.remove_volume
        end
                
        
        it "validate positive case for remove_volume method [Case: volume set has no volumes]" do
          hpe3parapi = HPE3PAR_API.new(volume_set_obj[:url])
          described_class.stubs(:transport).returns hpe3parapi
          my_vol = mock()
          hpe3parapi.stubs(:get_volume_set).returns my_vol
          my_vol.stubs(:setmembers).returns []
          hpe3parapi.stubs(:remove_volumes_from_volume_set).returns true
          volume_set_obj.provider.remove_volume
        end
            
        it "validate positive case for remove_volume method [Case: volume set has no volumes]" do
          hpe3parapi = HPE3PAR_API.new(volume_set_obj[:url])
          described_class.stubs(:transport).returns hpe3parapi
          my_vol = mock()
          hpe3parapi.stubs(:get_volume_set).returns my_vol
          my_vol.stubs(:setmembers).returns nil
          hpe3parapi.stubs(:remove_volumes_from_volume_set).returns true
          volume_set_obj.provider.remove_volume
        end
      end
      
      context "Negative test cases for remove_volume method [Case: remove_volumes_from_volume_set raises a exception]" do
        it "validate HPE3PAR exception case for remove_volume method" do
          hpe3parapi = HPE3PAR_API.new(volume_set_obj[:url])
          described_class.stubs(:transport).returns hpe3parapi
          my_vol = mock()
          hpe3parapi.stubs(:get_volume_set).returns my_vol
          my_vol.stubs(:setmembers).returns [{"id"=> 1064,"name"=> "C20DUM1","domain"=> "SAPLVM","qosEnabled"=> false}]
          hpe3parapi.stubs(:remove_volumes_from_volume_set).raises Hpe3parSdk::HPE3PARException
          expect{ volume_set_obj.provider.remove_volume }.to raise_error(Exception)
        end
      end                       
    end    

  end
end