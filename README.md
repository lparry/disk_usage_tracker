Disk Usage Tracker
==================

Track where your space is going chronologically. Takes the output of du and
stores it in a format so you can compare your disk usage changes between two
points in time.

Its the result of my minimal Sunday hacking at Railscamp X in Adelaide,
Australia.

Usage
-----
Add bin/take\_snapshot to crontab so it's run however often you want your
snapshots taken. Then when you want to compare two points in time, run
bin/change_sets and you'll end up in a pry console with a list of your
snapshots and an example how to use them

TODO
----
- Make the path that du is run on configurable. ~/Dropbox/ is just a placeholder
- Store the snapshots somewhere else. Maybe ~/.disk\_usage\_tracker or something
- Add bundler stuff
- Work out gem packaging with binaries
- Probably lots more. This is far from finished.
