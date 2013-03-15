vmware-snapcompare
==================

Background and Original Source
------------------------------
These scripts are derived from the contents of the May 2011 paper "Forensic 
Analysis of VMware Hard Disks" by Manish Hirwani.  The paper was retrieved in 
March, 2013 from 
https://ritdml.rit.edu/bitstream/handle/1850/13818/MHirwaniThesis5-4-2011.pdf, 
and a copy is included in this repository.

The files in the "bash.original" directory reflect the closest functional 
version of the scripts in the PDF. Future feature additions will be made to 
files in "bash.new" directory, and possibly others.

Initial Modifications
---------------------
The originals were modified to function within the SANS SIFT Ubuntu VMware 
distribution.  (See http://computer-forensics.sans.org/community/downloads for 
details and download.)  Modifications between the paper and initial commit 
included:

* Handling special characters in filenames
* Use sleep(1) instead of usleep for better portability
* Move common function and variable definitions to a separate file, sourced as
needed
* Syntax corrections
* Use mmls(1) from TSK insteaf of fdisk(8)
* Paths to binaries to sync with SIFT paths
* Other minor changes to enable functionality within SIFT environment

Usage
-----
1. Mount VMDKs as raw images using affuse from the afflib distribution:

  > `$ affuse /path/to/myfirst.vmdk /mnt/vmdks/myfirst.base/`

  > `$ affuse /path/to/myfirst-000001.vmdk /mnt/vmdks/myfirst.snap1/`

2. Run "menu.sh"

  > `$ cd bash`

  > `$ ./menu.sh`

3. Using menu option 1, select the raw images mounted above:

  > `PATH 1: /mnt/vmdks/myfirst.base/myfirst.vmdk.raw`

  > `PATH 2: /mnt/vmdks/myfirst.snamp1/myfirst-000001.vmdk.raw`

4. Use menu options 3-7 to create analysis files in the "output_files" 
directory. This directory will be created for you, and the scripts will exit if 
their respective output file already exists to prevent accidental overwrites.
  * Note that each menu option currently re-asks for the partition offset. This 
    value should be taken directly from the "Start" value in the displayed 
    partition table.

5. Optionally use menu options 8-9 to view output and/or calculate hash values 
for the raw-mounted VMDK files.

6. Rename/move the "output_files" directory to some source-specific 
name/location, review contents for each analysis run.
