---
layout: post
title:  Keeping Yourself in Sync with Syncthing and Gocryptfs
date:   2019-01-18 14:55:18 -0800
tags:   
---
![Encrypted Syncthing](/assets/cryptosync.png)

For quite a long time, every time I upgraded my primary machine, I `rsync`ed my home directory from the old machine into an `$old_hostname-backup` folder on the new machine.  As the years went by, I found myself with no less than a dozen layers deep of `~/$some_host-backup/$older_host-backup/$even_older_host-backup/papyrus-backup/cave_wall_scrapings-backup/`.  I would then copy those backups around to other random machines for durability and availability of the um...archived =/...files.  This is of course stupid, error prone, time consuming, begging for collisions, etc.  Maybe a couple years ago, I set out to find a better solution to managing my personal data and it's been working flawlessly now long enough that I'm comfortable recommending it to others.

## Gathering Requirements

Since I was actually going to put effort into this, I wanted to make sure I covered all of my bases.  My endgame criteria were:
1. Data are divided into folders based on high-level topic, e.g. `Documents`, `Projects`, `Pictures`.
2. Various folders are accessible on various systems following ever-changing needs.
3. Adding and syncing a new node must be easy.
4. No central repository / single point of failure.
5. Do not trust storage or transit.
6. Data must survive hardware failures up to and including my house burning down with everything I own in it.
7. Data must survive me being stupid -- e.g. clobbering or deleting things that should not have been clobbered or deleted.
8. Nodes will come and go freely -- connectivity may be LAN, Internet, crappy cell-phone hotspot, or non-existent.
9. Data must be available and changeable when nodes are offline.
10. Offline changes must propagate automagically when connectivity is restored.
11. When connectivity is available, synchronization must be "fast".
12. Physically stolen nodes must not allow an attacker access to data.
13. Nodes can be excommunicated from the cluster without accessing them.

## The Solution

Enter `syncthing` and `gocryptfs`.  (To be 100% honest, I originally deployed this with `encfs` and ran it that way for the bulk of the last couple years.  I recently migrated my datastores over to `gocryptfs` as it has positive current audit history and is actively maintained, unlike `encfs`.)

`Syncthing` handles the vast majority of the heavy lifting with `gocryptfs` filling in the gaps:
1. `Syncthing` supports many individual folders
2. You add folders on nodes and every node relationship can be push only, pull only, or reciprocal.
3. Adding a new node is as simple as pasting in UUID(s) from known nodes, picking which folders to share, and confirming on the existing node(s).
4. `Syncthing` has no central system.  All data and indexes live on your nodes.
5. `Syncthing` provides an encrypted transport / relay network which I haven't seen anyone complain about, but I'm still more comfortable storing everything encrypted at the file level (thank you `gocryptfs`) and syncing only those encrypted files.  This also means that if in the future I decided to add a cloud node that I would not have to trust its storage as far as unauthorized access to my data.
6. `Syncthing` runs on Android, so by adding a large SD card to my phone, if I make it out of my burning house, so do my data.
7. `Syncthing` supports multiple flavors of versioning on a per-node basis.  By setting up versioning on at least one node, I have a recovery path for my own mistakes.
8. `Syncthing` gracefully handles connectivity coming and going and even allows you to configure what sort of connections it will sync over on Android (cellular, wifi, metered wifi, etc.)
9. By keeping a genuine copy of the necessary folders on each node, every node has access to the data even if it isn't currently online.
10. As with #8, `Syncthing` handles resync including collision management mostly transparently behind the scenes with the occasional collision-marked extra encrypted copy of a file if it can't figure out what to do.
11. Now that inotify is really working, `Syncthing` is very fast -- basically limited by your network throughput.  Things can get bogged down / thrashy in some nasty circumstances (like when you migrate all of your archives from `encfs` to `gocryptfs`), but that's another post.
12. All of my laptops are setup with standard Linux security mechanisms, full disk encryption, and I mount up the `gocryptfs` volumes on-demand, so the chances are pretty low that anyone would be able to get anything off of a stolen laptop.  I never mount the encrypted volumes on my phone and don't even know if `gocryptfs` supports Android.
13. This is baked into `Syncthing` due to its requiring authorization on both sides of every relationship.  It is straightforward to remove a node from your shared list, but you do have to do it on each node that has a relationship.

## My Schema

As I mentioned at the beginning, I have a few large high-level folders -- `Documents`, `Projects`, and `Pictures`.  All three are shared between my office laptop/workstation, my shop workstation, another laptop that generally lives in the shop, and my phone.  The terminals have RW access and the phone is RO.

Beyond the big stuff, I've found that having this mechanism in place has enabled couple little niceties as well.
1. I have a couple [OctoPrint plugins](https://github.com/cilynx/OctoPrint-Lathe/) that I work on and so I have shared folders mounted on OctoPi development instances as well as my workstations so I can do my coding comfortably on any of my terminals and the changes magically propagate out to the dev Pis connected to the machines for easy testing.
2. I have exactly one unencrypted folder.  Because `Syncthing` works on the phone, I figured it made sense to share the default camera folder.  I don't leave my pictures there long, but it's great that I can just take pictures on the phone and they're magically waiting for me on any of my workstations.  Once I bring them into the photo manager (which copies them to the encrypted `Pictures` heirarchy) and delete them on the workstation, they're magically removed from the phone (and other workstations) as well.  Can't complain.

## Caveats / Things that Suck

Now, while this is by far the best solution I've found, it isn't perfect.  Most of the challenges come from Syncthing expecting you to sync normal files, not piles of encryption.
* Because even the filenames are encrypted, most of `Syncthing`'s activity logs are much less useful.
* When the rare collision does happen, the collision copy shows up in the encrypted hierarchy and you never see anything in the cleartext mount.
* When I need to restore a file, I have to manually figure out which crypto file goes with the plaintext file I need to recover and then restore that.
* `Syncthing` does not like syncing tons of small files.  This is due to per-file overhead in the sync magic.  This means you don't really want to compile the kernel in a synced directory.  On the plus side, this has forced me to be more diligent about source control.  Instead of trusting my archives to protect my living source, I actually run branches and check everything in now.  When working on any given codebase I check it out into a temporary directory outside of the sync hierarchy and don't worry about the slight chance of hardware failure borking the working copy.
* The Android client has some wonks.  The most annoying one is that something on my phone keeps trying to update the modification time on files even though `Syncthing` is configured as read-only (e.g. the phone is not allowed to change the files, only read from the cluster and share cluster-approved versions with other members).  It's likely something to do with how Android handles storage.  The other nodes are configured to ignore changes from the phone as well, so nothing bad happens to the data, but the phone occasionally shows up as out of sync until I pull up the UI on the phone and hit `Revert Local Changes`.
* As you grow in node count, confirming every relationship on both sides gets old.  If I move much beyond the 5-nodes I have right now, I'll likely look into abandoning full-mesh for tiers and/or managing configurations with Ansible or some such.
* You could complain this this is a lot of data duplication -- a waste of storage space.  I get it.  However, storage is cheap.  I'm very happy "wasting" storage space on all of my endpoints compared to the risks and inconveniences of the alternatives.

*[archived]: Randomly dumped in a folder
