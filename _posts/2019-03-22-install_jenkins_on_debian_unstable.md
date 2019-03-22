---
layout: post
title:  Install Jenkins on Debian Unstable
date:   2019-03-22 07:51:22 -0700
tags:   
---
Install [openjdk-8-jdk](https://packages.debian.org/sid/openjdk-8-jdk).  Jenkins technically [supports Java 8 and Java 11](https://jenkins.io/doc/administration/requirements/java/), however several plugins appear to still have [compatibility issues](https://wiki.jenkins.io/display/JENKINS/Known+Java+11+Compatibility+issues) so Java 8 is sadly your best bet.
```
sudo apt install openjdk-8-jdk
```
Check your [alternatives](https://wiki.debian.org/DebianAlternatives) and make sure Java 8 is the default:
```
rcw@xps:~$ sudo update-alternatives --config java
There are 2 choices for the alternative java (providing /usr/bin/java).

  Selection    Path                                            Priority   Status
------------------------------------------------------------
* 0            /usr/lib/jvm/java-12-openjdk-amd64/bin/java      1211      auto mode
  1            /usr/lib/jvm/java-12-openjdk-amd64/bin/java      1211      manual mode
  2            /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java   1081      manual mode

Press <enter> to keep the current choice[*], or type selection number: 2
update-alternatives: using /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java to provide /usr/bin/java (java) in manual mode
rcw@xps:~$
```
Import the Jenkins repo key:
```
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
```
Add the Jenkins repo to your apt sources:
```
echo deb http://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list
```
Update and install Jenkins:
```
sudo apt update
sudo apt install jenkins
```
Jenkins should now be running:
```
rcw@xps:~$ systemctl status jenkins
● jenkins.service - LSB: Start Jenkins at boot time
   Loaded: loaded (/etc/init.d/jenkins; generated)
   Active: active (exited) since Fri 2019-03-22 08:56:47 PDT; 2min 7s ago
     Docs: man:systemd-sysv-generator(8)
    Tasks: 0 (limit: 4915)
   Memory: 0B
   CGroup: /system.slice/jenkins.service
rcw@xps:~$
```
Go to http://localhost:8080 and follow the on-screen instructions to finish setup.
