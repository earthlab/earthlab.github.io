---
layout: single
title: 'Getting started with the PetaLibrary'
date: 2016-08-01
authors: [Matt Oakley, Max Joseph]
category: [tutorials]
excerpt: 'This tutorial explains how members of Earth Lab can gain access to the PetaLibrary at the University of Colorado Boulder. It also outlines the process for setting up Globus to transfer files between endpoints (e.g., your local machine and the PetaLibrary).'
sidebar:
  nav:
author_profile: false
comments: true
lang: 
lib:
---

The [PetaLibrary](https://www.rc.colorado.edu/resources/storage/petalibrary) is a Research Computing resource that allows researchers affiliated with the University of Colorado to store large amounts of data.
This tutorial covers access and use of the PetaLibrary for Earth Lab members.

## Authentication

The PetaLibrary is only available to certain CU researchers who pay the required fees.
Earth Lab provides access to the PetaLibrary, but use requires authentication.
In this case, Earth Lab members will use an RC account with Duo authentication.

### Getting a Research Computing (RC) Account

1) Open up a web browser and head to the [RC Account Creation Page](https://portals.rc.colorado.edu/account/request/)

2) At the bottom of the screen, ensure 'University of Colorado - Boulder' is selected from the dropdown box under 'Select your organization' and press 'Continue'

3) Provide your CU Boulder Identikey username and password

4) Provide your University affiliation, enter 'EarthLab' for Organization/Department you represent, and ensure 'bash' is selected for 'Preferred login shell'

5) Click 'Submit Request'

### Getting a Duo Account

1) Open up a web browser and head to the [Duo Signup Page](https://signup.duo.com/)

2) Provide your first name, last name, CU Boulder email address, mobile phone number, enter 'EarthLab' as Company/Account Name, and select 'Just me' from the final dropdown box

3) Check the Terms/Privacy Policy box and click 'Create My Account'

4) Download the Duo Mobile application on your smartphone

5) Ensure that notifications are enabled for the Duo Mobile application

6) Upon verifying your CU Boulder ID card, RC will then issue an email/text message/phone call to verify and finalize the two-step authentication setup process

## Accessing the PetaLibrary

There are several different methods for accessing the PetaLibrary, outlined below.

### RC Environment

If you have an account with research computing and have access to the PetaLibrary, you should have PetaLibrary directories available in your research computing environment.
Information on how to access an RC environment through Janus login nodes can be found [here](https://github.com/earthlab/tutorials/blob/2acec457c3af7001bea474a5f0c6a03fc9b88b2c/documentation/Getting_Started_with_JANUS.md). <!-- TODO: keep this URL updated -->
The PetaLibrary contains the following directories:

- `/work/` for active storage
- `/repl/` for active storage with replication
- `/archive/` for archive storage

#### Active Storage

Active storage (`/work/`) is accessible for read and write directly through any RC environment.
This includes both the login and compute nodes.
This is the directory you will want to be using to read and write data while you are working on a project.

#### Active Storage with Replication

Active storage with replication (`/repl/`) is available for read only purposes from the login nodes.
This directory contains copies of your data as a means to backup files that may be inadvertently deleted.

#### Archive Storage

Archive storage (`/archive/`) is available for read and write purposes from login nodes only.
This is meant to be used to transfer data from other storage spaces, and should not be used extensively during a project.

### External Access

#### Globus

Globus is a tool for high performance data transfer.
GlobusOnline provides an easy-to-use web application for accessing Globus tools.
To get started with GlobusOnline, select the login option at the top of the homepage ([www.globus.org/](https://www.globus.org/)).
Next, select The University of Colorado at Boulder as your organization from the dropdown menu.
When you click continue you will be taken to a sign in page where you can use your CU Identikey username and password.
Once you have logged in you can associate your Identikey with your Globus account.
You will only need to do this the first time you login.

After this is done, you will want to use the Transfer Files tool and click 'Start by selecting an endpoint'.
From here, go to the My Endpoints tab and select 'add Globus Connect Personal'.
This should allow you to select the computer you are working on as one endpoint.

For the second endpoint you will want to use 'colorado#gridftp'.
This will require you to sign in with your RC account credentials.
Use `<identikey>`@duo as the username and enter your password (substituting your Identikey name).
This should send a Duo authentication notice to your phone, assuming you have properly set up your duo account.
Once this is done your RC computing environment should be set as your second endpoint.
Now you can easily transfer files to and from your computer and the PetaLibrary, as well as any other RC storage space, using the simple interface.

Globus also has a command-line interface that allows you to manage data transfer without using the web app.
Information on how to configure and use the Globus command-line interface can be found [here](https://docs.globus.org/cli/using-the-cli/).

#### SSH

SSH methods are much less efficient than Globus, but you may find them to be more convenient for moving only a few files.

##### Windows Users

Windows users should go to the [PuTTY](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html) site, and download pscp.exe.
This is a command line interface, and it does not install itself, so you will need to place the file in a desired directory.
Next, add that directory to your path variable.
More information on setting your path in windows can be found [here](http://www.computerhope.com/issues/ch000549.htm).
Once the path has been properly set you will be able to use the `pscp` command to transfer files.
Details on using this command will be given in the next section, just be sure to replace `scp` with `pscp`.
This is the only difference, otherwise the command works exactly the same as OS X and Linux users.

##### Mac/Linux Users

At the command line, navigate to the directory containing the files you would like to transfer.
Once in the directory you should be able to use the command

```
scp file_name <identikey>@login.rc.colorado.edu:/path/to/your/directory
```

You will then be asked for a password.
Enter 'duo:password' and a Duo authentication notification will be sent to your phone.
Accept the notification, and the file(s) will be transferred to your RC environment.
[Wildcards](http://www.linfo.org/wildcard.html) can be used to replace the `file_name` argument with `*.type` where type is some file extension for a specific type of file you would like to transfer.
This will transfer all files of that type in the current directory, instead of transferring files one at a time.
E.g., to transfer all files with a .txt extension:

```
scp *.txt <identikey>@login.rc.colorado.edu:/path/to/your/directory
```

More information on access via SSH can be found [here](https://www.rc.colorado.edu/resources/storage/petalibrary/accessinstructions).
