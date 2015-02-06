# DockerVM

An alternative to boot2docker that uses rsync instead of VirtualBox Shared Folders.

## Why?

 - boot2docker uses VirtualBox Shared Folders which are crazy slow. This VM uses rsync instead.
 - Bonus: orphaned docker volumes and images are automatically cleaned up via an hourly cron job

## Downsides

 - Doesn't allow you to use docker remotely yet. Have to ssh into the box to do your docker commands.
 - You have to run `vagrant rsync-auto`.
 - You have to specify which folders you want synced.
 - This is just a stop-gap project. Probably at some point docker machine, boot2docker or some other project will solve this better.

# How To Install and Use

 - Install vagrant
 - Download this project to your laptop somewhere
 - Create a file called *syncdirs* in the dockervm directory and add any paths that you want synced (one per line)
 - `vagrant up` to create the vm
 - `vagrant rsync-auto` to watch your synced folders for changes and automatically sync them into the VM (one way only)
 - Then ssh into the box with `vagrant ssh` and run your docker commands from in there. Your synced folders will be in `/data`
 - I did not set up any port forwarding. Instead I have given the box a host-only private network with IP address 192.168.59.104. That way you can access any port you need via that IP. I usually map that in /etc/hosts to something like "docker" for convenience.

# More Details on why rsync is needed instead of VBox Shared Folders

This project is a simple stopgap for the issue [described here](https://github.com/boot2docker/boot2docker/issues/64). It looks like progress was made [here](https://github.com/boot2docker/boot2docker-cli/pull/247/files), but may have been abandoned because the boot2docker project has been deprecated in favor of Docker Machine. As far as I can tell, they are not addressing this issue in Docker Machine. At least not yet.

If you don't want to read all those links, the problem is that VirtualBox synced folders are slow. If you are using docker in a development workflow and you need to be able to edit your files on the host (your laptop) and have docker containers immediately pick up the changes via mapped volumes, then you will need to rely on those shared folders. If your project has many thousands of files, that is problematic because VB synced folders are so slow.

My stop gap is to use rsync instead. This is not intended to be a long term fix. Just a simple interim solution.

According to [this blog post](http://mitchellh.com/comparing-filesystem-performance-in-virtual-machines), NFS is the answer. I tried it and did not get the performance I was hoping for from NFS. So I opted for rsync instead, allowing me to use VirtualBox native storage. If you prefer NFS, just edit the Vagrantfile and change "rsync" to "nfs".

I have also installed fig on this vm since it is nice to have for dev workflows.

# Other included software

 - mysql client
 - fig
 - docker-volumes
