#!/bin/bash

exiqgrep -z -i -o 1000|xargs exim -Mrm
