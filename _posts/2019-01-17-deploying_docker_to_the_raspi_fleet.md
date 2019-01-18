---
layout: post
title:  Deploying Docker to the RasPi Fleet
date:   2019-01-17 17:23:18 -0800
tags:   raspberry_pi clustering docker
---
![Raspberry Pi SD Cards](/assets/20190117_175900.jpg)

## SSH into each Pi and type...

Via the [official docs](https://docs.docker.com/install/linux/docker-ce/debian/), the appropriate way to install Docker on a Raspberry Pi is to use the [convenience script](https://docs.docker.com/install/linux/docker-ce/debian/#install-using-the-convenience-script).  Throwing caution to the wind, you can just SSH into each Pi and run `curl -sSl https://get.docker.com | sh`.  The Pi will download the script and install everything, escalating privileges via `sudo` where appropriate.  On your basic Raspbian image, this will go off without a hitch as the `pi` user has `sudo` rights w/o having to provide a password.

To setup a swarm, you have to SSH into your lead node, initialize a swarm, copy the worker token, then SSH into each of the workers and use that token to join the swarm.

## Slightly Faster

Of course, we don't want to SSH into each Pi -- we want a [script](https://github.com/cilynx/raspi/blob/master/setup_docker.sh) to handle the overhead for us.

This script does several things for us:
1. Checks if you passed in an existing manager node to join (`-j`) and if not, installs Docker on the first node in the list and initializes a new swarm with this node as the lead (and only) manager.  (When installing Docker, any existing Docker setup is first removed and the `pi` user is added to the `docker` group.)
2. Grabs the worker join token from the newly created leader or the manager provided with `-j`.
3. Installs Docker on all remaining nodes in parallel and joins them to the swarm using the aforementioned worker token.

This script is a bit more error prone than the others as it uses fire-and-forget to achieve parallelism, but it does generally work.  I've found that if anything fails, just firing it again for the failed nodes passing `-j` with the newly minted leader tends to bring those nodes inline.  I'll likely address this in a future post discussing Docker deployment via Ansible or Salt or Puppet or Chef or Lions or Tigers or Bears, oh my!
