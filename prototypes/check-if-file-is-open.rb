# From: http://linux.die.net/man/2/flock
# If a process uses open(2) (or similar) to obtain more than one
# descriptor for the same file, these descriptors are treated
# independently by flock(). An attempt to lock the file using one of
# these file descriptors may be denied by a lock that the calling
# process has already placed via another descriptor.

path = `mktemp /tmp/XXXXXXXXXX`.strip
puts path

locking_fd = File.open path, 'r+'
locking_fd.flock File::LOCK_EX

second_fd = File.open path, 'a'

second_fd.write("hello\n")

# Doesn't work because flock is advisory. Mandatory locks can only be set
# on files in linux using fcntl and by mounting the drive using -o mand
# and disabling group execute permision on the file. See:
# http://linux.die.net/man/2/fcntl
