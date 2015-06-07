#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""Handles the tic-tac-toe games"""

from adventurehelpers import clear, say
import random

def show_tictactoe(toe):
    """Determine current state of tic-tac-toe game"""

    return """
-------------
| {} | {} | {} |
-------------
| {} | {} | {} |
-------------
| {} | {} | {} |
-------------
""".format(toe['1'], toe['2'], toe['3'], toe['4'], toe['5'], toe['6'], toe['7'], toe['8'], toe['9'])

def play_tictactoe():
    """Play a game of tic-tac-toe!"""

    clear()
    toe = {'1' : '1', '2' : '2', '3' : '3', '4' : '4', '5' : '5', '6' : '6', '7' : '7', '8' : '8', '9' : '9'}

    say("""Not again, you think. "Okay", you say as you sit down to yet another match.""")
    say("The game looks like this:")
    say(show_tictactoe(toe))
    say("""""I am O, you are X.", says Guybrush." """)

    move_count = 0
    while True:
        move = input("""\n"Make your move!" """)

        try:
            intmove = int(move)
        except ValueError:
            say("""Don't you know the rules?", Guybrush says.""")
            continue

        if intmove < 1 or intmove > 9:
            say(""""We don't have all day, dude", Guybrush says a bit angry.""")
            continue

        move = str(intmove)

        if toe[move] != move:
            say(""""That's already taken, try again my friend", Guybrush says confidently.""")
            continue

        toe[move] = 'X'
        say(show_tictactoe(toe))
        
        move_count += 1

        if analyze_tictactoe(toe, 'X'):
            say(""""You win! By the way, I think you should place something heavy on this table..." """)
            break

        if move_count == 9:
            say(""""It's a draw. That's boring. Can't we play again, please? Pretty please? With sugar on top?" """)
            break

        say(""""My move" """)

        guybrush_hasnt_moved = 1

        while guybrush_hasnt_moved:
            gmove = str(random.choice([1, 2, 3, 4, 5, 6, 7, 8, 9]))

            if toe[gmove] == gmove:
                toe[gmove] = 'O'
                move_count += 1
                guybrush_hasnt_moved = 0

        say(show_tictactoe(toe))

        if analyze_tictactoe(toe, 'O'):
            say(""""I win, I win, I win! I knew I could beat you!", Guybrush rejoices victoriously.""")
            break


def analyze_tictactoe(toe, player):
    """Has player won?"""

    has_won = 0

    if player == toe['1'] == toe['2'] == toe['3']:
        has_won = 1
    if player == toe['4'] == toe['5'] == toe['6']:
        has_won = 1
    if player == toe['7'] == toe['8'] == toe['9']:
        has_won = 1
    if player == toe['1'] == toe['4'] == toe['7']:
        has_won = 1
    if player == toe['2'] == toe['5'] == toe['8']:
        has_won = 1
    if player == toe['3'] == toe['6'] == toe['9']:
        has_won = 1
    if player == toe['1'] == toe['5'] == toe['9']:
        has_won = 1
    if player == toe['3'] == toe['5'] == toe['7']:
        has_won = 1

    return has_won
