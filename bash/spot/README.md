SPOPT directory
===============

This is a personal directory used to set up my various hosts (dev machine,
laptop etc.).

The Problem
-----------

I need to use multiple machines and keep some files synced between them.  I
could use `syncthing` or some such mechanism but this also ties into my backup
procedure so I'd like complete _manual_ control of the system.

Solution
---------

Use a Single Point Of Truth aka a master copy of files that can be
share/accessed from multiple machines.  push/pull to/from this master copy
before/after working on any machine.

We can then use symlinks to set up ~ on each host.

Master copy of SPOT/ resides on a local server.  Backups are handled by the
local server.

TODO
----

- Sync SPOT/ to a cloud node for offsite backup and global access.  (or just
use a cloud backup solution and access home network from the net.)
