# irods-icommands
Docker implementation of iRODS iCommands

## Supported tags and respective Dockerfile links

- 4.2.0, latest ([4.2.0/Dockerfile](https://github.com/mjstealey/irods-icommands/blob/master/4.2.0/Dockerfile))

### Pull image from dockerhub

```bash
docker pull mjstealey/irods-icommands:latest
```

### Usage:

In this example we've previously launched a daemonized instance of [irods-provider-postgres:latest](https://github.com/mjstealey/irods-provider-postgres) and have specified that both it's docker name and hostname are provider at 172.17.0.2.

Use an environment file to pass the required environment variables for an iinit call

```bash
$ docker run --rm --env-file sample-env-file.env mjstealey/irods-icommands:latest ICOMMAND_TO_PERFORM
```
- Sample environment file `sample-env-file.env` (Update as required for your iRODS installation)

  ```bash
  IRODS_HOST=172.17.0.2
  IRODS_PORT=1247
  IRODS_USER_NAME=rods
  IRODS_ZONE_NAME=tempZone
  IRODS_PASSWORD=rods
  IRODS_DEFAULT_RESOURCE=demoResc
  WORKER_UID=
  WORKER_GID=
  ```
**About UID/GID:** The docker container will operate as the **root** user if the `WORKER_UID` and `WORKER_GID` variables are left blank. If these variables are defined, the container will operate a **worker** user with the specified UID and GID. If only one varialbe is set the container will operate as a **worker** user and default the unset UID or GID to a value of 999. This is useful when operating on a system where read/write permissions of a shared volume on the host need to be respected.

- Example: ipwd

    ```
	$ docker run --rm --env-file sample-env-file.env mjstealey/irods-icommands:latest ipwd
	/tempZone/home/rods
	```

Pass environment variables indivdually

```
$ docker run --rm \
	-e IRODS_HOST=172.17.0.2 \
	-e IRODS_PORT=1247 \
	-e IRODS_USER_NAME=rods \
	-e IRODS_ZONE_NAME=tempZone \
	-e IRODS_PASSWORD=rods \
	-e IRODS_DEFAULT_RESOURCE=demoResc \
	mjstealey/irods-icommands:latest ICOMMAND_TO_PERFORM
```

- Example: ils

	```
	$ docker run --rm -e IRODS_HOST=172.17.0.2 -e IRODS_PORT=1247 -e IRODS_USER_NAME=rods -e IRODS_ZONE_NAME=tempZone -e IRODS_PASSWORD=rods -e IRODS_DEFAULT_RESOURCE=demoResc mjstealey/irods-icommands:latest ils
	/tempZone/home/rods:
	```

Include a mounted volume for iput or iget calls. Say you have files to iput at `/LOCALPATH`, you would bind this volume to the containers `/workspace` as follows:

```bash
docker run --rm -v /LOCALPATH:/workspace \
  -e IRODS_HOST=localhost \
  -e IRODS_PORT=1247 \
  -e IRODS_USER_NAME=irods \
  -e IRODS_ZONE_NAME=tempZone
  -e IRODS_PASSWORD=irods \
  -e WORKER_UID=1000 \
  -e WORKER_GID=1000 \
  mjstealey/irods-icommands:latest {iput|iget} {file/directory|resource/collection}
```

An empty call generates the `ihelp` message

```
$ docker run --rm --env-file sample-env-file.env mjstealey/irods-icommands:latest
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

iRODS Version 4.2.0                ihelp
```
