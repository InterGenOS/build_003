![alt text](https://github.com/InterGenOS/build_001/blob/master/InterGenOS-2015-02-21-400x226.png "InterGen OSsD")


#**The InterGenOS Project**
---


### Project Status and notes:
---
  Custom Grub Splash (Screenshot from Virtualbox build)
  
  
  ![alt text](https://intergenstudios.com/Downloads/Grub_Splash.png "InterGen OSsD")
  

```
  **6/30/15** Grub hack has been replaced with a custom grub configuration :)
  Core system scripts have been cleaned up, and will be ready for 'release' once
  a kernel configuration has been settled on (trying to squeeze every ounce of
  compatibility out of the kernel that we possibly we can).  More to come...

  **6/27/15** Exciting times folks, things are getting good.  Automation is now set to
  let you pick a build partition, enter your username, and hit 'go'.  Build times are
  lengthy, averaging 5-6 hours depending on the system hardware. The 'Grub2 Hack' will
  be going away very shortly- as soon as the grub config script makes it through the
  testing phase on several multi-disk, multi-os setups (nifty IntergenOS background and
  all).  X11 scripts are being put together, and we've opted to make nvidia non-free
  available for the core as well.  DE scripts will follow suit, along with developing
  fakeroot scripts for package creation.  Github currently has our repo, but a dedicated
  server running Scientific is in the works to snag that job shortly.  It's been a long
  road to this point, and there's still loads more to do-  ...stay tuned.

  **6/25/15** Build 003 is now completely automated - Builds are running on 2 separate
  i3 machines and an older Core2duo.  The grub configuration routine (more of a 'hack'
  really) needs to be completely re-worked, but will do for now.  After any identified
  automation bugs have been worked out, x11 will be added, followed by both Gnome and
  KDE- past that, the real fun begins...   :)   ...stay tuned.

  ** 4/16/2015 **
  Scripts are building the entire core system now with 0 errors
  Scripts are being started for base system components (xorg, kde, gnome, etc)
  Huge thanks are in order- Security aspects will be assessed by recent
  OSCP grad and pen testing specialist Mr. Tyler Ward.

  ** 4/9/2015 **
  Testing results for Glibc and GCC packages
  Glibc compiled with 0 failures, 3 unexpected successes
  GCC compiled with 0 failures, 2 unexpected successes

  ** RESPONSE FROM LFS-SUPPORT - 3/12/15 **
    [10:05] <archetech_> if the linker tests pass move on
    [10:07] <archetech_> stuff will blow out later if it's a bad build

    I so love these guys :)

  ** updated kernel to 3.19, and now glibc-2.21 is compiling with ZERO errors. **
  ** On to the rest of the basic system packages.  :) **

  **3/11/15** Build 002 is seeing 'make check' issues with glibc-2.21.  113 identical
  errors are being reported with each run, whether it's done using setup.sh to set
  the temp system or done manually.  #lfs-support hasn't responded yet, but will
  post when they do

    sample 'make check' output log:
      ====>  http://intergenstudios.com/Downloads/glibc-2.21_make-check_log.txt

```

###After their initial look at the project, followed by their 'Oh, cool!', and 'Sweet!' comments, everyone keeps asking me-


"Why make your own distro, though?  That seems like too much work. Why don't you just
use **(insert distro title here)** and then just add **(insert package name here)**?"


*To me the answer is pretty simple:*


"There isn't a single distro that does exactly what I want it to right out of the box."
-------------------------------------------------------------------------------------




Defining "what I want a distro to do right out of the box" ties directly into the
primary goal of the project, and gives any observer an idea of the scope involved:


==========================================================================================
------------------------------------------------------------------------------------------
The InterGenOS Goal:
--
     To develop a Linux Distribution that incorporates all current (as of 2015) major
     Linux Desktop Environments into its core installation, simplifies seemingly odd
     file and package installation locations, and maintainins an 'Arch Linux'-like
     "ease of use" along with excellent package management.

==========================================================================================
------------------------------------------------------------------------------------------

Some more of the basic Q&A's that have come up regarding the project:
(Makes for an entertaining read at some points)


###Q. Isn't this a pretty big, wide-reaching goal?

A. Absolutely.


###Q. Is someone paying for this project?

A. Not at all.


###Q. So if you're not getting paid, why are you doing this?

A. Lot's of reasons:



  **1. Low cost**  Monetarily it costs me nothing, but I do lose some of my free time
                   (or my wife's free time- depending on who you're asking)


  **2. Learning**  The amount of information I've learned about Linux since the project's
                   inception is staggering


  **3. Fun**  Yes, this is fun, enjoyable, and relaxing to me  


  **4. Contributing**  I've gotten alot of enjoyment out of the free software I've used
                       until this point- I'd like to work towards giving something back



###Q. You're seriously not making a dime off this?

A. Unless RedHat decides to hire me, then nope, not a **penny**


###Q. Are you retarded?

A. Maybe. But I bet this *retard* knows alot more about **Linux** than you do.  **:)**


###Q. Is anyone helping you with the project?

A. Yes, but we always welcome new help


###Q. How are you building this OS?

A. I started using the LFS Project to build the initial systems I used as a proof of
   concept (to myself, really). Now that we know building a working Linux System from
   source isn't an 'Unnaturally God-like mythical creation process', it's been alot
   of fun to start planning how we want to develop a new distribution.


###Q. Will it be done soon?

A. Probably not.  We're still working out fun stuff- like what files and directories
   should go where and for what, and how that's going to tie into our package management,
   etc.  Reallistically, you may see something within the next 12 to 16 months- unless
   more people hop on board and help out.


###Q. What package manager are you using?

A. The package manager's name is Linpack (from... Linux Package... seemed simple enough).
   It's similar to pacman, so anyone who's familiar with Arch will have an easy time
   adjusting to it.  It's also a bit simpler to use, so anyone who's not familiar with
   Arch will have an easy time adjusting to it, too.  **:)**


*more to come, stay tuned...*
