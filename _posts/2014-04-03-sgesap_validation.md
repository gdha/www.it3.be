---
layout: post
title: Using sgesap_validation(_wrapper) scripts

description: Explaining the usage of sgesap_validation.sh and sgesap_validation_wrapper.sh scripts

tags: [terminal, servicegaurd, SGeSAP, SAP, HP-UX, howto, validation, error checking, it3 consultants]
author: gratien
---

<strong>Explaining the usage of sgesap_validation.sh and sgesap_validation_wrapper.sh scripts</strong>

The purpose of SGeSAP (Serviceguard extensions for SAP) is to integrate SAP start and stop functions into a serviceguard package.
However, from experience we know it is easy to forget a critical setting or definition in the package configuration file. Furthermore, these little mistakes are not always easy to spot. This was the main reason why we developed this script to inspect the ASCII serviceguard package file before bringing the paqckage into production. In the meantime the script evaluated that it is now possible to inspect live (running) packages as well.

From the start SGeSAP packages were in scope, but that does not mean we cannot verify non-SGeSAP packages as well. We will show you with some examples.

_WARNING: this script will only work on Serviceguard version 11.20 and higher and is written for HP-UX 11.31. However, with minor modifications it can work on Linux as well_

The script must be run as root (sorry!) and without any argument it will show you the usage:

    #-> sgesap_validation.sh
    Usage: sgesap_validation.sh [-d] [-s] [-h] [-f] [-M mail_address] package_name
    
    -d:     Enable debug mode (by default off)
    -s:     Disable SGeSAP testing in package configuration file
    -f:     Force the read the local package_name.conf file instead of the one from cmgetconf
    -m:     Monitor mode (less output) shows only warnings and failed lines
    -M:     Add one or more mail addresses with "mail-address1, mail-address2"
    -w:     SAP WebDispatcher
    -h:     Show usage [this page]

The must have argument is *package_name* (use the *-f* option for a new package which is not yet running). We assume that *package_name* resides under `/etc/cmcluster/package_name/package_name.conf`.

To verify a running package on the cluster (use `cmviewcl` to see them) we can use the following command (the package does not have to run on the node where you run the `sgesap_validation.sh` script!)

    #-> sgesap_validation.sh jdbciPDS
    Detailed logging about package jdbciPDS is saved under /var/tmp/sgesap_validation-jdbciPDS-20140403-0855.log
    ###############################################################################################
                   Script: sgesap_validation.sh
                Arguments: jdbciPDS
                  Purpose: Test the consistency of serviceguard (SGeSAP) configuration script
               OS Release: 11.31
                    Model: ia64
                     Host: gtsdbd02
                     User: root
                     Date: 2014-04-03 @ 08:55:14
    ###############################################################################################
     ** Running on HP-UX 11.31                                                           [  OK  ]
     ** Serviceguard A.11.20.00 is valid                                                 [  OK  ]
     ** Serviceguard Extension for SAP B.05.10 is valid                                  [  OK  ]
     ** A valid cluster GTSCDVL01 found, which is running (up)                           [  OK  ]
     ** Package directory (jdbciPDS) found under /etc/cmcluster                          [  OK  ]
     ** Package jdbciPDS is a configured package (cluster GTSCDVL01)                     [  OK  ]
     ** Executing cmgetconf -p jdbciPDS > /var/tmp/jdbciPDS.conf.03Apr2014               [  OK  ]
     ** Package jdbciPDS is up and running                                               [  OK  ]
     ** Found configuration file /var/tmp/jdbciPDS.conf.03Apr2014                        [  OK  ]
     ** Node enablement: node:gtsdbd02|switching=enabled                                 [  OK  ]
     ** Node enablement: node:gtsdbd01|switching=enabled                                 [  OK  ]
     ** Package (jdbciPDS) is running on primary node: gtsdbd02 up gtsdbd01 down         [  OK  ]
     ** Found package_name (jdbciPDS) in jdbciPDS.conf                                   [  OK  ]
     ** Found hostname (jdbciPDS) in /etc/hosts on node gtsdbd01                         [  OK  ]
     ** Found hostname (jdbciPDS) in /etc/hosts on node gtsdbd02                         [  OK  ]
     ** Found package_description (jdbciPDS XPCA Package) in  jdbciPDS.conf              [  OK  ]
     ** Found 2 node_name line(s) (gtsdbd02 gtsdbd01) in jdbciPDS.conf                   [  OK  ]
     ** Found package_type (failover) in jdbciPDS.conf                                   [  OK  ]
     ** Found auto_run (no) in jdbciPDS.conf (continental cluster)                       [  OK  ]
     ** Found node_fail_fast_enabled (no) in jdbciPDS.conf                               [  OK  ]
     ** Found failover_policy (configured_node) in jdbciPDS.conf                         [  OK  ]
     ** Found failback_policy (manual) in jdbciPDS.conf                                  [  OK  ]
     ** Found run_script_timeout (no_timeout) in jdbciPDS.conf                           [  OK  ]
     ** Found halt_script_timeout (no_timeout) in jdbciPDS.conf                          [  OK  ]
     ** Found successor_halt_timeout (no_timeout) in jdbciPDS.conf                       [  OK  ]
     ** Found priority (no_priority) in jdbciPDS.conf                                    [  OK  ]
     ** Found ip_subnet (1 line(s)) in jdbciPDS.conf                                     [  OK  ]
     ** Found ip_address (1 line(s)) in jdbciPDS.conf                                    [  OK  ]
     ** Found local_lan_failover_allowed (yes) in jdbciPDS.conf                          [  OK  ]
     ** Found script_log_file (/var/adm/cmcluster/log/jdbciPDS.log) in jdbciPDS.conf     [  OK  ]
     ** Found vgchange_cmd (vgchange -a e) in jdbciPDS.conf                              [  OK  ]
     ** Found enable_threaded_vgchange (1) in jdbciPDS.conf                              [  OK  ]
     ** Found concurrent_vgchange_operations (2) in jdbciPDS.conf                        [  OK  ]
     ** Found fs_umount_retry_count (3) in jdbciPDS.conf                                 [  OK  ]
     ** Found fs_mount_retry_count (0) in jdbciPDS.conf                                  [  OK  ]
     ** Found concurrent_mount_and_umount_operations (3) in jdbciPDS.conf                [  OK  ]
     ** Found concurrent_fsck_operations (3) in jdbciPDS.conf                            [  OK  ]
     ** No user_name was defined. Perhaps this was on purpose, maybe not - pls verify    [ WARN ]
     ** We found 1 vg (volume group) line(s) in jdbciPDS.conf                            [  OK  ]
     ** Total amount of fs_ lines (105) in jdbciPDS.conf must be odd                     [  OK  ]
     ** VG /dev/vgdbPDS is active on this node                                           [  OK  ]
     ** fs_name=/dev/vgdbPDS/lvoraclePDS (vxfs version 7)                                [  OK  ]
     ** fs_name=/dev/vgdbPDS/lvoriglogAPDS (vxfs version 7)                              [  OK  ]
     ** fs_name=/dev/vgdbPDS/lvoriglogBPDS (vxfs version 7)                              [  OK  ]
     ** fs_name=/dev/vgdbPDS/lvmirrlogAPDS (vxfs version 7)                              [  OK  ]
     ** fs_name=/dev/vgdbPDS/lvmirrlogBPDS (vxfs version 7)                              [  OK  ]
     ** fs_name=/dev/vgdbPDS/lvoraarcPDS (vxfs version 7)                                [  OK  ]
     ** fs_name=/dev/vgdbPDS/lvsapreorgPDS (vxfs version 7)                              [  OK  ]
     ** fs_name=/dev/vgdbPDS/lvflashbPDS (vxfs version 7)                                [  OK  ]
     ** fs_name=/dev/vgdbPDS/lvoprPDS (vxfs version 7)                                   [  OK  ]
     ** fs_name=/dev/vgdbPDS/lvoraarc2PDS (vxfs version 7)                               [  OK  ]
     ** fs_name=/dev/vgdbPDS/lvsapdata1PDS (vxfs version 7)                              [  OK  ]
     ** fs_name=/dev/vgdbPDS/lvmntPDS (vxfs version 7)                                   [  OK  ]
     ** fs_name=/dev/vgdbPDS/lvtransPDS (vxfs version 7)                                 [  OK  ]
     ** fs_name=/dev/vgdbPDS/lvscsPDS (vxfs version 7)                                   [  OK  ]
     ** fs_name=/dev/vgdbPDS/lvtidalPDS (vxfs version 7)                                 [  OK  ]
     ** module_name dbinstance present in jdbciPDS.conf                                  [  OK  ]
     ** module_name db_global present in jdbciPDS.conf                                   [  OK  ]
     ** module_name oracledb_spec present in jdbciPDS.conf                               [  OK  ]
     ** module_name maxdb_spec present in jdbciPDS.conf                                  [  OK  ]
     ** module_name sybasedb_spec present in jdbciPDS.conf                               [  OK  ]
     ** module_name sapinstance present in jdbciPDS.conf                                 [  OK  ]
     ** module_name sap_global present in jdbciPDS.conf                                  [  OK  ]
     ** module_name stack present in jdbciPDS.conf                                       [  OK  ]
     ** module_name sapinfra present in jdbciPDS.conf                                    [  OK  ]
     ** module_name sapinfra_pre present in jdbciPDS.conf                                [  OK  ]
     ** module_name sapinfra_post present in jdbciPDS.conf                               [  OK  ]
     ** sgesap/db_global/db_vendor set to oracle                                         [  OK  ]
     ** Found directory /usr/sap/PDS                                                     [  OK  ]
     ** User orapds home directory is /oracle/PDS                                        [  OK  ]
     ** User pdsadm home directory is /home/pdsadm                                       [  OK  ]
     == Directory /oracle/PDS/.ssh does not exist                                        [ WARN ]
     == Directory /home/pdsadm/.ssh does not exist                                       [ WARN ]
     == No entry found (of sapmsPDS) in /etc/services on node gtsdbd01                   [ WARN ]
     == No entry found (of sapmsPDS) in /etc/services on node gtsdbd02                   [ WARN ]
     ** sgesap/oracledb_spec/listener_name LISTENER_PDS                                  [  OK  ]
     ** sgesap/sap_global/sap_system PDS                                                 [  OK  ]
     ** sgesap/sap_global/rem_comm ssh                                                   [  OK  ]
     ** sgesap/sap_global/cleanup_policy normal                                          [  OK  ]
     ** sgesap/sap_global/retry_count 15                                                 [  OK  ]
     ** sgesap/stack/sap_instance SCS12                                                  [  OK  ]
     ** sgesap/stack/sap_virtual_hostname jdbciPDS                                       [  OK  ]
     ** sgesap/sapinfra/sap_infra_sw_type saposcol                                       [  OK  ]
     ** sgesap/sapinfra/sap_infra_sw_treat startonly                                     [  OK  ]
     ** Found module_names for nfs/hanfs                                                 [  OK  ]
     == nfs/hanfs_export/SUPPORTED_NETIDS udp (prefer "tcp")                             [  OK  ]
     ** nfs/hanfs_export/FILE_LOCK_MIGRATION 1                                           [  OK  ]
     ** nfs/hanfs_export/MONITOR_INTERVAL 10                                             [  OK  ]
     ** nfs/hanfs_export/MONITOR_LOCKD_RETRY 4                                           [  OK  ]
     ** nfs/hanfs_export/MONITOR_DAEMONS_RETRY 4                                         [  OK  ]
     ** nfs/hanfs_export/PORTMAP_RETRY 4                                                 [  OK  ]
     ** nfs/hanfs_flm/FLM_HOLDING_DIR /opr_jdbciPDS/nfs_flm                              [  OK  ]
     ** nfs/hanfs_flm/NFSV4_FLM_HOLDING_DIR ""                                           [  OK  ]
     ** nfs/hanfs_flm/PROPAGATE_INTERVAL 5                                               [  OK  ]
     ** nfs/hanfs_flm/STATMON_WAITTIME 90                                                [  OK  ]
     ** nfs/hanfs_export/XFS /export/sapmnt/PDS (directory exists)                       [  OK  ]
     ** The XFS access list "root=" matches the "rw=" for /export/sapmnt/PDS             [  OK  ]
     ** The XFS access list "ro=jdbciPDS.jnj.com" is correct                             [  OK  ]
     ** nfs/hanfs_export/XFS /export/usr/sap/transPPSDVL (directory exists)              [  OK  ]
     ** The XFS access list "root=" matches the "rw=" for /export/usr/sap/transPPSDVL    [  OK  ]
     ** The XFS access list "ro=jdbciPDS.jnj.com" is correct                             [  OK  ]
     ** /sapmnt/PDS in /etc/auto.direct (on node gtsdbd01) uses "udp" to mount           [  OK  ]
     ** /usr/sap/transPPSDVL in /etc/auto.direct (on node gtsdbd01) uses "udp" to mount  [  OK  ]
     ** /sapmnt/PDS in /etc/auto.direct (on node gtsdbd02) uses "udp" to mount           [  OK  ]
     ** /usr/sap/transPPSDVL in /etc/auto.direct (on node gtsdbd02) uses "udp" to mount  [  OK  ]
     ** $SGCONF/scripts/ext/tidal_ext_script.sh defined in jdbciPDS.conf                 [  OK  ]
     ** DEBUG file /var/adm/cmcluster/debug_jdbciPDS NOT found                           [  OK  ]
    
              No errors were found in /etc/cmcluster/jdbciPDS/jdbciPDS.conf
    
              Run "cmcheckconf -v -P /etc/cmcluster/jdbciPDS/jdbciPDS.conf"
              followed by "cmapplyconf -v -P /etc/cmcluster/jdbciPDS/jdbciPDS.conf"
    
            Log file for jdbciPDS is saved as /var/tmp/sgesap_validation-jdbciPDS-20140403-0855.log
    

Another shorter example is using monitoring mode which will only show warning and errors and therefore, shrink the amount of output drastically (if all is well of course):

    #-> sgesap_validation.sh -m dbciRSS
    Detailed logging about package dbciRSS is saved under /var/tmp/sgesap_validation-dbciRSS-20140403-0927.log
     ** No user_name was defined. Perhaps this was on purpose, maybe not - pls verify    [ WARN ]
     == Directory /oracle/RSS/.ssh does not exist                                        [ WARN ]
     == SSH file /home/rssadm/.ssh/authorized_keys not found                             [ WARN ]
            Log file for dbciRSS is saved as /var/tmp/sgesap_validation-dbciRSS-20140403-0927.log
    

While we are discussing the monitoring process we can introduce the `sgesap_validation_wrapper.sh` script, which as the name applies is a wrapper script around the `sgesap_validation.sh` script. It takes the output from `cmviewcl` and will inspect all running packages (with `-m` option) and will mail in HTML format the output to the destination defined in the script (variable `ToUser`). Run it without arguments as following:

    #-> sgesap_validation_wrapper.sh
    ###############################################################################################
                   Script: sgesap_validation_wrapper.sh
                    Arguments: (empty)
                  Purpose: Wrapper script (and monitoring) around sgesap_validation.sh
               OS Release: 11.31
                    Model: ia64
                     Host: gtsdbd02
                     User: root
                     Date: 2014-04-03 @ 09:33:36
                      Log: /var/adm/log/package-validation-monitoring-results.log
    ###############################################################################################
    03-04-2014 09:33:36 Cluster GTSCDVL01 is up (nodes are gtsdbd01 gtsdbd02)
    03-04-2014 09:33:37 Inspecting package dbciRDS
    Detailed logging about package dbciRDS is saved under /var/tmp/sgesap_validation-dbciRDS-20140403-0933.log
     ** No user_name was defined. Perhaps this was on purpose, maybe not - pls verify    [ WARN ]
     == Directory /oracle/RDS/.ssh does not exist                                        [ WARN ]
            Log file for dbciRDS is saved as /var/tmp/sgesap_validation-dbciRDS-20140403-0933.log
    03-04-2014 09:33:52 dbciRDS returned the error code 0
    
    ....
    
    03-04-2014 09:36:42 No errors were found (rc=0)
    
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    03-04-2014 09:36:42 A copy of this logfile is saved as /var/tmp/sgesap_validation_wrapper-20140403-0933.log
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
And you will find a nice formatted (and in color) mail in your mailbox. Just try it out.

If you encounter issues with these two scripts you may always [open a tracker](https://github.com/gdha/sgesap_validation/issues)

