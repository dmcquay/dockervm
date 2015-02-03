#DockerVM

An alternative to boot2docker that uses rsync instead of VirtualBox Shared Folders.

#Why?

This project is a simple stopgap for the issue described here:
https://github.com/boot2docker/boot2docker/issues/64

It looks like progress was made here:
https://github.com/boot2docker/boot2docker-cli/pull/247/files

But may have been abandoned because the boot2docker project has been deprecated in favor of Docker Machine. As far as I can tell, they are not addressing this issue in Docker Machine. At least not yet.

I hope that my stop gap solution is only temporary and something better is built. 

If you don't want to read all those links, the problem is that VirtualBox synced folders are slow. If you are using docker in a development workflow and you need to be able to edit your files on the hose
(your laptop) and have docker immediately pick up the changes, then you will need to rely on those shared folders. If your project has many thousands of files, that is problematic because VB synced folder
s are so slow.

The best solution I have found is to use rsync to keep the files in sync. According to [this blog post](http://mitchellh.com/comparing-filesystem-performance-in-virtual-machines), NFS is the answer. I tried it and did not get the performance I was hoping for from NFS. So I opted for rsync instead so I can use VirtualBox native storage instead. If you want to use NFS, just edit the Vagrantfile and change "rsync" to "nfs".

I have also installed fig on this vm since it is nice to have for dev workflows, which is the purpose of this vm.

#Directions

 - Install vagrant
 - Download this project to your laptop somewhere
 - Create a file called *syncdirs* in the dockervm directory and add any paths that you want synced (one per line)
 - `vagrant up` to create the vm
 - `vagrant rsync-auto` to watch your synced folders for changes and automatically sync them into the VM (one way only)
 - Then ssh into the box with `vagrant ssh` and run your docker commands from in there. Your synced folders will be in `/data`

Nothing fancy going on here, but gets the job done.
