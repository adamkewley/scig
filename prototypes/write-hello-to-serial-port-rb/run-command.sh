#!/bin/bash

# /bin/bash --login
rvmsudo bundle exec ruby read-line-from-serial-port.rb /dev/ttyS98
