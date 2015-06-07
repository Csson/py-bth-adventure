#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""cli program for the adventure game"""

import sys, getopt
from adventurehelpers import underline, clear
from game import Game
import os.path


def usage():
    """Display options for adventure.py"""

    print("""
        adventure.py

        This is a text based adventure game, set in an unknown time and place.

        Usage:

        ./adventure.py                Play game
        ./adventure.py --load=<file>  Play game, load a saved game

        ./adventure.py --""" + underline('h') + """elp         Display this usage information
        ./adventure.py --""" + underline('i') + """nfo         Display more game related information
        ./adventure.py --""" + underline('v') + """ersion      Display game version
        ./adventure.py --""" + underline('a') + """bout        Display information about the author
        ./adventure.py --""" + underline('c') + """heat        Displays cheat information

    """)

def version():
    """Displays game version"""

    print("This is version 3.1415")

def show_intro():

    """Show the game intro"""

    clear()
    print("""
                                    w e l c o m e   to 


                                         @;         ..,                                          
    :'                                    .'@@@@@@@@@###                                          
    @@     @,      `      ,.                     @            .:`     +                           
   `#.@    ,@@#`   @`     #, '+';   ;,      `@   @            +@@@   @:@@@`           #     @     
   ': @    .# ,@@  :'     @  @,:;   ';#      @   @ `:      #`  @ #;  @`         @@@@  #'   @.     
   @` ;+   `@   `@  @     @  @      ++@      @   @ ,+      .#  @  @  #`         @   @  @   @      
   @   @    @    @  @    #.  @      @``@     @   @ ,+      `@ `@  @  +,         @   .@  @  @      
   @   @    @    @  @    @   @      @  +#    @   @ ,+       @ `@ `@  ,+         @    @  ;@+:      
   @@@@@    @    @  ':  :'   @      @   @    @  `@ ,+       @ .+ @.   @#'`      @    @   @@       
  ,+   ''   @    ':  @  @    @@@@@  @   `@   @  `@  @       @ :@@'    @.:+      @@@@@.   .@       
  +,    @   @    ':  @  @    @     `@    @.  @   @  @       @ ,@      @         #`       .#       
  @     @`  @    ':  @ @`    @     .+     @ .+   @  @:     ;# ,+@;    @         @`       ,+       
  @     `@  @    @`  +,@     @     ,+     @.,+   @   @     @  ,+ @:   @         ;;       ,+       
  @      @  @    @   `@.     @     ,+      @::   @   +@# :@.  ;;  @   @          @       ,+       
 `@      ++ @    @    '      @`    ,+      '@.   @     +@+    #`  ,@  @          @       ,+       
 :'         @',,@:           @@@@@@,+       @`   @            @`   #+ #@@@@  @   @       ,#       
 #.         .`##                                                                         `@       

This is the story of a walk in a forest. Who knows what awaits behind the trees?

Fortunately, you have your friend Guybrush by your side. He knows the forest well, but
he is a bit indecisive - so you have to make all decisions.

    """)

    input("Press any key to begin")

def run_game(load_game='save_game_default.json'):
    """Initializes the game"""

    if not os.path.isfile(load_game):
        print("No such file <%s>. Can't load saved game. Quitting." % load_game)
        sys.exit()

    show_intro()

    Game(load_game)

def main(argv):
    """Parse command line"""

    try:
        opts, _ = getopt.getopt(argv, "hivacl", ["help", "version", "info", "about", "cheat", "load="])

    except Exception:
        usage()
        sys.exit(1)

    for opt, arg in opts:

        if opt in ("-h", "--help"):
            usage()
            sys.exit()

        elif opt in ("-v", "--version"):
            version()
            sys.exit()

        elif opt == "--load":
            run_game(arg)

    run_game()

if __name__ == "__main__":
    main(sys.argv[1:])
