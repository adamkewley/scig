#!/bin/bash

sudo socat -d -d PTY,link=$1,echo=0 PTY,link=$2,echo=0
