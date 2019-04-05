---
layout: post
title:  Poking at Lacework
date:   2019-04-03 18:27:44 -0700
tags:   
---
Reading the tin, _[Lacework](https://www.lacework.com/) is a SaaS platform that provides automated threat defense, intrusion detection, and compliance for multicloud workloads & containers._


If you're not familiar with it, check out [Lacework's product demo ](https://www.youtube.com/watch?v=EN1u3VLb3mo).

## Clean Slate

Let's start by creating a fresh new AWS account.

![Welcome to AWS Screenshot](/assets/welcometoaws.png)

## Basic Security

Before going any further, we need to do some security housekeeping.  

### Root MFA

First, login to your new root account and [lock it down with MFA](https://www.youtube.com/watch?v=WhnduJWfxU0).

### Administrative IAM

Next, [create an administrative IAM user](https://www.youtube.com/watch?v=y62qoYwxbXU) so you don't have to log into your account root anymore.

### IAM MFA

Next, log in as your new IAM user and [lock it down with MFA](https://www.youtube.com/watch?v=A3AObXBJ4Lw).

### IAM Password Policy

Finally, setup a [IAM password policy](https://www.youtube.com/watch?v=SMOzcZ-dGUI).

### Done....well, started

At this point, your IAM _Security Status_ should show all green:

![Security Status](/assets/awssecuritystatus.png)

## Connect Lacework with AWS

Go to [lacework.com](https://www.lacework.com) and sign up for a free trial.  If you use a Gmail account, you'll have to wait for an SDR to reach out to you.  If you use a "real" work email, it should be automagically approved.

![Lacework Trial](/assets/laceworktrial.png)

Once you have your trial approved, follow along with [Lacework's AWS Setup](https://www.youtube.com/watch?v=0lve8SzzIas).

![Lacework Stack](/assets/laceworkstack.png)

Once the stack is running, create yourself an EC2 instance running Amazon Linux.

![Amazon Linux](/assets/amazonlinux.png)

![t2.micro](/assets/t2micro.png)

Back in the Lacework portal, skip through the Azure and GCP setup to the Install Agents screen.

![Install Agents](/assets/installagents.png)

Download the install script on your instance and at least do a cursory look-over to ensure it looks sane.

```
Warning: Permanently added 'ec2-XXX-XXX-XXX-XXX.us-east-2.compute.amazonaws.com,XXX.XXX.XXX.XXX' (ECDSA) to the list of known hosts.

       __|  __|_  )
       _|  (     /   Amazon Linux 2 AMI
      ___|\___|___|

https://aws.amazon.com/amazon-linux-2/
1 package(s) needed for security, out of 3 available
Run "sudo yum update" to apply all updates.
[ec2-user@ip-XXX-XXX-XXX-XXX ~]$ wget https://xxxxxxxx.lacework.net/mgr/v1/download/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/install.sh
--2019-04-04 18:06:34--  https://xxxxxxxx.lacework.net/mgr/v1/download/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/install.sh
Resolving xxxxxxxx.lacework.net (xxxxxxxx.lacework.net)... 52.43.136.187, 34.212.79.17, 34.212.241.15
Connecting to xxxxxxxx.lacework.net (xxxxxxxx.lacework.net)|52.43.136.187|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: unspecified [application/octet-stream]
Saving to: ‘install.sh’

    [ <=>                                                                                                                                                                      ] 18,338      --.-K/s   in 0.07s   

2019-04-04 18:06:34 (258 KB/s) - ‘install.sh’ saved [18338]

[ec2-user@ip-XXX-XXX-XXX-XXX ~]$
```
After confirming the script, go ahead and run it.
```
sudo ./install.sh
```
Back in the Lacework console, click _Finish Onboarding_, then _Open Application_.  Now go get lunch and come back after some metrics have been collected.

## Actually Poking Around

### Compliance

Looking at Lacework's AWS Compliance Dashboard, we immediately see three Critical items.

![Critical Items](/assets/criticalitems.png)

Drilling into the first one, we see `Root password is used in the last 24 hours`.  This is true since we used it to setup the account.

The second tells us that `Network ACLs have unrestricted inbound traffic` in every region.  This is the default condition, so again not surprising.

The details on the third tell us that `arn:aws:iam::aws:policy/AdministratorAccess` (the AWS-managed policy we used for our IAM admin user) `allows full administrative privileges`, which is again true.

### Events

Let's create a KMS key.  [Video walkthrough](https://www.youtube.com/watch?v=LvCmp3lRu_4).

This event took longer than I expected to show up.  I created the key a little after 15:00 and when I checked Lacework a few minutes after 16:00, it still wasn't there.  When I came back to it at 18:00, the event was finally available.

![Evil Key](/assets/evilkey.png)

Let's download a few flavors of eicar...
```
[ec2-user@ip-XXX-XXX-XXX-XXX ~]$ wget http://2016.eicar.org/download/eicar.com
--2019-04-04 22:41:54--  http://2016.eicar.org/download/eicar.com
Resolving 2016.eicar.org (2016.eicar.org)... 213.211.198.58
Connecting to 2016.eicar.org (2016.eicar.org)|213.211.198.58|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 68 [application/octet-stream]
Saving to: ‘eicar.com’

100%[=========================================================================================================================================================================>] 68          --.-K/s   in 0s      

2019-04-04 22:41:55 (15.4 MB/s) - ‘eicar.com’ saved [68/68]

[ec2-user@ip-XXX-XXX-XXX-XXX ~]$ wget http://2016.eicar.org/download/eicar.com.txt
--2019-04-04 22:42:02--  http://2016.eicar.org/download/eicar.com.txt
Resolving 2016.eicar.org (2016.eicar.org)... 213.211.198.58
Connecting to 2016.eicar.org (2016.eicar.org)|213.211.198.58|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 68 [application/octet-stream]
Saving to: ‘eicar.com.txt’

100%[=========================================================================================================================================================================>] 68          --.-K/s   in 0s      

2019-04-04 22:42:02 (14.9 MB/s) - ‘eicar.com.txt’ saved [68/68]

[ec2-user@ip-XXX-XXX-XXX-XXX ~]$ wget http://2016.eicar.org/download/eicar_com.zip
--2019-04-04 22:42:08--  http://2016.eicar.org/download/eicar_com.zip
Resolving 2016.eicar.org (2016.eicar.org)... 213.211.198.58
Connecting to 2016.eicar.org (2016.eicar.org)|213.211.198.58|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 184 [application/octet-stream]
Saving to: ‘eicar_com.zip’

100%[=========================================================================================================================================================================>] 184         --.-K/s   in 0s      

2019-04-04 22:42:09 (21.6 MB/s) - ‘eicar_com.zip’ saved [184/184]

[ec2-user@ip-XXX-XXX-XXX-XXX ~]$ wget http://2016.eicar.org/download/eicarcom2.zip
--2019-04-04 22:42:17--  http://2016.eicar.org/download/eicarcom2.zip
Resolving 2016.eicar.org (2016.eicar.org)... 213.211.198.58
Connecting to 2016.eicar.org (2016.eicar.org)|213.211.198.58|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 308 [application/octet-stream]
Saving to: ‘eicarcom2.zip’

100%[=========================================================================================================================================================================>] 308         --.-K/s   in 0s      

2019-04-04 22:42:17 (34.7 MB/s) - ‘eicarcom2.zip’ saved [308/308]

[ec2-user@ip-XXX-XXX-XXX-XXX ~]$
```
...and over `https`...
```
[ec2-user@ip-XXX-XXX-XXX-XXX eicar-s]$ curl -O https://secure.eicar.org/eicar.com
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    68  100    68    0     0     59      0  0:00:01  0:00:01 --:--:--    59
[ec2-user@ip-XXX-XXX-XXX-XXX eicar-s]$ curl -O https://secure.eicar.org/eicar.com.txt
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    68  100    68    0     0    142      0 --:--:-- --:--:-- --:--:--   142
[ec2-user@ip-XXX-XXX-XXX-XXX eicar-s]$ curl -O https://secure.eicar.org/eicar_com.zip
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   184  100   184    0     0    385      0 --:--:-- --:--:-- --:--:--   384
[ec2-user@ip-XXX-XXX-XXX-XXX eicar-s]$ curl -O https://secure.eicar.org/eicarcom2.zip
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   308  100   308    0     0    643      0 --:--:-- --:--:-- --:--:--   641
[ec2-user@ip-XXX-XXX-XXX-XXX eicar-s]$
```
Let's copy eicar to `/etc` and make it executable...
```
[ec2-user@ip-XXX-XXX-XXX-XXX eicar-s]$ sudo cp eicar.com /etc/
[ec2-user@ip-XXX-XXX-XXX-XXX eicar-s]$ sudo chmod +x /etc/eicar.com
[ec2-user@ip-XXX-XXX-XXX-XXX eicar-s]$
```
Finally, let's pull down the payload from a _known bad_ IP:
```
[ec2-user@ip-XXX-XXX-XXX-XXX evil]$ wget http://18.231.31.145/file.sh
--2019-04-04 23:12:59--  http://18.231.31.145/file.sh
Connecting to 18.231.31.145:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 68 [application/octet-stream]
Saving to: ‘file.sh’

100%[=========================================================================================================================================================================>] 68          --.-K/s   in 0s      

2019-04-04 23:13:00 (6.92 MB/s) - ‘file.sh’ saved [68/68]

[ec2-user@ip-XXX-XXX-XXX-XXX evil]$
```


Unfortunately, Lacework didn't alert on any of the above =( -- I'm quite surprised and I'll be following up with them to see if I should have configured something differently to enable file and network monitoring.

How about playing with `whois`?
```
sudo yum install whois
whois 18.231.31.145
```
Lacework caught a few interesting things here.

![Whois Escalation](/assets/whoisescalation.png)

It's pretty cool to see it call out the escalation, the applications used, and the new outbound connection.

Drilling into the network event, we see the evil host we reached out to in `sa-east-1`, so now I'm even more curious why the malware pull wasn't flagged as its own event.

![Network Connections](/assets/networkconnections.png)

Finally, let's look at uninvited visitors.
```
[ec2-user@ip-XXX-XXX-XXX-XXX evil]$ sudo grep sshd /var/log/secure | grep -v XXX.XXX.XXX.XXX
Apr  4 17:59:11 ip-XXX-XXX-XXX-XXX sshd[3291]: Server listening on 0.0.0.0 port 22.
Apr  4 17:59:11 ip-XXX-XXX-XXX-XXX sshd[3291]: Server listening on :: port 22.
Apr  4 17:59:11 ip-XXX-XXX-XXX-XXX sshd[3291]: Received signal 15; terminating.
Apr  4 17:59:12 ip-XXX-XXX-XXX-XXX sshd[3312]: Server listening on 0.0.0.0 port 22.
Apr  4 17:59:12 ip-XXX-XXX-XXX-XXX sshd[3312]: Server listening on :: port 22.
Apr  4 18:06:07 ip-XXX-XXX-XXX-XXX sshd[3429]: pam_unix(sshd:session): session opened for user ec2-user by (uid=0)
Apr  4 18:45:54 ip-XXX-XXX-XXX-XXX sshd[3548]: Did not receive identification string from 107.170.196.17 port 48322
Apr  4 18:50:10 ip-XXX-XXX-XXX-XXX sshd[32245]: Invalid user admin from 141.98.81.81 port 59953
Apr  4 18:50:10 ip-XXX-XXX-XXX-XXX sshd[32245]: input_userauth_request: invalid user admin [preauth]
Apr  4 18:50:10 ip-XXX-XXX-XXX-XXX sshd[32245]: Disconnecting: Change of username or service not allowed: (admin,ssh-connection) -> (user,ssh-connection) [preauth]
Apr  4 19:36:48 ip-XXX-XXX-XXX-XXX sshd[32611]: Invalid user pi from 91.50.190.50 port 52948
Apr  4 19:36:48 ip-XXX-XXX-XXX-XXX sshd[32611]: input_userauth_request: invalid user pi [preauth]
Apr  4 19:36:48 ip-XXX-XXX-XXX-XXX sshd[32613]: Invalid user pi from 91.50.190.50 port 52954
Apr  4 19:36:48 ip-XXX-XXX-XXX-XXX sshd[32613]: input_userauth_request: invalid user pi [preauth]
Apr  4 19:36:49 ip-XXX-XXX-XXX-XXX sshd[32611]: Connection closed by 91.50.190.50 port 52948 [preauth]
Apr  4 19:36:49 ip-XXX-XXX-XXX-XXX sshd[32613]: Connection closed by 91.50.190.50 port 52954 [preauth]
Apr  4 21:48:31 ip-XXX-XXX-XXX-XXX sshd[733]: Invalid user admin from 90.21.89.65 port 34878
Apr  4 21:48:31 ip-XXX-XXX-XXX-XXX sshd[733]: input_userauth_request: invalid user admin [preauth]
Apr  4 21:48:31 ip-XXX-XXX-XXX-XXX sshd[733]: Connection closed by 90.21.89.65 port 34878 [preauth]
Apr  4 22:35:18 ip-XXX-XXX-XXX-XXX sshd[3429]: pam_unix(sshd:session): session closed for user ec2-user
Apr  4 22:41:35 ip-XXX-XXX-XXX-XXX sshd[991]: pam_unix(sshd:session): session opened for user ec2-user by (uid=0)
Apr  4 23:00:23 ip-XXX-XXX-XXX-XXX sshd[1170]: Bad protocol version identification '\026\003\001\001"\001' from 164.52.24.164 port 60141
Apr  4 23:01:14 ip-XXX-XXX-XXX-XXX sshd[1171]: Connection reset by 164.52.24.164 port 45683 [preauth]
[ec2-user@ip-XXX-XXX-XXX-XXX evil]$
```
We can see several uninvited access attempts, but Lacework only alerts on one:
![Bad Actor](/assets/badactor.png)
This could well be to avoid flooding alerts with the never-ending barrage of `ssh` attempt given that the one that was called out tried to use a protocol exploit as opposed to just guessing a password.  The rest of the bad login are summarized in the instance drill-down.
![Bad Logins](/assets/badlogins.png)

That's all for now -- I'll update after chatting with Lacework tomorrow.
