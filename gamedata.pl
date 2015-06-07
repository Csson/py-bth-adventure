#!/usr/bin/env perl
use 5.20.0;
use strict;
use warnings;
use syntax qw/qs qi/;
use String::Stomp;
use Path::Tiny;
use JSON::MaybeXS 'encode_json';

main();

sub main {

    my $data = {
        the_end => q{
        
                                                                                                                                      
                                                                                               `                             @@       
                                                                                              @@`                            @@       
                                                                                  ``          @@      ,.                     @@`      
       .,'#@@@@@@'     +@.                                                        @@          @@    @@@@@@@@@+;.             @@,      
  ;@@@@@@@@@@@@@@+     @@,      @@                             @@@@@@@@@@@        @@@         @@`   @@#@@@@@@@@@@@`          #@:      
  +@@@@@@@@,.`         @@.      @@                            +@@@@@@@@@@@       `@@@@        @@`   '@#    `,'#@@@@.         +@'      
         @@            @@`     ,@@    @@   `.,                +@'                `@@@@:       @@,   .@@          #@@:        '@+      
         @@            @@      #@'    @@@@@@@@'               ;@+                `@@:@@       ;@#    @@           #@@+       :@#      
         @@            @@      @@`    @@@@@@@@                :@#                `@@ @@@      ,@@    @@            :@@,      .@@      
         @@            @@      @@    .@@                      :@#                `@@  @@#     ,@@    @@.            ;@@      `@@      
         @@            @@     `@@    ,@@                      ,@@                `@@  `@@.    ,@@    +@'             @@#      @@      
         @@            @@+:`  ;@#    '@#                      .@@                `@@   '@@    .@@    :@@              @@      @@      
         @@            @@@@@@@@@:    +@;                      `@@                `@@    @@'    @@     @@              @@'     @@      
         @@            @@'@@@@@@     @@,                       @@                `@@    `@@`   @@     @@              .@@     @@      
         @@`           @@     @@     @@`                       @@                `@@     #@@   @@     @@`              @@     @@      
         @@`           @@    .@@     @@                        @@`               `@@      @@@  @@.    @@:              @@     @@      
         @@           `@@    #@'     @@@@@@@@@                 @@@@@@@@@         `@@       @@  @@.    ;@#              @@     @@`     
         @@           `@@    @@`     @@@@@@@@@#                @@@@@@@@@         `@@       @@' @@,    `@@              @@     @@.     
         @@           .@@    @@      @@     `;                 @@                `@@       ,@@ @@,     @@              @@`    @@,     
         @@           .@@    @@      @@                        @@                `@@        @@.@@,     @@              @@,    #@;     
         @@           '@#   `@@      @@                        @@                `@@        '@@@@,     @@.             '@#    ;@#     
         @@`          '@+   .@@      @@                        @@                `@@         @@@@,     @@,             `@@    ,@@     
         #@'          .@,   `@@     .@@                        @@                 @@         ;@@@:     #@'             `@@    `@+     
         :@@                 ,      .@@                        @@                 @@          @@@'     +@'             .@@            
         :@@                        ,@@                        @@                 @@           @@@     +@'           :@@@+            
          @:                        ,@@..`                     @@                .@@           @@@     +@+.......  +@@@@#             
                                    `@@@@@@@@@;                @@`               ;@#           `@@     +@@@@@@@@@@@@@@,               
                                     ,#@@@@@@@.                @@@+::,.  .:'     .@;                   :@@@@@@@@@@@#`          @@,    
                                                               `@@@@@@@@@@@@+                                                  @@,    
                                                                 ,'##@@@@@@'                                                          

  Composed by Erik Carlsson 2015.


        },
        rooms => [
            {
                id => 'path_branch',
                intro => stomp qs{
                    You went out one morning, and now you find yourself twenty miles out of town
                    on a narrow path deep in an unknown forest.

                    Suddenly, you reach a spot where the path splits in two. The left, as far as
                    you can see, looks pleasant enough. The right, just as nice, but maybe a
                    little grassier.

                    Overall though, time had worn them just the same. You have a feeling that you
                    can not come back here, not all the way at least, so you want to choose wisely.

                },
                navigate => {
                    left => {
                        comment => 'You have chosen .................... wisely.',
                        destination => 'little_house',
                    },
                    right => {
                        comment => 'You have chosen .................... wisely.',
                        destination => 'little_house',
                    },
                },
                actions => {
                    look => qs{A beautiful place in the forest. The arrow looks like it can fall off at any moment.},
                },
                clues => [
                    'The paths are equally nice, pick one.',
                    'You never know when you might need a piece of wood.'
                ],
            },
            {
                id => 'little_house',
                intro => stomp qi{
                    Happy with your choice you walk down this nice, meandering path, passing meadows and creeks.
                    You have noticed that the path is getting narrower and the sky darker. 

                    There rose before you a little house, and as the first drops rain fell you knock on the door.
                    
                    A young woman has opened the door.
                },
                actions => {
                    look => q{It's not just a house, it's a home.},
                },
                navigate => {
                    inside => {
                        destination => 'living_room',
                    },
                },
                clues => [
                    'There might be something you need here',
                    'Have you said hi yet?',
                ],
            },
            {
                id => 'living_room',
                intro => stomp qs{
                    You find yourself alone in the living room.
                    There is a fire burning in the (somewhat broken) fireplace.
                },
                actions => {
                    look => q{A living room made for living in.},
                },
                navigate => {
                    hall => {
                        comment => 'Might be interesting.',
                        destination => 'hall',
                    },
                    'open red door' => {
                        comment => 'I wonder why the door was locked?',
                        destination => 'stair',
                    },
                    garden => {
                        comment => 'I think that is for the best.',
                        destination => 'garden',
                    },
                },
                clues => [
                    'Where are all the books?',
                    'Does Damocles want his sword anymore?',
                ],
            },
            {
                id => 'hall',
                intro => stomp qs{
                    The hall is a warm entrance to the house. A fire burns in the nearby living room.
                },
                actions => {
                    look => q{Every home needs a hall.},
                },
                navigate => {
                    'living room' => {
                        comment => 'The living room',
                        destination => 'living_room',
                    },
                    'outside' => {
                        comment => q{I've been there before.},
                        destination => 'little_house',
                    },
                },
                clues => [
                    q{Maybe there's a key in the key locker?},
                ]
            },
            {
                id => 'stair',
                intro => stomp qs{
                    There is a stairway to a basement. Some tools hang on a wall.
                },
                actions => {
                    look => stomp qs{
                                A damp smell comes from the basement. The warmth of the fire in the
                                living room does not reach down there.

                                The tools appear well used.
                    },
                },
                navigate => {
                    'living room' => {
                        comment => 'Back to the warmth',
                        destination => 'living_room',
                    },
                    down => {
                        comment => 'Down below we go.',
                        destination => 'basement',
                    },
                },
                clues => [
                    q{How much wood could a woodchuck not chuck with that hammer?},
                ],
            },
            {
                id => 'basement',
                intro => stomp qs{
                    The basement is darkly lit. In the middle of the room is a table and two chairs. 
                    A single piece of paper lies on the table. A pencil too.

                    "Lets play tic-tac-toe", says Guybrush.
                },
                navigate => {
                    'tic-tac-toe' => {
                        comment => 'Not again, you think. "Okay", you say as you sit down to yet another match.',
                        destination => 'tic',
                    },
                    up => {
                        comment => 'Lets go up again',
                        destination => 'stair',
                    },
                    'bigger room' => {
                        comment => 'Ok.',
                        destination => 'cellar',
                    },
                },
                clues => [
                    'There is something strange with the table.',
                    'You might want to play a game of tic-tac-toe.',
                ],
            },
            {
                id => 'cellar',
                intro => stomp qs{
                    It is a large wine cellar, old bottles lining the walls from floor to ceiling. There is no source
                    of lightning in the room.

                    There is a black door to your right.

                    An old man sits in a chair.
                },
                actions => {
                    look => q{It is not the coziest of cellars.},
                    say => [
                        {
                            what => 'Ishmael',
                            comment => stomp qs{
                                A moment of silence, and then:

                                "Yes! That is it! I have been solving this crossword for ten years. We used to have the book
                                in the house but I have not been able to find it."

                                With a sweeping motion of his red right hand, he adds:

                                "By the way, look at my work and despair".

                                Now you see that the bottles along the walls are not wine bottles, they are magic potions.

                                And not of the good kind.
                            },
                            removes => {
                                living_room => ['bars'],
                            },
                            reveals => {
                                living_room => ['laughter'],
                            },
                        },
                    ],
                },
                navigate => {
                    back => {
                        comment => 'Ok.',
                        destination => 'basement',
                    },
                    'black door' => {
                        comment => 'Ok.',
                        destination => 'crypt',
                    },
                },
                clues => [
                    'Have you talked to the old man?',
                    q{Don't take everything literally.},
                ],
            },
            {
                id => 'crypt',
                intro => stomp qs{
                    You have entered a small crypt. There is an altar, a couple of benches and some icons on the walls.
                },
                navigate => {
                    back => {
                        comment => 'Ok.',
                        destination => 'cellar',
                    },
                },
                clues => [
                    q{There's more than one way to skin a cat -- or in this case do something about that rope.},
                    q{Have you seen anything sharp in the house?},
                ],
            },
            {
                id => 'garden',
                intro => stomp qs{
                    It is a beautiful garden, but after what just happened you do not feel comfortable.

                    You reach the end of the garden where there is a high wall made of ice.
                },
                navigate => {
                    inside => {
                        comment => 'Ok.',
                        destination => 'living_room',
                    },
                    forest => {
                        comment => 'Ok.',
                        destination => 'forest',
                    },
                },
                clues => [
                    q{Some tools are made for drinking, others for climbing.},
                ],
            },
            {
                id => 'forest',
                intro => stomp qs{
                    With the ice wall behind you, you and Guybrush run toward civilization.

                    You reach an old bridge over a fast river. An odd fellow with a wide brimmed hat, a grey coat
                    and a walking stick stands guard in the middle of the bridge.

                    "You shall not pass!", he growls with a voice as cold as ice.
                },
                navigate => {
                    garden => {
                        comment => 'Ok.',
                        destination => 'garden',
                    },
                    town => {
                        comment => 'Ok.',
                        destination => 'town',
                    },
                },
                clues => [
                    q{Guards often want something.},
                ],
            },
            {
                id => 'town',
                intro => stomp qs{
                    You and Guybrush strolled merrily into town and found your friend the mayor, Elaine, sitting outside a café.
                },
            },
        ],
        objects =>  [
            # path_branch
            {
                id => 'left-path',
                name => 'left path',
                actions => {
                    look => q{That is one nice path.},
                },
            },
            {
                id => 'right-path',
                name => 'right path',
                actions => {
                    look => q{That is one nice path.},
                },
            },
            {
                id => 'arrow-sign',
                name => 'arrow',
                text => {
                    original => stomp qs{
                                Once, an arrow-shaped sign on a post had pointed to one of the paths, but a
                                spike has come loose and the arrow now points straight down.
                    },
                    dropped => q{An arrow-shaped piece of wood lies on the ground. It looks somewhat familiar.},
                },
                actions => {
                    look => q{It is an arrow-shaped piece of wood with an old spike through it.},
                    pickup => {
                        comment => q{Might come in handy.},
                    },
                    move => {
                        comment => q{It spins once, and then return to its original position.},
                    },
                    kick => {
                        comment => q{It spins twice, and then return to its original position.},
                    }
                },
            },
            # little_house
            {
                id => 'bucket',
                name => 'bucket',
                text => {
                    original => q{There is a bucket of water by the door.},
                    dropped => q{Someone has put a bucket of water here.},
                },
                actions => {
                    look => q{It's your standard bucket. Filled with clear and cold water.},
                    pickup => {
                        comment => q{Who doesn't want to carry around a bucket of water?},
                    },
                    kick => {
                        comment => q{"Why did you do that? Now I need to fill it again", the woman says.},
                    },
                    use => [
                        {
                            with => 'table',
                            comment => q{The table slowly receeds into the floor. Part of the back wall is tilted upwards and reveals a bigger room.},
                            added_navigation => ['bigger room'],
                            removes => { inventory => ['bucket'] },
                        },
                    ],
                },
            },
            {
                id => 'young-woman',
                name => 'young woman',
                actions => {
                    look => q{She is a young woman.},
                    talk => {
                        comment => stomp qs{
                            "Hi!", you say.

                            "The weather is turning bad. Come in", she says, "I'll give you shelter from the storm."
                        },
                        added_navigation => ['inside'],
                    },
                    kick => {
                        comment => q{That I will not do.},
                    },
                },
            },
            # living_room
            {
                id => 'locked-red-door',
                name => 'locked red door',
                text => {
                    original => q{There is the opening back to the hall from whence you came, and a closed, red door in the opposite end of the room.},
                },
                actions => {
                    look => q{It's a locked door},
                    move => {
                        comment => q{It's locked!},
                    },
                    kick => {
                        comment => q{Ow! That hurt.},
                    },
                },
            },
            {
                id => 'unlocked-red-door',
                name => 'unlocked red door',
                text => {
                    original => q{There is the opening back to the hall from whence you came, and an open, red door in the opposite end of the room.},
                },
                actions => {
                    look => q{It's an unlocked door},
                    move => {
                        comment => q{I can't. It is stuck open.},
                    },
                    kick => {
                        comment => q{There's no use kicking in open doors.},
                    },
                },
            },
            {
                id => 'sword',
                name => 'sword',
                text => {
                    original => q{On the mantlepiece, a sword is on display.},
                    dropped => q{A nice sword lies abandoned on the ground.},
                },
                actions => {
                    look => q{Its a beautiful sword. Written on the handle is the name Damocles.},
                    pickup => {
                        comment => q{I'm not sure if the lady of the house appreciates this, but I like it.},
                    },
                    move => {
                        comment => q{I should either pick it up or leave it be.},
                    },
                    use => [
                        {
                            with => 'rope',
                            reveals => {
                                crypt => ['candle', 'broken-chandelier'],
                            },
                            removes => {
                                inventory => ['sword'],
                                crypt => ['chandelier'],
                            },
                            comment => stomp qs{
                                The chandelier crashes to the floor with a bang, only one candle is still lit. The sword gets
                                tangled up in the rope and now hangs, pointy end down, from the ceiling. Out of reach.
                            },
                        },
                    ],
                },
            },
            {
                id => 'leather-sofa',
                name => 'leather sofa',
                text => {
                    original => q{A leather sofa is opposite the fireplace.},
                },
                actions => {
                    look => q{I could sit in that sofa all day, listening to the fire and the rain outside.},
                    move => {
                        comment => q{That is one heavy sofa. Someone has dropped a book under it.},
                        reveals => { living_room => ['book'] },
                    },
                }
            },
            {
                id => 'book',
                name => 'book',
                text => {
                    original => q{There's a book next to the sofa.},
                    dropped => q{A book lies on the ground. That's no place for a book.},
                },
                actions => {
                    look => q{Moby Dick, by Herman Melville.},
                    move => { comment => q{Sure, I can do that.} },
                    kick => { commennt => q{Sure, I can do that.} },
                    open => {
                        comment => stomp qs{
                                "Call me Ishmael!"; well, that is one way to start a book. Not sure what
                                that has to do with whales.
                        },
                    },
                    pickup => {
                        comment => stomp qs{
                            Some books are to be tasted, others to be swallowed, and some few
                            to be chewed and digested. I wonder which type this book is.
                        },
                    },
                },
            },
            {
                id => 'window',
                name => 'window',
                text => {
                    original => q{There is a window to the right of the fire place.},
                },
                actions => {
                    look => q{Through the window you see a beautiful garden.},
                    open => { comment => q{That is not possible.} },
                    kick => {
                        when => { removed => 'bars' },
                        else => {
                            comment => q{No use with the bars in the way.},
                        },
                        comment => q{The window breaks completely.},
                        added_navigation => ['garden'],
                    },
                },
            },
            {
                id => 'bars',
                name => 'bars',
                text => {
                    original => q{Bars on the outside of the window protect the house from burglars.},
                },
                actions => {
                    look => q{The bars can only be opened from the outside.},
                },
            },
            {
                id => 'laughter',
                name => 'laughter',
                text => {
                    original => q{An evil laughter echoes from somewhere in the house.},
                },
            },
            # hall
            {
                id => 'key-locker',
                name => 'key locker',
                text => {
                    original => q{There is a small key locker next to the door.},
                },
                actions => {
                    open => {
                        comment => q{Can't hurt to see what's inside the key locker.},
                        reveals => { hall => ['small-key'] },
                    },
                    look => q{A key locker, made for keys},
                    move => { comment => q{It doesn't move.} },
                    kick => { comment => q{Can't reach it with my foot.} },
                },
            },
            {
                id => 'small-key',
                name => 'small key',
                text => {
                    original => q{A small key hangs on a hook in the key locker},
                    dropped => q{A small key lies on the ground. That's a strange thing to drop.},
                },
                actions => {
                    look => q{It's a simple key.},
                    pickup => {
                        comment => q{A key can always come in handy.},
                    },
                    use => [
                        {
                            with => 'locked-red-door',
                            reveals => { living_room => ['unlocked-red-door'] },
                            removes => { living_room => ['locked-red-door'] },
                            comment => q{That worked! The door is now open.},
                            added_navigation => ['open red door'],
                        },
                    ],
                },
            },
            # stair
            {
                id => 'hammer',
                name => 'hammer',
                text => {
                    dropped => 'Leaving a hammer lying around. Who does that, really?',
                },
                actions => {
                    pickup => {
                        comment => q{I think that is a wise choice.},
                    },
                    look => q{If I had such a hammer, I could hammer all morning.},
                    use => [
                        {
                            with => 'ice-wall',
                            comment => stomp qs{
                                Ah, the hammer works nicely as an ice axe.

                                You reach the top of the wall in no time at all.
                            },
                            added_navigation => ['forest'],
                        },
                    ],
                },
            },
            {
                id => 'screwdriver',
                name => 'screwdriver',
                text => {
                    dropped => q{A screwdriver on the ground. Think of the children.},
                },
                actions => {
                    pickup => {
                        comment => q{I've always had a screw loose. Now I can fix that.},
                    },
                    look => q{An average looking screwdriver},
                    use => [
                        {
                            with => 'old-man',
                            removes => { inventory => ['screwdriver'] },
                            reveals => { inventory => ['gold-coin'] },
                            comment => q{"Thank you!", he gleams. "Here, take this gold coin. Can you get me a candle so I can solve my crossword?"},
                        },
                    ],
                },
            },
            # basement
            {
                id => 'table',
                name => 'table',
                actions => {
                    look => q{It's a table. Something funny about it, though.},
                    move => {
                        comment => q{It budges a bit, but returns to its original position.},
                    },
                },
            },
            # cellar
            {
                id => 'old-man',
                name => 'old man',
                actions => {
                    look => q{Looks like he's been here a while.},
                    talk => {
                        comment => stomp qs{
                            "How are you?", you ask politely.
    
                            "Gimme a drink, will ya!", he says grumpily.
                        },
                    },
                },
            },
            {
                id => 'gold-coin',
                name => 'gold coin',
                actions => {
                    look => q{Strange, the face of the coin looks just like you.},
                    use => [
                        {
                            with => 'guard',
                            added_navigation => ['town'],
                            comment => stomp qs{
                                "Well, thank you!", he says with his demeanor changed for the better, "five minutes to town."
                            }
                        },
                    ],
                },
            },
            # crypt
            {
                id => 'rope',
                name => 'rope',
                actions => {
                    look => q{That is one thick rope. And it is tied down with a Gordian knot, I can not untie that.},
                    move => {
                        comment => q{It doesn't move much.},
                    },
                    kick => {
                        comment => q{I'd just hurt myself.},
                    },
                },
            },
            {
                id => 'chandelier',
                name => 'chandelier',
                text => {
                    original => q{A lit chandelier is elevated by a thick rope tied to a ring fastened in the wall.},
                },
                actions => {
                    look => q{A beautiful chandelier hanging in the air.},
                    move => {
                        comment => q{Can't reach it.},
                    },
                },
            },
            {
                id => 'broken-chandelier',
                name => 'broken chandelier',
                text => {
                    original => q{A chandelier lies haphazardly on the floor, broken in two.},
                },
                actions => {
                    look => q{The once beautiful chandelier is now broken on the floor.},
                },
            },
            {
                id => 'candle',
                name => 'candle',
                actions => {
                    look => q{A burning candle.},
                    pickup => {
                        comment => q{Ow! It burns, but ok.},
                    },
                    kick => {
                        comment => q{I don't want to burn down the house.},
                    },
                    move => {
                        comment => q{I see no point, but ok.},
                    },
                    use => [
                        {
                            with => 'old-man',
                            removes => { inventory => ['candle'] },
                            comment => stomp qs{
                                "Thank you! I only have one thing left in my crossword. 'The protagonist
                                of Moby Dick, seven letters, _ _ H _ _ _ _', do you know it?",
                            },
                        },
                    ],
                },
            },
            # garden
            {
                id => 'ice-wall',
                name => 'ice wall',
                actions => {
                    look => q{An ice wall in the middle of summer. What dark forces lives here?},
                    move => {
                        comment => 'Sure...',
                    },
                    kick => {
                        comment => 'Yeah, right.',
                    },
                },
            },
            # forest
            {
                id => 'guard',
                name => 'guard',
                actions => {
                    look => q{He is a little bit grumpy.},
                    kick => { comment => q{That won't make him let us pass.} },
                    move => { comment => q{He is one big fellow. That won't work.} },
                }
            },
            # town
            {
                id => 'Elaine',
                name => 'Elaine',
                actions => {
                    look => q{It's your good friend Elaine, mayor of the town.},
                    talk => {
                        comment => stomp qs{
                            "Hi Elaine! Me and Guybrush were out in the woods today. We took a less
                            travelled path", you say with a sigh, "and that made all the difference. Who 
                            knows in what kind of trouble we would have ended up if we had taken the 
                            other path."

                            "Tell me all about it!", Elaine says.

                            "Well, we went out this morning and found ourselves twenty miles out of town..."
                        },
                        the_end => 1,
                    }
                }
            }
        ],
    };

    my $saved_game_default = {
        room => 'path_branch',
        inventory => [],
        objects_in_room => {
            path_branch => ['arrow-sign', 'left-path', 'right-path'],
            little_house => ['bucket', 'young-woman'],
            living_room => ['leather-sofa', 'sword', 'locked-red-door', 'window', 'bars'],
            hall => ['key-locker'],
            stair => ['hammer', 'screwdriver'],
            basement => ['table'],
            cellar => ['old-man'],
            crypt => ['rope', 'chandelier'],
            garden => ['ice-wall'],
            forest => ['guard'],
            town => [],
        },
        added_to_room => {
            path_branch => [],
            little_house => [],
            living_room => [],
            hall => [],
            stair => [],
            basement => [],
            cellar => [],
            crypt => [],
            garden => [],
            forest => [],
            town => [],
        },
        possible_navigation => {
            path_branch => ['left', 'right'],
            little_house => [],
            living_room => ['hall'],
            hall => ['living room', 'outside'],
            stair => ['living room', 'down'],
            basement => ['up', 'tic-tac-toe'],
            cellar => ['back', 'black door'],
            crypt => ['back'],
            garden => ['inside'],
            forest => ['garden'],
            town => [],
        }
    };
    my $json = JSON::MaybeXS->new(pretty => 1);
    path('gamedata.json')->spew($json->encode($data));
    path('save_game_default.json')->spew($json->encode($saved_game_default));

    say 'done.';
}
