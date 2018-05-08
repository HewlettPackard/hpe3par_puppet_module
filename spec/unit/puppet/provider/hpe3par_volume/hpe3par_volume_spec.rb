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

describe Puppet::Type.type(:hpe3par_volume).provider(:hpe3par_volume) do
  let :volume_obj do
    Puppet::Type.type(:hpe3par_volume).new(
      :volume_name   => 'puppet_volume',
      :cpg           => 'FC_r1',
      :snap_cpg      => 'FC_r1',
      :url           => 'https://chefsuper:chefSUPER@10.10.10.1:8080'
    )
  end
  
  let :volume_obj_1 do
    Puppet::Type.type(:hpe3par_volume).new(
      :volume_name   => 'puppet_volume',
      :cpg           => 'FC_r1',
      :snap_cpg      => nil,
      :user_cpg      => nil,
      :url           => 'https://chefsuper:chefSUPER@10.10.10.1:8080'
    )
  end  
  
  let :volume_obj_2 do
    Puppet::Type.type(:hpe3par_volume).new(
      :volume_name   => 'puppet_volume',
      :cpg           => 'FC_r1',
      :snap_cpg      => 'FC_r2',
      :user_cpg      => nil,
      :url           => 'https://chefsuper:chefSUPER@10.10.10.1:8080'
    )
  end   

  describe "Unit testing for module hpe3par_volume" do
    
    context "validating exists method" do
      it "validating positive case" do
        hpe3parapi = HPE3PAR_API.new(volume_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:volume_exists?).returns true
        volume_obj.provider.should be_exists
      end

      it "validating negative case" do
        hpe3parapi = HPE3PAR_API.new(volume_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:volume_exists?).returns false
        volume_obj.provider.should_not be_exists
      end
    end
    
    context "validating create volume method" do
      it "validate positive case for create volume method" do
        hpe3parapi = HPE3PAR_API.new(volume_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:create_volume).returns true
        volume_obj.provider.create
      end
           
      it "validate negative case for create volume method" do
        hpe3parapi = HPE3PAR_API.new(volume_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:create_volume).raises Hpe3parSdk::HPE3PARException
        expect{ volume_obj.provider.create }.to raise_error(Exception)   
      end 
    end    

    context "validate delete method" do 
      it "validate positive case for delete method" do
        hpe3parapi = HPE3PAR_API.new(volume_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:delete_volume).returns true
        volume_obj.provider.destroy
      end
      
      it "validate negative case for delete method" do
        hpe3parapi = HPE3PAR_API.new(volume_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:delete_volume).raises Hpe3parSdk::HPE3PARException
        expect{ volume_obj.provider.delete }.to raise_error(Exception)  
      end       
      
    end
    
    context "validate modify method" do
      it "validate positive case for modify method" do
        hpe3parapi = HPE3PAR_API.new(volume_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:modify_volume).returns true
        volume_obj.provider.modify
      end
      
      it "validate negative case for modify method" do
        hpe3parapi = HPE3PAR_API.new(volume_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:modify_volume).raises Hpe3parSdk::HPE3PARException
        expect{ volume_obj.provider.modify }.to raise_error(Exception)
      end     
    end
       
    context "validate grow method" do
      it "validate positive case for grow method" do
        hpe3parapi = HPE3PAR_API.new(volume_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:grow_volume).returns true
        volume_obj.provider.grow
      end
      
      it "validate negative case for grow method" do
        hpe3parapi = HPE3PAR_API.new(volume_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:grow_volume).raises Hpe3parSdk::HPE3PARException
        expect{ volume_obj.provider.grow }.to raise_error(Exception)
      end     
    end

    context "validate grow_to_size method" do         
      it "validate negative case for grow_to_size method [Case: actual volume size greater than the required size]" do
        hpe3parapi = HPE3PAR_API.new(volume_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:volume_exists?).returns true
        my_vol = mock()
        hpe3parapi.stubs(:get_volume).returns my_vol
        my_vol.stubs(:size_mib).returns 40000     
        hpe3parapi.stubs(:convert_to_binary_multiple).returns 20000
        hpe3parapi.stubs(:grow_volume).returns true
        expect{ volume_obj.provider.grow_to_size }.to raise_error(Exception)
      end
         
      it "validate negative case for grow_to_size method [Case: volume exists returns a false]" do
        hpe3parapi = HPE3PAR_API.new(volume_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:volume_exists?).returns false
        my_vol = mock()
        hpe3parapi.stubs(:get_volume).returns my_vol
        my_vol.stubs(:size_mib).returns 40000     
        hpe3parapi.stubs(:convert_to_binary_multiple).returns 20000
        hpe3parapi.stubs(:grow_volume).returns true
        expect{ volume_obj.provider.grow_to_size }.to raise_error(Exception)
      end
        
      it "validate positive case for grow_to_size method  [Case: actual volume size less than the required size] " do
        hpe3parapi = HPE3PAR_API.new(volume_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:volume_exists?).returns true
        my_vol = mock()
        hpe3parapi.stubs(:get_volume).returns my_vol
        my_vol.stubs(:size_mib).returns 20000     
        hpe3parapi.stubs(:convert_to_binary_multiple).returns 40000
        hpe3parapi.stubs(:grow_volume).returns true
        volume_obj.provider.grow_to_size
      end      
           
      it "validate negative case for grow_to_size method [Case: volume exists returns a false]" do
        hpe3parapi = HPE3PAR_API.new(volume_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:volume_exists?).returns false
        my_vol = mock()
        hpe3parapi.stubs(:get_volume).returns my_vol
        my_vol.stubs(:size_mib).returns 20000     
        hpe3parapi.stubs(:convert_to_binary_multiple).returns 40000
        hpe3parapi.stubs(:grow_volume).returns true
        expect{ volume_obj.provider.grow_to_size }.to raise_error(Exception)
      end
      
      it "validate negative case for grow_to_size method [Case: grow to size throws a exception ]" do
        hpe3parapi = HPE3PAR_API.new(volume_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:volume_exists?).returns true
        my_vol = mock()
        hpe3parapi.stubs(:get_volume).returns my_vol
        my_vol.stubs(:size_mib).returns 20000     
        hpe3parapi.stubs(:convert_to_binary_multiple).returns 40000
        hpe3parapi.stubs(:grow_volume).raises Hpe3parSdk::HPE3PARException
        expect{ volume_obj.provider.grow_to_size }.to raise_error(Exception)
      end        
    end
  
    context "validate change_snap_cpg method  [Case: No change in snap_cpg]" do         
      it "validate positive case for change_snap_cpg method" do
        hpe3parapi = HPE3PAR_API.new(volume_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:volume_exists?).returns true
        hpe3parapi.stubs(:cpg_exists?).returns true
        my_vol = mock()
        hpe3parapi.stubs(:get_volume).returns my_vol
        my_vol.stubs(:snap_cpg).returns 'FC_r1'     
        hpe3parapi.stubs(:change_snap_cpg).returns true
        volume_obj.provider.change_snap_cpg
      end
         
      it "validate negative case for change_snap_cpg method  [Case: volume exists returns a false]" do
        hpe3parapi = HPE3PAR_API.new(volume_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:volume_exists?).returns false
        hpe3parapi.stubs(:cpg_exists?).returns true
        my_vol = mock()
        hpe3parapi.stubs(:get_volume).returns my_vol
        my_vol.stubs(:snap_cpg).returns 'FC_r1' 
        hpe3parapi.stubs(:change_snap_cpg).returns true
        expect{ volume_obj.provider.change_snap_cpg }.to raise_error(Exception)
      end
        
      it "validate negative case for change_snap_cpg method  [Case: Change in snap_cpg name]" do
        hpe3parapi = HPE3PAR_API.new(volume_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:volume_exists?).returns true
        hpe3parapi.stubs(:cpg_exists?).returns true
        my_vol = mock()
        hpe3parapi.stubs(:get_volume).returns my_vol
        my_vol.stubs(:snap_cpg).returns 'FC_r2'
        hpe3parapi.stubs(:change_snap_cpg).returns true
        volume_obj.provider.change_snap_cpg
      end      
           
      it "validate negative case for change_snap_cpg method [Case: volume exists returns a false]" do
        hpe3parapi = HPE3PAR_API.new(volume_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:volume_exists?).returns false
        hpe3parapi.stubs(:cpg_exists?).returns true
        my_vol = mock()
        hpe3parapi.stubs(:get_volume).returns my_vol
        my_vol.stubs(:snap_cpg).returns 'FC_r2'
        hpe3parapi.stubs(:change_snap_cpg).returns true
        expect{ volume_obj.provider.change_snap_cpg }.to raise_error(Exception)
      end
      
           
      it "validate negative case for change_snap_cpg method [Case: CPG exists returns a false]" do
        hpe3parapi = HPE3PAR_API.new(volume_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:volume_exists?).returns true
        hpe3parapi.stubs(:cpg_exists?).returns false
        my_vol = mock()
        hpe3parapi.stubs(:get_volume).returns my_vol
        my_vol.stubs(:snap_cpg).returns 'FC_r2'
        hpe3parapi.stubs(:change_snap_cpg).returns true
        expect{ volume_obj.provider.change_snap_cpg }.to raise_error(Exception)
      end
      
                       
      it "validate negative case for change_snap_cpg method [Case: volume exists and CPG exists returns a false]" do
        hpe3parapi = HPE3PAR_API.new(volume_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:volume_exists?).returns false
        hpe3parapi.stubs(:cpg_exists?).returns false
        my_vol = mock()
        hpe3parapi.stubs(:get_volume).returns my_vol
        my_vol.stubs(:snap_cpg).returns 'FC_r2'
        hpe3parapi.stubs(:change_snap_cpg).returns true
        expect{ volume_obj.provider.change_snap_cpg }.to raise_error(Exception)
      end
      
      it "validate negative case for change_snap_cpg method [Case: change_snap_cpg throws a exception ]" do
        hpe3parapi = HPE3PAR_API.new(volume_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:volume_exists?).returns true
        hpe3parapi.stubs(:cpg_exists?).returns true
        my_vol = mock()
        hpe3parapi.stubs(:get_volume).returns my_vol
        my_vol.stubs(:snap_cpg).returns 'FC_r2'
        hpe3parapi.stubs(:change_snap_cpg).raises Hpe3parSdk::HPE3PARException
        expect{ volume_obj.provider.change_snap_cpg }.to raise_error(Exception)
      end 
          
      it "validate negative case for change_snap_cpg method [Case: change_snap_cpg throws a exception ]" do
        hpe3parapi = HPE3PAR_API.new(volume_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:volume_exists?).returns true
        hpe3parapi.stubs(:cpg_exists?).returns true
        my_vol = mock()
        hpe3parapi.stubs(:get_volume).returns my_vol
        my_vol.stubs(:snap_cpg).returns 'FC_r2'
        hpe3parapi.stubs(:change_snap_cpg).returns true
        expect{ volume_obj_1.provider.change_snap_cpg }.to raise_error(Exception)
      end             
    end

    context "validate change_user_cpg method" do         
      it "validate positive case for change_user_cpg method  [Case: No Change in user_cpg name]" do
        hpe3parapi = HPE3PAR_API.new(volume_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:volume_exists?).returns true
        hpe3parapi.stubs(:cpg_exists?).returns true
        my_vol = mock()
        hpe3parapi.stubs(:get_volume).returns my_vol
        my_vol.stubs(:user_cpg).returns 'FC_r1'     
        hpe3parapi.stubs(:change_user_cpg).returns true
        volume_obj.provider.change_user_cpg
      end
         
      it "validate negative case for change_user_cpg method [Case: volume exists returns a false]" do
        hpe3parapi = HPE3PAR_API.new(volume_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:volume_exists?).returns false
        hpe3parapi.stubs(:cpg_exists?).returns true
        my_vol = mock()
        hpe3parapi.stubs(:get_volume).returns my_vol
        my_vol.stubs(:user_cpg).returns 'FC_r1' 
        hpe3parapi.stubs(:change_user_cpg).returns true
        expect{ volume_obj.provider.change_user_cpg }.to raise_error(Exception)
      end
        
      it "validate positive case for change_user_cpg method  [Case: Change in user_cpg name]" do
        hpe3parapi = HPE3PAR_API.new(volume_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:volume_exists?).returns true
        hpe3parapi.stubs(:cpg_exists?).returns true
        my_vol = mock()
        hpe3parapi.stubs(:get_volume).returns my_vol
        my_vol.stubs(:user_cpg).returns 'FC_r2'
        hpe3parapi.stubs(:change_user_cpg).returns true
        volume_obj.provider.change_user_cpg
      end      
           
      it "validate negative case for change_user_cpg method [Case: volume exists returns a false]" do
        hpe3parapi = HPE3PAR_API.new(volume_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:volume_exists?).returns false
        hpe3parapi.stubs(:cpg_exists?).returns true
        my_vol = mock()
        hpe3parapi.stubs(:get_volume).returns my_vol
        my_vol.stubs(:user_cpg).returns 'FC_r2'
        hpe3parapi.stubs(:change_user_cpg).returns true
        expect{ volume_obj.provider.change_user_cpg }.to raise_error(Exception)
      end
      
      it "validate negative case for change_user_cpg method [Case: volume exists returns a false and CPG exists returns a false]" do
        hpe3parapi = HPE3PAR_API.new(volume_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:volume_exists?).returns false
        hpe3parapi.stubs(:cpg_exists?).returns false
        my_vol = mock()
        hpe3parapi.stubs(:get_volume).returns my_vol
        my_vol.stubs(:user_cpg).returns 'FC_r2'
        hpe3parapi.stubs(:change_user_cpg).returns true
        expect{ volume_obj.provider.change_user_cpg }.to raise_error(Exception)
      end
      
      it "validate negative case for change_user_cpg method [Case: CPG exists returns a false]" do
        hpe3parapi = HPE3PAR_API.new(volume_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:volume_exists?).returns true
        hpe3parapi.stubs(:cpg_exists?).returns false
        my_vol = mock()
        hpe3parapi.stubs(:get_volume).returns my_vol
        my_vol.stubs(:user_cpg).returns 'FC_r2'
        hpe3parapi.stubs(:change_user_cpg).returns true
        expect{ volume_obj.provider.change_user_cpg }.to raise_error(Exception)
      end
      
      it "validate negative case for change_user_cpg method  [Case: change_user_cpg throws a exception ]" do
        hpe3parapi = HPE3PAR_API.new(volume_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:volume_exists?).returns true
        hpe3parapi.stubs(:cpg_exists?).returns true
        my_vol = mock()
        hpe3parapi.stubs(:get_volume).returns my_vol
        my_vol.stubs(:user_cpg).returns 'FC_r2'
        hpe3parapi.stubs(:change_user_cpg).raises Hpe3parSdk::HPE3PARException
        expect{ volume_obj.provider.change_user_cpg }.to raise_error(Exception)
      end                    
    end
     
    context "validate set_snap_cpg method" do         
      it "validate positive case for set_snap_cpg method  [Case: No Change in snap_cpg name]" do
        hpe3parapi = HPE3PAR_API.new(volume_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:volume_exists?).returns true
        hpe3parapi.stubs(:cpg_exists?).returns true
        my_vol = mock()
        hpe3parapi.stubs(:get_volume).returns my_vol
        my_vol.stubs(:snap_cpg).returns 'FC_r1'     
        hpe3parapi.stubs(:set_snap_cpg).returns true
        expect{ volume_obj.provider.set_snap_cpg }.to raise_error(Exception)
      end
         
      it "validate negative case for set_snap_cpg method  [Case: volume exists returns a false]" do
        hpe3parapi = HPE3PAR_API.new(volume_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:volume_exists?).returns false
        hpe3parapi.stubs(:cpg_exists?).returns true
        my_vol = mock()
        hpe3parapi.stubs(:get_volume).returns my_vol
        my_vol.stubs(:snap_cpg).returns 'FC_r1' 
        hpe3parapi.stubs(:set_snap_cpg).returns true
        expect{ volume_obj.provider.set_snap_cpg }.to raise_error(Exception)
      end
        
      it "validate negative case for set_snap_cpg method [Case: Change in snap_cpg name]" do
        hpe3parapi = HPE3PAR_API.new(volume_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:volume_exists?).returns true
        hpe3parapi.stubs(:cpg_exists?).returns true
        my_vol = mock()
        hpe3parapi.stubs(:get_volume).returns my_vol
        my_vol.stubs(:snap_cpg).returns 'FC_r2'
        hpe3parapi.stubs(:set_snap_cpg).returns true
        expect{ volume_obj.provider.set_snap_cpg }.to raise_error(Exception)
      end
      
      it "validate positive case for set_snap_cpg method [Case: Set snap_cpg name]" do
        hpe3parapi = HPE3PAR_API.new(volume_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:volume_exists?).returns true
        hpe3parapi.stubs(:cpg_exists?).returns true
        my_vol = mock()
        hpe3parapi.stubs(:get_volume).returns my_vol
        my_vol.stubs(:snap_cpg).returns nil
        hpe3parapi.stubs(:set_snap_cpg).returns true
        volume_obj.provider.set_snap_cpg
      end             
           
      it "validate negative case for set_snap_cpg method [Case: volume exists returns a false]" do
        hpe3parapi = HPE3PAR_API.new(volume_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:volume_exists?).returns false
        hpe3parapi.stubs(:cpg_exists?).returns true
        my_vol = mock()
        hpe3parapi.stubs(:get_volume).returns my_vol
        my_vol.stubs(:snap_cpg).returns 'FC_r2'
        hpe3parapi.stubs(:set_snap_cpg).returns true
        expect{ volume_obj.provider.set_snap_cpg }.to raise_error(Exception)
      end
      
      it "validate negative case for set_snap_cpg method [Case: set_snap_cpg throws a exception ]" do
        hpe3parapi = HPE3PAR_API.new(volume_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:volume_exists?).returns true
        hpe3parapi.stubs(:cpg_exists?).returns true
        my_vol = mock()
        hpe3parapi.stubs(:get_volume).returns my_vol
        my_vol.stubs(:snap_cpg).returns 'FC_r2'
        hpe3parapi.stubs(:set_snap_cpg).raises Hpe3parSdk::HPE3PARException
        expect{ volume_obj.provider.set_snap_cpg }.to raise_error(Exception)
      end        
    end
    
    context "validate convert_type method" do         
      it "validate positive case for convert_type method [Case: volume type is FPVV]" do
        hpe3parapi = HPE3PAR_API.new(volume_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:volume_exists?).returns true
        my_vol = mock()
        hpe3parapi.stubs(:get_volume).returns my_vol
        my_vol.stubs(:provisioning_type).returns 1
        hpe3parapi.stubs(:get_volume_type).returns 'FPVV'
        hpe3parapi.stubs(:convert_volume_type).returns true
        volume_obj.provider.convert_type
      end
      
      it "validate positive case for convert_type method [Case: actual volume type is FPVV but needs to be changed to 'TPVV']" do
        hpe3parapi = HPE3PAR_API.new(volume_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:volume_exists?).returns true
        my_vol = mock()
        hpe3parapi.stubs(:get_volume).returns my_vol
        my_vol.stubs(:provisioning_type).returns 1
        hpe3parapi.stubs(:get_volume_type).returns 'TPVV'
        hpe3parapi.stubs(:convert_volume_type).returns true
        volume_obj.provider.convert_type
      end     
      
      it "validate positive case for convert_type method [Case: volume type is UNKNOWN]" do
        hpe3parapi = HPE3PAR_API.new(volume_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:volume_exists?).returns true
        my_vol = mock()
        hpe3parapi.stubs(:get_volume).returns my_vol
        my_vol.stubs(:provisioning_type).returns 5
        hpe3parapi.stubs(:get_volume_type).returns 'TPVV'
        hpe3parapi.stubs(:convert_volume_type).returns true
        volume_obj.provider.convert_type
      end

      it "validate positive case for convert_type method [Case: volume exists returns a false]" do
        hpe3parapi = HPE3PAR_API.new(volume_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:volume_exists?).returns false
        my_vol = mock()
        hpe3parapi.stubs(:get_volume).returns my_vol
        my_vol.stubs(:provisioning_type).returns 2
        hpe3parapi.stubs(:get_volume_type).returns 'FPVV'
        hpe3parapi.stubs(:convert_volume_type).returns true
        expect{ volume_obj.provider.convert_type }.to raise_error(Exception)
      end

      it "validate positive case for convert_type method [Case: actual volume type is TDVV but needs to be changed to 'FPVV']" do
        hpe3parapi = HPE3PAR_API.new(volume_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:volume_exists?).returns true
        my_vol = mock()
        hpe3parapi.stubs(:get_volume).returns my_vol
        my_vol.stubs(:provisioning_type).returns 6
        hpe3parapi.stubs(:get_volume_type).returns 'FPVV'
        hpe3parapi.stubs(:convert_volume_type).returns true
        volume_obj.provider.convert_type
      end
      
      it "validate negative case case for convert_type method [Case: convert_type throws a exception ]" do
        hpe3parapi = HPE3PAR_API.new(volume_obj[:url])
        described_class.stubs(:transport).returns hpe3parapi
        hpe3parapi.stubs(:volume_exists?).returns true
        my_vol = mock()
        hpe3parapi.stubs(:get_volume).returns my_vol
        my_vol.stubs(:provisioning_type).returns 1
        hpe3parapi.stubs(:get_volume_type).returns 'TPVV'
        hpe3parapi.stubs(:convert_volume_type).raises Hpe3parSdk::HPE3PARException
        expect{ volume_obj.provider.convert_type }.to raise_error(Exception)     
      end  
    end
             
  
  end
end