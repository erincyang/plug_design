This executable requires cloning both the worms (https://github.com/willsheffler/worms.git) and rpxdock (https://github.com/willsheffler/rpxdock.git) repositories and their respective python environments. 

The first step of this process fuses monomeric helical repeat proteins to the pH-responsive trimeric scaffold using the 01_fuse/fuse.sh script.

The second step is to dock all of the fusions into the context structure (or nanoparticle) using the 02_dock/dock.sh script. Note here that the nanoparticle scaffold has been reduced down to it's asymmetric unit, with the oligomeric symmetry axis aligned to the Z axis. 

After docking, use your favorite design methodologies to optimize the sequence of the resulting fusion and docked interface. ProteinMPNN is now recommended for a system like this. Included are the PyRosetta and Rosetta Design scripts used to design the fusion and interface of O432-17. 

