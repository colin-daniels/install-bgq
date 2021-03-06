bgclang installation
====================

This is a collection of scripts to automate the installation of bgclang nightly
builds. The main website for bgclang is

https://trac.alcf.anl.gov/projects/llvm-bgq

while the nightly builds can be found here:

http://www.mcs.anl.gov/~hfinkel/bgclang/


Preparations
------------

Edit `config` to set all configuration variables for your local system.
Typically, you only need to modify the following variables:
* RPMDIR
* RPMDBPATH
* PREFIX\_BASE
* GCC472\_PATH

If performing installation over SSH, these additional variables need to be modified:
* REMOTE\_RPMDIR
* SSH\_COMMAND
* REMOTE\_TEMP

If your system additionally uses the Modules package and you wish to generate
a modulefile for your install from a template, the following must also be
modified:
* INSTALL\_MODULEFILE
* MODULEFILE\_DIR

Getting bgclang
---------------

Find out current nightly bgclang version:
* manually:
  * Go to `http://www.mcs.anl.gov/~hfinkel/bgclang/`.
  * Note the full version as `r<revision>-<YYYYMMDD>`
    (from now on referred to as `<version>`).
* automatically:
  * Run `./version.sh` and note output.

Run `./download.sh <version>` to download all RPMs.


Installing bgclang
------------------

Run `./install.sh <version>`.

Optional: if you need change the location of the GCC 4.7.2 toolchain files, you
need to run `./modify_path_472.sh <version>` after the installation.

Remote install
--------------

If your system does not allow outgoing connections and you would like to
install over SSH, first:
* Download files locally using `./download.sh <version>`.
* Ensure remote-install related options are set correctly in `config`.

Run `./remote-install.sh <version>`.

Cron job
--------

You can automate the installation of the nightly builds by calling `cron.sh`
through a cron job. It will fetch the current nightly version from the bgclang
nightly builds website (see above), check if it needs to be installed, download
all packages and install it. Additionally, it will create a `nightly` symbolic
link that points to the new version. By default, the previous nightly version is
removed after a sucessful installation of the new build, but this can be
disabled in the `config` file.


Contribute
----------

The bgclang install scripts are currenly maintained by:

Michael Schlottke (<m.schlottke@fz-juelich.de>)

Feel free to send patches/pull requests to fix broken features or to improve the
overall usability.
