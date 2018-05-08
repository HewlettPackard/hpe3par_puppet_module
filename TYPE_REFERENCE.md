# Type Reference

### hpe3par_cpg

Common Provisioning Group (CPG)

#### Parameters


disk_type
: Specifies that physical disks must have the specified device type.

  Valid values are `FC`, `NL`, `SSD`.

domain
: Specifies the domain in which the CPG will reside.

ensure
: The basic property that the resource should be in.

  Valid values are `present`, `absent`.

growth_increment
: Specifies the growth increment the amount of logical disk storage created on each auto-grow operation.

growth_increment_unit
: Unit of value

  Valid values are `MiB`, `GiB`, `TiB`.

growth_limit
: Specifies that the autogrow operation is limited to the specified storage amount that sets the growth limit.

growth_limit_unit
: Unit of value.

  Valid values are `MiB`, `GiB`, `TiB`.

growth_warning
: Specifies that the threshold of used logical disk space when exceeded results in a warning alert.

growth_warning_unit
: Unit of value

  Valid values are `MiB`, `GiB`, `TiB`.

high_availability
: Specifies that the layout must support the failure of one port pair, one cage, or one magazine.

  Valid values are `PORT`, `CAGE`, `MAG`.

name
: Name of the CPG.

password
: The password for the storage system User.

provider
: The specific backend to use for this `hpe3par_cpg`
  resource. You will seldom need to specify this --- Puppet will usually
  discover the appropriate provider for your platform.Available providers are:

raid_type
: Specifies the RAID type for the logical disk.

set_size
: Specifies the set size in the number of chunklets.

ssip
: The storage system IP address or FQDN.

url
: If using URL do not use ssip, user, and password.
  URL in the form of https://user:password@ssip:8080/

user
: The storage system user name.




----------------

### hpe3par_flash_cache

Flash cache

#### Parameters


ensure
: The basic property that the resource should be in.

  Valid values are `present`, `absent`.

mode
: Simulator: 1
  Real: 2 (default)

  Valid values are `simulator`, `real`.

name
:

password
: The password for the storage system User.

provider
: The specific backend to use for this `hpe3par_flash_cache`
  resource. You will seldom need to specify this --- Puppet will usually
  discover the appropriate provider for your platform.Available providers are:

size_in_gib
: Specifies the node pair size of the Flash Cache on the system.

ssip
: The storage system IP address or FQDN.

url
: If using URL do not use ssip, user, and password.
  URL in the form of https://user:password@ssip:8080/

user
: The storage system user name.




----------------

### hpe3par_host

HPE 3PAR Host

#### Parameters


chap_name
: The chap name.

chap_secret
: The chap secret for the host or the target.

chap_secret_hex
: If true, then chapSecret is treated as Hex.

  Valid values are `true`, `false`.

domain
: Specifies the domain in which the host is created.

ensure
: Valid values are `present`, `absent`, `modify`, `add_initiator_chap`, `remove_initiator_chap`, `add_target_chap`, `remove_target_chap`, `add_fc_path_to_host`, `remove_fc_path_from_host`, `add_iscsi_path_to_host`, `remove_iscsi_path_from_host`.

fc_wwns
: Specifies the WWNs to be specified for the host.

force_path_removal
: If true, remove WWN(s) or iSCSI(s) even if there are VLUNs that are exported to the host.

  Valid values are `true`, `false`.

host_name
: (**Namevar:** If omitted, this parameter's value defaults to the resource's title.)

  Name of the 3PAR host.

iscsi_names
: Specifies the ISCSI names to be set for the host.

new_name
: Specifies the new name for the host

password
: The password for the storage system User.

persona
: Specifies the domain in which the host is created.

  Valid values are `GENERIC`, `GENERIC_ALUA`, `GENERIC_LEGACY`, `HPUX_LEGACY`, `AIX_LEGACY`, `EGENERA`, `ONTAP_LEGACY`, `VMWARE`, `OPENVMS`, `HPUX`, `WINDOWS_SERVER`.

provider
: The specific backend to use for this `hpe3par_host`
  resource. You will seldom need to specify this --- Puppet will usually
  discover the appropriate provider for your platform.Available providers are:

ssip
: The storage system IP address or FQDN.

url
: If using URL do not use ssip, user, and password.
  URL in the form of https://user:password@ssip:8080/

user
: The storage system user name.




----------------

### hpe3par_hostset

Host Set

#### Parameters


domain
: The domain in which the VV set or host set will be created.

ensure
: Valid values are `present`, `absent`, `add_host`, `remove_host`.

name
: Name of the Host set

password
: The password for the storage system User.

provider
: The specific backend to use for this `hpe3par_hostset`
  resource. You will seldom need to specify this --- Puppet will usually
  discover the appropriate provider for your platform.Available providers are:

setmembers
: The host to be added to the set.

ssip
: The storage system IP address or FQDN.

url
: If using URL do not use ssip, user, and password.
  URL in the form of https://user:password@ssip:8080/

user
: The storage system user name.




----------------

### hpe3par_offline_clone

Virtual Volume Offline clone

#### Parameters


base_volume_name
: Specifies the destination volume.

dest_cpg
: Specifies the destination CPG for an online copy.

ensure
: Valid values are `present`, `absent`, `resync`, `stop`.

name
: Name of the Offline clone.

password
: The password for the storage system User.

priority
: Does not apply to online copy.

  Valid values are `HIGH`, `MEDIUM`, `LOW`.

provider
: The specific backend to use for this `hpe3par_offline_clone`
  resource. You will seldom need to specify this --- Puppet will usually
  discover the appropriate provider for your platform.Available providers are:

save_snapshot
: Enables (true) or disables (false) saving the the snapshot of the source volume after completing the copy of the volume. Defaults to false

  Valid values are `true`, `false`.

ssip
: The storage system IP address or FQDN.

url
: If using URL do not use ssip, user, and password.
  URL in the form of https://user:password@ssip:8080/

user
: The storage system user name.




----------------

### hpe3par_online_clone

Virtual Volume Online clone.

#### Parameters


base_volume_name
: Specifies the destination volume.

compression
: Enables (true) or disables (false) compression.

  Valid values are `true`, `false`.

dest_cpg
: Specifies the destination CPG for an online copy.

ensure
: Valid values are `present`, `absent`, `resync`, `stop`.

name
: Name of the Online clone.

password
: The password for the storage system User.

provider
: The specific backend to use for this `hpe3par_online_clone`
  resource. You will seldom need to specify this --- Puppet will usually
  discover the appropriate provider for your platform.Available providers are:

skip_zero
: Enables (true) or disables (false) copying only allocated portions of the source VV from a thin provisioned source. Use only on a newly created destination, or if the destination was re-initialized to zero. Does not overwrite preexisting data on the destination VV to match the source VV unless the same offset is allocated in the source.

  Valid values are `true`, `false`.

snap_cpg
: Specifies the snapshot CPG for an online copy.

ssip
: The storage system IP address or FQDN.

tdvv
: Enables (true) or disables (false) whether the online copy is a TDVV. Defaults to false. tpvv and tdvv cannot be set to true at the same time.

  Valid values are `true`, `false`.

tpvv
: Enables (true) or disables (false) whether the online copy is a TPVV. Defaults to false. tpvv and tdvv cannot be set to true at the same time.

  Valid values are `true`, `false`.

url
: If using URL do not use ssip, user, and password.
  URL in the form of https://user:password@ssip:8080/

user
: The storage system user name.




----------------

### hpe3par_qos

Quality of Service

#### Parameters


bwmax_limit_kb
: Bandwidth rate maximum limit in kilobytes per second.

bwmax_limit_op
: When set to ZERO, the bandwidth
  minimum goal is 0.
      When set to NOLIMIT, the bandwidth
  minimum goal is none

  Valid values are `ZERO`, `NOLIMIT`.

bwmin_goal_kb
: Bandwidth rate minimum goal in kilobytes per second.

bwmin_goal_op
: When set to ZERO, the bandwidth
  minimum goal is 0.
      When set to NOLIMIT, the bandwidth
  minimum goal is none

  Valid values are `ZERO`, `NOLIMIT`.

default_latency
: If true, set latencyGoal to the default value.
  If false and the latencyGoal value is positive, then set the value.
  Default is false.

  Valid values are `true`, `false`.

enable
: If true, enable the QoS rule for the target object.
  If false, disable the QoS rule for the target object.

ensure
: Valid values are `present`, `absent`, `modify`.

iomax_limit
: I/O-per-second maximum limit.

iomax_limit_op
: When set to ZERO, the bandwidth
  minimum goal is 0.
      When set to NOLIMIT, the bandwidth
  minimum goal is none

  Valid values are `ZERO`, `NOLIMIT`.

iomin_goal
: I/O-per-second minimum goal.

iomin_goal_op
: When set to ZERO, the bandwidth
  minimum goal is 0.
      When set to NOLIMIT, the bandwidth
  minimum goal is none

  Valid values are `ZERO`, `NOLIMIT`.

latency_goal
: Latency goal in milliseconds.

latency_goal_usecs
: Latency goal in microseconds.

password
: The password for the storage system User.

priority
: QoS priority.

  Valid values are `LOW`, `NORMAL`, `HIGH`.

provider
: The specific backend to use for this `hpe3par_qos`
  resource. You will seldom need to specify this --- Puppet will usually
  discover the appropriate provider for your platform.Available providers are:

qos_target_name
: (**Namevar:** If omitted, this parameter's value defaults to the resource's title.)

  The name of the target object on which the new QoS rules will be created.

ssip
: The storage system IP address or FQDN.

type
: Type of QoS target.

  Valid values are `vvset`, `sys`.

url
: If using URL do not use ssip, user, and password.
  URL in the form of https://user:password@ssip:8080/

user
: The storage system user name.




----------------

### hpe3par_snapshot

Virtual Volume Snapshot

#### Parameters


allow_remote_copy_parent
: Allows the promote operation to proceed even if the RW parent volume is currently in a Remote Copy volume group, if that group has not been started. If the Remote Copy group has been started, this command fails.

  Valid values are `true`, `false`.

base_volume_name
: Specifies the source volume

ensure
: Valid values are `present`, `absent`, `modify`, `restore_offline`, `restore_online`.

expiration_hours
: Specifies the relative time from the current time that the volume expires. Value is a positive integer and in the range of 1 to 43,800 hours, or 1825 days.

expiration_time
: Specifies the relative time from the current time that the volume expires. Value is a positive integer and in the range of 1 to 43,800 hours, or 1825 days.

expiration_unit
: Unit of value

  Valid values are `Hours`, `Days`.

name
: Specifies a snapshot volume name up to 31 characters in length.

new_name
: New name of the volume.

online
: Enables (true) or disables (false) executing the promote operation on an online volume.

  Valid values are `true`, `false`.

password
: The password for the storage system User.

priority
: Does not apply to online promote operation or to stop promote operation.

  Valid values are `HIGH`, `MEDIUM`, `LOW`.

provider
: The specific backend to use for this `hpe3par_snapshot`
  resource. You will seldom need to specify this --- Puppet will usually
  discover the appropriate provider for your platform.Available providers are:

read_only
: true: Specifies that the copied volume is read-only. false: (default) The volume is read/write.

  Valid values are `true`, `false`.

retention_hours
: Specifies the relative time from the current time that the volume expires. Value is a positive integer and in the range of 1 to 43,800 hours, or 1825 days.

retention_time
: Specifies the relative time from the current time that the volume will expire. Value is a positive integer and in the range of 1 to 43,800 hours, or 1825 days.

retention_unit
: Unit of value

  Valid values are `Hours`, `Days`.

rm_exp_time
: Enables (false) or disables (true) resetting the expiration time. If false, and expiration time value is a positive number, then set.

  Valid values are `true`, `false`.

snap_cpg
: Snap CPG name.

ssip
: The storage system IP address or FQDN.

url
: If using URL do not use ssip, user, and password.
  URL in the form of https://user:password@ssip:8080/

user
: The storage system user name.




----------------

### hpe3par_vlun

VLUN

#### Parameters


autolun
: States whether the lun nmber should be autosigned.

card_port
: Port number on the FC card.

ensure
: Valid values are `export_volume_to_host`, `unexport_volume_to_host`, `export_volume_to_hostset`, `unexport_volume_to_hostset`, `export_volumeset_to_host`, `unexport_volumeset_to_host`, `export_volumeset_to_hostset`, `unexport_volumeset_to_hostset`.

host_name
: Name of the host.

hostset_name
: Name of the hostset.

lunid
: LUN ID.

name
:

node_val
: System node.

password
: The password for the storage system User.

provider
: The specific backend to use for this `hpe3par_vlun`
  resource. You will seldom need to specify this --- Puppet will usually
  discover the appropriate provider for your platform.Available providers are:

slot
: PCI bus slot in the node.

ssip
: The storage system IP address or FQDN.

url
: If using URL do not use ssip, user, and password.
  URL in the form of https://user:password@ssip:8080/

user
: The storage system user name.

volume_name
: Volume name.

volumeset_name
: Name of the VV set to export.




----------------

### hpe3par_volume

Virtual Volume

#### Parameters


compression
: Specifes whether the compression is on or off

  Valid values are `true`, `false`.

cpg
: Specifies the name of the CPG from which the volume user space will be allocated.

ensure
: Valid values are `present`, `absent`, `modify`, `grow`, `grow_to_size`, `change_snap_cpg`, `change_user_cpg`, `convert_type`, `set_snap_cpg`.

expiration_hours
: Remaining time, in hours, before the volume expires.

keep_vv
: Name of the new volume where the original logical disks are saved.

new_name
: Specifies the new name for the volume.

password
: The password for the storage system User.

provider
: The specific backend to use for this `hpe3par_volume`
  resource. You will seldom need to specify this --- Puppet will usually
  discover the appropriate provider for your platform.Available providers are:

retention_hours
: Sets the number of hours to retain the volume.

rm_exp_time
: Enables (false) or disables (true) resetting the expiration time.
  If false, and expiration time value is a positive number, then set.

  Valid values are `true`, `false`.

rm_ss_spc_alloc_limit
: Enables (false) or disables (true) removing the snapshot space allocation limit.
  If false, and limit value is 0, setting  ignored.If false, and limit value is a positive number, then set

  Valid values are `true`, `false`.

rm_ss_spc_alloc_warning
: Enables (false) or disables (true) removing the snapshot space allocation warning.
  If false, and warning value is a positive number, then set.

  Valid values are `true`, `false`.

rm_usr_spc_alloc_limit
: Enables (false) or disables (true)false) the allocation limit.
  If false, and limit value is a positive number, then set.

  Valid values are `true`, `false`.

rm_usr_spc_alloc_warning
: Enables (false) or disables (true) removing the user space allocation warning.
  If false, and warning value is a positive number, then set

  Valid values are `true`, `false`.

size
: Specifies the size of the volume

size_unit
: Specifies the unit of the volume size

  Valid values are `MiB`, `GiB`, `TiB`.

snap_cpg
: Specifies the name of the CPG from which the snapshot space will be allocated.

ss_spc_alloc_limit_pct
: Prevents the snapshot space of  the virtual volume
  from growing beyond the indicated percentage of the virtual volume size.

ss_spc_alloc_warning_pct
: Generates a warning alert when the reserved snapshot space of the virtual volume
  exceeds the indicated percentage of the virtual volume size.

ssip
: The storage system IP address or FQDN.

type
: Specifies the type of the volume

  Valid values are `thin`, `thin_dedupe`, `full`.

url
: If using URL do not use ssip, user, and password.
  URL in the form of https://user:password@ssip:8080/

user
: The storage system user name.

usr_spc_alloc_limit_pct
: Prevents the user space of the TPVV from growing beyond the indicated percentage of the virtual volume size.
  After reaching this limit, any new writes to the virtual volume will fail.

usr_spc_alloc_warning_pct
: Generates a warning alert when the user data space of the TPVV exceeds
  the specified percentage of the virtual volume size.

volume_name
: (**Namevar:** If omitted, this parameter's value defaults to the resource's title.)

  Name of the Virtual Volume.

wait_for_task_to_end
: Setting to true makes the resource to wait until a task (asynchronous operation, for ex: convert type) ends.

  Valid values are `true`, `false`.




----------------

### hpe3par_volume_set

Virtual Volume Set

#### Parameters


domain
: The domain into which VV set is to be added.

ensure
: Valid values are `present`, `absent`, `add_volume`, `remove_volume`.

password
: The password for the storage system User.

provider
: The specific backend to use for this `hpe3par_volume_set`
  resource. You will seldom need to specify this --- Puppet will usually
  discover the appropriate provider for your platform.Available providers are:

setmembers
: The virtual volume to be added

ssip
: The storage system IP address or FQDN.

url
: If using URL do not use ssip, user, and password.
  URL in the form of https://user:password@ssip:8080/

user
: The storage system user name.

volume_set_name
: (**Namevar:** If omitted, this parameter's value defaults to the resource's title.)

  Name of the Virtual Volume set.
