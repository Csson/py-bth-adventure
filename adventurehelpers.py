#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Helper functions adventure.py."""

import json#, sys, time, random

BOLD = '\033[1m'
UNDERLINE = '\033[4m'
END = '\033[0m'

def bold(string):
    """Prints the string boldly"""
    return BOLD + string + END

def underline(string):
    """Prints the string underlined"""
    return UNDERLINE + string + END

def slowprint(string):
    """Prints the string slowly"""
    print(string)

#    for char in string:
#        sys.stdout.write(char)
#        sys.stdout.flush()
#        time.sleep(0.005 + (random.randint(0, 2) / 1000))

def clear():
    """Clears the screen, and puts the cursor top left"""
    print(chr(27) + "[2J")
    print("\033[0;0H")

def load_from_json(path):
    """Loads json from file"""
    fh = open(path)
    contents = fh.read()
    fh.close()

    return json.loads(contents)

def save_to_json(filename, struct):
    """Saves struct (list/dict) as json to filename"""
    with open(filename, 'w') as outfile:
        json.dump(struct, outfile, sort_keys=True, indent=4)

def say(string):
    """Prints string with leading new line"""
    print("\n" + string)
