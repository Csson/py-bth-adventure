#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""Main game class for the adventure game."""

from adventurehelpers import load_from_json, slowprint, clear, say, save_to_json
import random, re, time, sys

def common_commands():
    print("""\n\nAvailable commands:

h / help            - This help info
i / intro           - Repeats the location description
c / clue            - If you are stuck Guybrush might help you,
                      but not too much
l / look            - What does Guybrush have to say about the location
o / objects         - Prints the available objects in the location
inv / inventory     - Shows everything you carry

say [anything]      - Say what you want
l / look [object]   - What does Guybrush have to say about the object
o / open [object]   - Open it
p / pickup [object] - Pick it up, and carry it with you
k / kick [object]   - Kick it, it might break
m / move [object]   - Move it, there might be something behind it

u / use [object] with [object] - Make to objects work together

s / save [filename] - Saves the game as 'saved_<filename>.json'

(not all commands are available for all objects)""")

class Game(object):
    """Game class"""

    def __init__(self, load_game):

        """Properties for the game"""

        self.gamedata = load_from_json('gamedata.json')
        self.playerdata = load_from_json(load_game)

        if 'starttime' in self.playerdata:
            self.starttime = self.playerdata['starttime']
        else:
            self.starttime = int(time.time())
            self.playerdata['starttime'] = self.starttime

        if not 'room' in self.playerdata:
            print("Illegal game file. Quitting.")
            sys.exit()

        self.gameloop()

    def possible_directions(self, room):
        """Prints where you can go from the chosen room"""

        if len(self.playerdata['possible_navigation'][room['id']]) == 0:
            say("You can't go anywhere from here, currently.")
            return

        say("From here, you can currently:")

        for where in room['navigate']:
            if where in self.playerdata['possible_navigation'][room['id']]:
                print("* go %s" % where)

    def intro(self, room):
        intro = room['intro']

        for objid in self.playerdata['objects_in_room'][room['id']]:
            obj = self.get_object_by_id(objid)

            if 'text' in obj and 'original' in obj['text']:
                intro = intro + "\n\n" + obj['text']['original']

        for objid in self.playerdata['added_to_room'][room['id']]:
            obj = self.get_object_by_id(objid)

            if 'text' in obj:
                intro = intro + "\n\n" + obj['text']['dropped']

        return intro

    def show_inventory(self):
        """Shows inventory"""

        if len(self.playerdata['inventory']) == 0:
            say("You are free from worldly possessions.")
            return

        say("You carry the following items:")

        for objid in self.playerdata['inventory']:
            obj = self.get_object_by_id(objid)
            print("* %s" % obj['name'])


    def get_room(self, room_id):
        """Find the room with the given id"""
        for room in self.gamedata['rooms']:
            if room['id'] == room_id:
                return room

    def get_room_by_name(self, roomname):
        """Find the room with the given name"""
        for room in self.gamedata['rooms']:
            if room[obj] == roomname:
                return room

        print("Can't go there.")

    def is_possible_navigation(self, origin_room, navigation):
        """Can we go there from here?"""

        if origin_room['id'] in self.playerdata['possible_navigation']:
            if navigation in self.playerdata['possible_navigation'][origin_room['id']]:
                return 1
        return 0

    def get_object_by_id(self, objectid):
        """Gets the object by id"""

        for obj in self.gamedata['objects']:
            if obj['id'] == objectid:
                return obj

    def get_object_by_name(self, objectname):
        """Gets the object by name"""

        for obj in self.gamedata['objects']:
            if obj['name'] == objectname:
                return obj

    def is_object_available(self, room, obj):
        """Determines if the object is available in the room"""

        if obj['id'] in self.playerdata['objects_in_room'][room['id']]:
            return 1
        elif obj['id'] in self.playerdata['added_to_room'][room['id']]:
            return 1

        return 0

    def is_object_in_inventory(self, obj):
        if obj['id'] in self.playerdata['inventory']:
            return 1
        return 0

    def show_objects(self, room):

        if len(self.playerdata['objects_in_room'][room['id']]) + len(self.playerdata['added_to_room'][room['id']]) == 0:
            print("No object in this room seem particularly interesting.")
            return

        print("You see the following objects:\n")

        for objectid in self.playerdata['objects_in_room'][room['id']]:
            obj = self.get_object_by_id(objectid)
            print("* %s" % obj['name'])

        for objectid in self.playerdata['added_to_room'][room['id']]:
            obj = self.get_object_by_id(objectid)
            print("* %s" % obj['name'])

    def handle_removal(self, removal):
        for where in removal:
            if where == 'inventory':
                for objid in removal[where]:
                    if self.is_object_in_inventory(self.get_object_by_id(objid)):
                        self.playerdata['inventory'].remove(objid)

            else:
                for objid in removal[where]:
                    if self.is_object_available(self.get_room(where), self.get_object_by_id(objid)):
                        self.playerdata['objects_in_room'][where].remove(objid)

    def handle_reveal(self, reveal):

        for where in reveal:
            if where == 'inventory':
                for objid in reveal[where]:
                    if not self.is_object_in_inventory(self.get_object_by_id(objid)):
                        self.playerdata['inventory'].append(objid)

            else:
                for objid in reveal[where]:
                    if not self.is_object_available(self.get_room(where), self.get_object_by_id(objid)):
                        self.playerdata['objects_in_room'][where].append(objid)


    def useful_together(self, room, first_object, second_object):
        if self.is_object_available(room, first_object) or self.is_object_in_inventory(first_object):
            if self.is_object_available(room, second_object) or self.is_object_in_inventory(second_object):
                if 'actions' in first_object and 'use' in first_object['actions']:
                    for possible_use in first_object['actions']['use']:
                        if second_object['id'] == possible_use['with']:
                            return 1

        return 0

    def try_remove_from_room_or_inventory(self, room, obj):
        """Removes obj from either the room or inventory, if it is available in either"""

        if self.is_object_available(room, obj):
            self.playerdata['objects_in_room'][room['id']].remove(obj['id'])
        if self.is_object_in_inventory(obj):
            self.playerdata['inventory'].remove(obj['id'])

    # make sure to call useful_together() first!
    def use_together(self, room, first_object, second_object):
        for possible_use in first_object['actions']['use']:
            if second_object['id'] == possible_use['with']:

                if 'reveals' in possible_use:
                    self.handle_reveal(possible_use['reveals'])

                if 'removes' in possible_use:
                    self.handle_removal(possible_use['removes'])

                if 'added_navigation' in possible_use:
                    self.playerdata['possible_navigation'][room['id']].extend(possible_use['added_navigation'])

                say(possible_use['comment'])

    def handle_room_changing_action(self, room, obj, action):
        if action in obj['actions']:

            if 'when' in obj['actions'][action]:
                if 'removed' in obj['actions'][action]['when']:
                    conditional_object = self.get_object_by_id(obj['actions'][action]['when']['removed'])
                    if self.is_object_available(room, conditional_object):
                        say(obj['actions'][action]['else']['comment'])
                        return

            say(obj['actions'][action]['comment'])

            if 'reveals' in obj['actions'][action]:
                self.handle_reveal(obj['actions'][action]['reveals'])

            if 'removes' in obj['actions'][action]:
                self.handle_removal(obj['actions'][action]['removes'])

            if 'added_navigation' in obj['actions'][action]:
                self.playerdata['possible_navigation'][room['id']].extend(obj['actions'][action]['added_navigation'])


            if 'the_end' in obj['actions'][action]:
                input()
                clear()
                say(self.gamedata['the_end'])
                input()
                clear()
                sys.exit()

        else:
            say("Can't do that.")

    def save_progress(self):
        save_to_json('progress_' + str(self.starttime) + '.json', self.playerdata)

    def show_tictactoe(self, toe):
        return """
-------------
| {} | {} | {} |
-------------
| {} | {} | {} |
-------------
| {} | {} | {} |
-------------
""".format(toe['1'], toe['2'], toe['3'], toe['4'], toe['5'], toe['6'], toe['7'], toe['8'], toe['9'])

    def play_tictactoe(self):
        clear()
        toe = { '1' : '1', '2' : '2', '3' : '3', '4' : '4', '5' : '5', '6' : '6', '7' : '7', '8' : '8', '9' : '9' }

        say("""Not again, you think. "Okay", you say as you sit down to yet another match.""")
        say("The game looks like this:")
        say(self.show_tictactoe(toe))
        say("""""I am O, you are X.", says Guybrush." """)

        move_count = 0
        while True:
            move = input("""\n"Make your move!" """)

            try:
                intmove = int(move)
            except:
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
            say(self.show_tictactoe(toe))
            
            move_count += 1

            if self.analyze_tictactoe(toe, 'X'):
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

            say(self.show_tictactoe(toe))

            if self.analyze_tictactoe(toe, 'O'):
                say(""""I win, I win, I win! I knew I could beat you!", Guybrush rejoices victoriously.""")
                break


    def analyze_tictactoe(self, toe, player):
        if player == toe['1'] == toe['2'] == toe['3']:
            return 1
        if player == toe['4'] == toe['5'] == toe['6']:
            return 1
        if player == toe['7'] == toe['8'] == toe['9']:
            return 1
        if player == toe['1'] == toe['4'] == toe['7']:
            return 1
        if player == toe['2'] == toe['5'] == toe['8']:
            return 1
        if player == toe['3'] == toe['6'] == toe['9']:
            return 1
        if player == toe['1'] == toe['5'] == toe['9']:
            return 1
        if player == toe['3'] == toe['5'] == toe['7']:
            return 1

        return 0

    def gameloop(self):
        """The big game loop"""

        current_room = self.get_room(self.playerdata['room'])

        clear()
        slowprint(self.intro(current_room))

        while True:
            self.save_progress()
            answer = input("\n\nWhat do you want to do? ")

            clear()

            if answer in ['i', 'intro']:
                clear()
                print(self.intro(current_room))

            elif answer in ['h', 'help']:
                self.possible_directions(current_room)
                common_commands()

            elif answer in ['o', 'objects']:
                self.show_objects(current_room)

            elif answer in ['l', 'look']:
                print(current_room['actions']['look'])

            elif answer in ['c', 'clue']:
                print(random.choice(current_room['clues']))

            elif answer in ['inv', 'inventory']:
                self.show_inventory()

            if ' ' in answer:

                match_use = re.match(r'use (.*) with (.*)', answer)
                if match_use:
                    first_object = self.get_object_by_name(match_use.group(1))
                    second_object = self.get_object_by_name(match_use.group(2))

                    if first_object == None or second_object == None:
                        say("I don't understand.")
                        continue

                    elif first_object == second_object:
                        say("Can't use it with itself.")
                        continue

                    elif self.useful_together(current_room, first_object, second_object):
                        self.use_together(current_room, first_object, second_object)
                        continue
                    else:
                        say("I don't know what you mean?")
                        continue

                (command, objectname) = answer.split(" ", 1)

                if command in ['s', 'save']:
                    filename = 'saved_' + objectname + '.json'
                    save_to_json(filename, self.playerdata)
                    say('Game saved as ' + filename)
                    continue

                if command == 'say':
                    found_say = 0

                    if 'actions' in current_room and 'say' in current_room['actions']:
                        for possible_say in current_room['actions']['say']:
                            if possible_say['what'] == objectname:
                                found_say = 1
                                say(possible_say['comment'])

                                if 'reveals' in possible_say:
                                    self.handle_reveal(possible_say['reveals'])

                                if 'removes' in possible_say:
                                    self.handle_removal(possible_say['removes'])
                                    

                    if not found_say:
                        say('"%s"' % objectname)

                    continue


                if command == 'go':
                    if self.is_possible_navigation(current_room, objectname):
                        if objectname == 'tic-tac-toe':
                            self.play_tictactoe()
                            continue

                        current_room = self.get_room(current_room['navigate'][objectname]['destination'])
                        self.playerdata['room'] = current_room['id']
                        clear()
                        print(self.intro(current_room))

                    else:
                        print("Can't go there.")
                    continue


                obj = self.get_object_by_name(objectname)

                if not obj:
                    print("There is no such object.")
                    continue

                if(command in ['l', 'look'] 
                  and (self.is_object_available(current_room, obj) or self.is_object_in_inventory(obj)) 
                  and 'look' in obj['actions']):

                    say(obj['actions']['look'])


                if self.is_object_available(current_room, obj):

                    if command in ['p', 'pickup']:
                        if 'pickup' in obj['actions']:

                            if obj['id'] in self.playerdata['objects_in_room'][current_room['id']]:
                                self.playerdata['objects_in_room'][current_room['id']].remove(obj['id'])

                            elif obj['id'] in self.playerdata['added_to_room'][current_room['id']]:
                                self.playerdata['added_to_room'][current_room['id']].remove(obj['id'])

                            self.playerdata['inventory'].append(obj['id'])
                            say(obj['actions']['pickup']['comment'])
                        else:
                            say("Can't do that.")

                    elif command in ['t', 'talk']:
                        self.handle_room_changing_action(current_room, obj, 'talk')

                    elif command in ['m', 'move']:
                        self.handle_room_changing_action(current_room, obj, 'move')

                    elif command in ['k', 'kick']:
                        self.handle_room_changing_action(current_room, obj, 'kick')

                    elif command in ['o', 'open']:
                        self.handle_room_changing_action(current_room, obj, 'open')

                elif self.is_object_in_inventory(obj):

                    if command in ['d', 'drop']:
                        self.playerdata['added_to_room'][current_room['id']].append(obj['id'])
                        self.playerdata['inventory'].remove(obj['id'])
                        say("I don't want that anymore.")


                    elif command in ['o', 'open']:
                        if 'open' in obj['actions']:
                            say(obj['actions']['open']['comment'])

                            if 'reveals' in obj['actions']['open']:
                                self.playerdata['inventory'].extend(obj['actions']['open']['reveals'])

                else:
                    say('No such object.')

