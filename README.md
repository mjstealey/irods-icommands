# irods-icommands

iRODS iCommands in Docker

- v4.2.2 - Debian:stretch based (16.04 Xenial iRODS packages)
- v4.2.1 - Debian:jessie based (14.04 Trusty iRODS packages)
- v4.2.0 - Debian:jessie based (14.04 Trusty iRODS packages)

**Note**: iRODS icommands require a pre-existing iRODS server to connect to as the icommands image does not provide any iRODS services of it's own. Most examples provided herein additionally make use of the [irods-provider-postgres](https://github.com/mjstealey/irods-provider-postgres) docker image running in a docker network named `irods_nw`.

```
$ docker network create \
	--driver bridge \
	irods_nw
$ docker run -d --name=provider \
	--network=irods_nw \
	--hostname=provider \
	mjstealey/irods-provider-postgres:4.2.2 \
	-i run_irods
``` 

## Supported tags and respective Dockerfile links

- 4.2.2, latest ([4.2.2/Dockerfile](https://github.com/mjstealey/irods-icommands/blob/master/4.2.2/Dockerfile))
- 4.2.1 ([4.2.1/Dockerfile](https://github.com/mjstealey/irods-icommands/blob/master/4.2.1/Dockerfile))
- 4.2.0 ([4.2.0/Dockerfile](https://github.com/mjstealey/irods-icommands/blob/master/4.2.0/Dockerfile))

### Pull image from dockerhub

```bash
$ docker pull mjstealey/irods-icommands:latest
```

### Build locally

```bash
$ cd irods-icommands/4.2.2
$ docker build -t icommands-4.2.2 .
```

## Usage:

An entry point script named `docker-entrypoint.sh` that is internal to the container will have the provided arguments passed to it.

Default argument is:

- `ihelp`: show brief help

```
$ docker run --rm \
	--network=irods_nw \
	mjstealey/irods-icommands:latest
The iCommands and a brief description of each:

iadmin       - perform iRODS administrator operations (iRODS admins only).
ibun         - upload/download structured (tar) files.
icd          - change the current working directory (Collection).
ichksum      - checksum one or more Data Objects or Collections.
ichmod       - change access permissions to Collections or Data Objects.
icp          - copy a data-object (file) or Collection (directory) to another.
ienv         - display current iRODS environment.
ierror       - convert an iRODS error code to text.
iexecmd      - remotely execute special commands.
iexit        - exit an iRODS session (opposite of iinit).
ifsck        - check if local files/directories are consistent with the associated Data Objects/Collections in iRODS.
iget         - get a file from iRODS.
igroupadmin  - perform group-admin functions: mkuser, add/remove from group, etc.
ihelp        - display a synopsis list of the iCommands.
iinit        - initialize a session, so you don't need to retype your password.
ils          - list Collections (directories) and Data Objects (files).
ilsresc      - list iRODS resources.
imcoll       - manage mounted collections and associated cache.
imeta        - add/remove/copy/list/query user-defined metadata.
imiscsvrinfo - retrieve basic server information.
imkdir       - make an iRODS directory (Collection).
imv          - move/rename an iRODS Data Object (file) or Collection (directory).
ipasswd      - change your iRODS password.
iphybun      - DEPRECATED - physically bundle files (admin only).
iphymv       - physically move a Data Object to another storage Resource.
ips          - display iRODS agent (server) connection information.
iput         - put (store) a file into iRODS.
ipwd         - print the current working directory (Collection) name.
iqdel        - remove a delayed rule (owned by you) from the queue.
iqmod        - modify certain values in existing delayed rules (owned by you).
iqstat       - show the queue status of delayed rules.
iquest       - issue a question (query on system/user-defined metadata).
iquota       - show information on iRODS quotas (if any).
ireg         - register a file or directory/files/subdirectories into iRODS.
irepl        - replicate a file in iRODS to another storage resource.
irm          - remove one or more Data Objects or Collections.
irmdir       - removes an empty Collection
irmtrash     - remove Data Objects from the trash bin.
irsync       - synchronize Collections between a local/iRODS or iRODS/iRODS.
irule        - submit a rule to be executed by the iRODS server.
iscan        - check if local file or directory is registered in iRODS.
isysmeta     - show or modify system metadata.
iticket      - create, delete, modify & list tickets (alternative access strings).
itrim        - trim down the number of replicas of Data Objects.
iuserinfo    - show information about your iRODS user account.
ixmsg        - send/receive iRODS xMessage System messages.
izonereport  - generates a full diagnostic/backup report of your Zone.

For more information on a particular iCommand:
 '<iCommand> -h'
or
 'ihelp <iCommand>'

iRODS Version 4.2.2                ihelp
```

### Environment variables

**Note**: We have previously launched a daemonized instance of [irods-provider-postgres:latest](https://github.com/mjstealey/irods-provider-postgres) and have specified the container name as `provider` on the `irods_nw` network as described above.

The default environment variables of the icommands container are set to talk to the default configuration of the provider container.

```
# default iRODS env
ENV IRODS_PORT=1247
ENV IRODS_PORT_RANGE_BEGIN=20000
ENV IRODS_PORT_RANGE_END=20199
ENV IRODS_CONTROL_PLANE_PORT=1248
# iinit parameters
ENV IRODS_HOST=provider
ENV IRODS_USER_NAME=rods
ENV IRODS_ZONE_NAME=tempZone
ENV IRODS_PASSWORD=rods
ENV IRODS_DEFAULT_RESOURCE=demoResc
# UID / GID settings
ENV UID_IRODS=998
ENV GID_IRODS=998
```

The user can override any envronment varaible by passing in an environment file to the container on start up. A file named `sample-icommands.env` has been provided as an example of this.

- File: `sample-icommands.env`

	```
	IRODS_PORT=1247
	IRODS_PORT_RANGE_BEGIN=20000
	IRODS_PORT_RANGE_END=20199
	IRODS_CONTROL_PLANE_PORT=1248
	IRODS_HOST=provider
	IRODS_USER_NAME=rods
	IRODS_ZONE_NAME=tempZone
	IRODS_PASSWORD=rods
	IRODS_DEFAULT_RESOURCE=demoResc
	UID_IRODS=998
	GID_IRODS=998
	```

Using the `sample-icommands.env` file, run the **ils** command:

```
$ docker run --rm \
	--env-file=$(pwd)/sample-icommands.env \
	--network=irods_nw \
	mjstealey/irods-icommands:latest ils
/tempZone/home/rods:
```

**About UID/GID:** The docker container will operate internally as a user named **irods** with a UID:GID = 998:998. If the `UID_IRODS` and/or `GID_IRODS` variables are defined differently by the user, the container will attempt to operate using those values. This is useful when retrieving data and wanting to keep the UID:GID the same as the user defined on the host system

```
$ docker run --rm \
	--network=irods_nw \
	mjstealey/irods-icommands:latest id
uid=998(irods) gid=998(irods) groups=998(irods)

$ docker run --rm \
	-e UID_IRODS=12345 \
	-e GID_IRODS=54321 \
    --network=irods_nw \
    mjstealey/irods-icommands:latest id
uid=12345(irods) gid=54321(irods) groups=54321(irods)
```

### Example iCommands

**iput**

The icommands container has an internal volume named `/local` as its starting point. We want to volume mount the files from the host to be in the scope of the containers `/local` directory.

Example:

- Generate a 10 MB sample file
- `iput` the sample file into the iRODS provider container

```
$ dd if=/dev/zero of=test-file.dat  bs=1M  count=10
10+0 records in
10+0 records out
10485760 bytes (10 MB) copied, 0.0104086 s, 1.0 GB/s

$ docker run --rm \
	-v $(pwd):/local \
	--network=irods_nw \
	mjstealey/irods-icommands:latest iput test-file.dat

$ docker run --rm \
        -v $(pwd):/local \
        --network=irods_nw \
        mjstealey/irods-icommands:latest ils -Lr
/tempZone/home/rods:
  rods              0 demoResc     10485760 2017-11-13.20:57 & test-file.dat
        generic    /var/lib/irods/iRODS/Vault/home/rods/test-file.dat	
```


**iget**

Retrieve the `test-file.dat` file using `iget` into a new host directory name `output`

```
$ mkdir output

$ docker run --rm \
	-v $(pwd)/output:/local \
	--network=irods_nw \
	mjstealey/irods-icommands:latest iget test-file.dat

$ ls -alh output
total 20480
drwxr-xr-x@  3 xxxxx  xxxxx    96B Nov 13 16:00 .
drwxr-xr-x@ 10 xxxxx  xxxxx   320B Nov 13 16:00 ..
-rw-r-----   1 xxxxx  xxxxx    10M Nov 13 16:00 test-file.dat
```

**iadmin**

The example configuration acts as the **rods** administrative user in the provider container and has permissions to perform `iadmin` level commands.

Make users bob (rodsuser) and alice (rodsadmin).

```
$ docker run --rm \
	--network=irods_nw \
	mjstealey/irods-icommands:latest iadmin mkuser bob rodsuser

$ docker run --rm \
	--network=irods_nw \
	mjstealey/irods-icommands:latest iadmin mkuser alice rodsadmin

$ docker run --rm \
	--network=irods_nw \
	mjstealey/irods-icommands:latest iadmin lu
rods#tempZone
bob#tempZone
alice#tempZone

$ docker run --rm \
	--network=irods_nw \
	mjstealey/irods-icommands:latest iadmin lu alice
user_id: 10020
user_name: alice
user_type_name: rodsadmin
zone_name: tempZone
user_info:
r_comment:
create_ts 2017-11-13.21:07:25
modify_ts 2017-11-13.21:07:25
```


