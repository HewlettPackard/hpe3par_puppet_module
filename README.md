# HPE 3PAR Module for Puppet

The hpe3par module is a starter kit which provides types and providers, using which you can write recipes to manage HPE 3PAR storage arrays.
This module uses the hpe3par_sdk to communicate with the 3PAR storage arrays over http/https through the WSAPI REST service
hosted on the array.

Use this by creating a new module and specifying a dependency on this module in your metadata. Then use any of the types provided by this module.

**Note: The module name is 'hpe3par'. If you want to directly use from source, you need to rename the directory hpe3par_puppet_module to hpe3par in order to use the types.**

## Requirements

* 3PAR OS
   * 3.2.2 MU4 + 106, MU6 + P107
   * 3.3.1 MU2
* Puppet - 5.3
* [hpe3par_sdk](https://rubygems.org/gems/hpe3par_sdk/) ruby gem
* WSAPI service should be enabled on the 3PAR storage array.

## Pre-requisite installation

The **hpe3par module** uses the **hpe3par_sdk** ruby library to communicate with the HPE 3PAR array.
To install the library dependency automatically include the following in your node
definition:

```puppet
class { 'hpe3par' : }
```

This will install the hpe3par_sdk onto the specified node.

## Usage
The HPE 3PAR module can be used both in **Puppet Device** mode and **Puppet Agent** mode.
Explanations as well as examples of what these modes mean are given below:

### Puppet Agent

Puppet agent is the client/slave side of the puppet master/slave relationship.
In the case of puppet agent the connection information needs to be included in
the manifest supplied to the agent from the master or it could be included
in a custom fact passed to the client. The connection string may be supplied
as a URL or as 3 separate parameters (user, password and
ssip). See the example manifests for details.

Example:

```puppet
  hpe3par_volume { 'data_volume_1' :
    ensure                   => present,
    cpg                      => 'FC_r1',
    size                     => 1024,
    size_unit                => 'MiB',
    expiration_hours         => 5,
    ss_spc_alloc_warning_pct => '40',
    rm_ss_spc_alloc_warning  => true,
    url                      => 'https://3par_user:3par_user@array1.3par.com:8080'
  }
```

or
```puppet
  hpe3par_volume { 'data_volume_1' :
    ensure                   => present,
    cpg                      => 'FC_r1',
    size                     => 1024,
    size_unit                => 'MiB',
    expiration_hours         => 5,
    ss_spc_alloc_warning_pct => '40',
    rm_ss_spc_alloc_warning  => true,
    user                     => '3par_user',
    password                 => '3par_user',
    ssip                     => 'array1.3par.com'
  }
```

In the case of Puppet Agent, connections to the HPE 3PAR array will be
initiated from every machine which utilizes the HPE 3PAR puppet module this
way.

### Puppet Device

The Puppet Network Device (NetDev) system is a way to configure devices (switches,
routers, storage) which do not have the ability to run Puppet agent natively. This application acts as a smart proxy between the Puppet
Master and the managed device. To do this, Puppet NetDev
connects to the Master on behalf of the managed device
and asks for a catalog (a catalog containing device
resources). It will then apply this catalog to the device by translating
the resources to orders that the managed device understands. Puppet NetDev will
then report back to the Master of any changes and failures in the same manner as a standard node.

The HPE 3PAR providers are designed to work with the Puppet Device concept and
retrieves connection information from the `url` given
in Puppet's `device.conf` file. Connection to the HPE 3PAR array is made from the machine running the `puppet device` command. An example is shown below:

      [array1.3par.com]
      type hpe3par
      url https://admin:password@array1.3par.com

In this mode, there is no need to specify array connection details while declaring a resource,
since the connection details are picked up from the device config. 

**Example:**

```puppet
  # No need to specify the array connection details.
  # Connection details need to be specified in the device.conf.
  hpe3par_volume { 'data_volume_1' :
    ensure                   => present,
    cpg                      => 'FC_r1',
    size                     => 1024,
    size_unit                => 'MiB',
    expiration_hours         => 5,
    ss_spc_alloc_warning_pct => '40',
    rm_ss_spc_alloc_warning  => true
  }
```

## Non Idempotent Actions

Actions are **_Idempotent_** when they can be run multiple times on the same system and the results will always be identical, without producing unintended side effects.

The following actions are **_non-idempotent_**:

- **Clone:** resync, create_offline
- **Snapshot:** restore online, restore offline
- **Virtual Volume:** grow (grow_to_size is idempotent)
- **VLUN:** All actions become non-idempotent when <em>autolun</em> is set to <em>true</em>

## Reference

[Type Reference](/TYPE_REFERENCE.md)

## Development

Please read our [Community Contributions Guidelines](/CONTRIBUTING.md)

## License
This project is licensed under the Apache 2.0 license. Please see [LICENSE](/LICENSE) for more info
