---
layout: single
title: 'Getting started with the Janus supercomputer'
date: 2016-08-01
authors: [Matt Oakley, Max Joseph]
category: [tutorials]
excerpt: 'This tutorial explains how members of Earth Lab can gain access to Janus, the supercomputer at the University of Colorado Boulder. It also outlines the process for submitting jobs and navigating the command line.'
sidebar:
  nav:
author_profile: false
comments: true
lang: 
lib:
---

## Background

What is a supercomputer and why is it necessary?
A supercomputer is defined as a computer with a high-level computational capacity much greater in comparison to a general-purpose computer, hence the ‘super’ prefix.General-purpose computers can typically compute anywhere between 1-10 billion floating-point operations per second (FLOPS) whereas supercomputers can compute trillions or even quadrillions of FLOPS.
In layman’s terms, this means that programs can run much quicker on a supercomputer due to the greater amount of FLOPS it can compute, this is especially useful for computation-heavy programs which may take hours or even days to run.

EarthLab has access to CU Boulder’s Research Computing supercomputer, Janus.
The Janus supercomputer is comprised of 1,368 compute nodes, each containing 12 cores, for a total of 16,416 available cores and can achieve 184 trillion FLOPS.
As a member of EarthLab, you can run jobs and store files on Janus.
This document will walk you through the process of getting started on Janus.

## Authentication

Janus is not open to the general public.
Users require authentication to log in.
This is accomplished by setting up an account with CU Boulder's Research Computing (RC) group and downloading/installing a mobile phone application for authentication called Duo.

### Getting a Research Computing (RC) Account

1) Open up a web browser and head to the [RC Account Creation Page](https://portals.rc.colorado.edu/account/request/)

2) At the bottom of the screen, ensure 'University of Colorado - Boulder' is selected from the dropdown box under 'Select your organization' and press 'Continue'

3) Provide your CU Boulder identikey username and password

4) Provide your University affiliation, enter 'EarthLab' for Organization/Department you represent, and ensure 'bash' is selected for 'Preferred login shell'

5) Click 'Submit Request'

### Getting a Duo Account

1) Open up a web browser and head to the [Duo Signup Page](https://signup.duo.com/)

2) Provide your first name, last name, CU Boulder email address, mobile phone number, enter 'EarthLab' as Company/Account Name, and select 'Just me' from the final dropdown box

3) Check the Terms/Privacy Policy box and click 'Create My Account'

4) Download the Duo Mobile application on your smartphone

5) Ensure that notifications are enabled for the Duo Mobile application

6) Upon verifying your CU Boulder ID card, RC will then issue an email/text message/phone call to verify and finalize the two-step authentication setup process

## Logging into Janus

Now that you properly have two-step authentication set up, you're ready to log into Janus.

### Windows Users

1) Open a web browser and head to the [Putty Download Page](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html) and click 'putty.exe' under 'For Windows on x86 Intel'

2) Download, install, and open Putty

3) Click 'Session' from the list on the left side of the screen

4) Under 'Host Name (or IP address)' type 'login.rc.colorado.edu'

5) Click 'Data' under 'Connection; from the list on the left side of the screen

6) Under 'Login details' type your identikey username for 'Auto-login username'

7) Click 'Session' from the list again

8) Under 'Saved Sessions' type 'Janus' and press 'Save'

9) Click 'Janus' and press 'Open' on the bottom-right of the screen

10) A new window should open with the title 'login.rc.colorado.edu - PuTTY' and a prompt to enter your password

11) Enter 'duo:password' where password is your identikey password (do not include the single quotation marks) and press 'Enter'

12) You should receive a notification on your smartphone from Duo

13) Open the notifcation/app and press the green 'Approve' button on the bottom of the screen

### Mac/Linux Users

1) Open a terminal on your system

2) Type `ssh -l $your_rc_username login.rc.colorado.edu` and press 'Enter' (don't include the dollar sign)

3) You should now be connected to JANUS and be prompted to enter your password

4) Enter 'duo:password' where password is your identikey password (do not include the single quotation marks) and press 'Enter'

5) You should receive a notification on your smartphone from Duo

6) Open the notification/app and press the green 'Approve' button

## Using Janus

You should now be logged into a 'login node' on Janus.
Because there is no graphical user interface (GUI) all of your interactions with Janus will be via the command line.
The default command line used to communicate with Janus is **bash**, this can be changed if need be.
A tutorial on bash can be found [here](http://cli.learncodethehardway.org/bash_cheat_sheet.pdf).

### Workspaces

When you login to Janus you will automatically be in the login directory (folder) on a login node.
This is indicated by the [username@login ~]$ text on the command line.
It is very important to note that this is **not** the place to store large files, large numbers of files, or run intensive programs.
Janus is comprised of multiple nodes such as computation nodes, high-memory (himem) nodes, visualization (viz) nodes, etc. These nodes are to be used for your needed jobs/processes, **not** the login nodes.
Each user on Janus has a login/home directory that is limited to 2GB to prevent the use of the home directory as a target for job output.
Every time you login to Janus, a small file is created in order to ensure your login.
If you use up the 2GB with data this file will not be created and you won't be able to login!

Therefore it's important to direct any job output or store files in your personal projects directory and to use different nodes when submitting/running jobs.
Each user has access to 256GB in this projects directory, **much** more room than the login directory.
You can change into your projects directory with the `cd` command:

```sh
cd /projects/username
# 'username' is your identikey username
# e.g., cd /projects/bartsimpson
```

As previously stated, this is the location where you should direct any job output or store files.

### Modules

While using nodes on Janus, users can load modules to help run programs.
Below are a list of commands that you can enter in order to view, import, or get rid of modules while using Janus.

```sh
ml                        #View modules you currently have loaded in your session
ml avail                  #View all available modules currently on JANUS
ml intel                  #Load the intel compiler, use 'ml gcc' for the gcc compiler
ml python                 #Load the python module
ml EARTHLAB_PYTHON_PKGS   #Load all of the python packages necessary for EarthLab
ml unload module_name     #Unload the module called 'module_name'
ml purge                  #Unload all currently loaded modules
```

While you can load any of the modules listed after the 'ml avail' command, the following commands may be sufficient for the majority of EarthLab jobs that are Python based:

```sh
ml intel
ml python
ml EARTHLAB_PYTHON_PKGS
```

### Submitting Jobs on Janus

Janus uses a queueing system called [Slurm](http://slurm.schedmd.com/) to manage resources and schedule jobs.
You should always use Slurm commands to submit jobs and to monitor job progress during execution.
This will allow you to submit and run jobs on nodes that are not the login node.
First, you'll need to load the slurm module.

```sh
ml slurm
```

___Batch Jobs___

Slurm is primarily a resource manager for batch jobs: a user writes a job script that slurm shcedules to run non-interactively when resources are available.
Submissions of computational jobs to the slurm queue are done via the *sbatch* command.

```sh
sbatch job_script.sh
```

You can provide additional arguments to Janus such as the amount of nodes, memory, tasks, and/or time to be used for your specific job.
These can be included as command line arguments (shown below), or embedded within the file you wish to run ([examples here](https://www.rc.colorado.edu/support/user-guide/batch-queueing.html)).

```sh
sbatch --ntasks 16 job_script.sh
```

You should only be using these additional command line arguments if you have a good understanding of the amount of resources necessary to run your job.
Overestimating the amount of time or resources allocated to your job will be taking away time and resources from other jobs that are scheduled.
It is a good idea to run small test jobs before submitting large jobs.

An example of a sample batch script can be found [here](https://github.com/ResearchComputing/Final_Tutorials/blob/master/How_Use_Supercomputer/slurmSub.sh)

___Monitoring Job Progress___

The *squeue* command can be used to inspect the current Slurm job queue and a job's progress through it.

```sh
squeue --user=$USER               #List all of your current jobs on the queue
squeue --user=$USER --start       #Provide an estimate on when your jobs will start/what resources are expected
scontrol show job $SLURM_JOB_ID    #More detailed information about a specific job on the queue
```

Additional information regarding submitting jobs to Janus such as job arrays, accounts, job mail, and memory limits can be found [here](https://www.rc.colorado.edu/support/user-guide/batch-queueing.html)

### Running a Test Job

1) *cd* into your projects directory and make a new sub-directory called 'test_job'

```sh
cd /projects/username
mkdir test_job
cd test_job
```

2) Write the test_job script

```sh
cat - >test_job.sh << EOF
#!/bin/bash
#SBATCH --job-name test_job
#SBATCH --time 05:00
#SBATCH --nodes 1
#SBATCH --qos janus 
#SBATCH --output test_job.out

echo "The job has begun"
echo "Wait one minute..."
sleep 60
echo "Wait a second minute..."
sleep 60
echo "Wait a third minute..."
sleep 60
echo "Enough waiting: job completed."
EOF
```

3) Load slurm and submit the job

```sh
ml slurm
sbatch --qos janus-debug test_job.sh
```

4) Monitor the job execution

```sh
squeue --user $USER
# Information regarding your job will be printed
squeue --user $USER --start
# Print the estimated start time for the job
tail -F test_job.out
# Print out the output of the job that we submitted
```

Congratulations!
You just submitted your first job on the Janus supercomputer.
Please adhere to the guidelines listed in this document for further usage of Janus.
