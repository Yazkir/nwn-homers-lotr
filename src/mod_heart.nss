/////////////////////////////////////////////////////////////////////////////
// Weapon Warning Script                                                   //
// written by bigbluepaw @ NeverwinterConnections                          //
// bigbluepaw@yahoo.com                                                    //
/////////////////////////////////////////////////////////////////////////////

#include "_inc_itemwarning"
void main()
{
//****************************************************************************
//              item tag,      racial type,       distance,   visual effect
WarnRaceNearby( "item_tag", RACIAL_TYPE_HUMANOID_ORC,          5.0, ITEM_VISUAL_ACID);
WarnRaceNearby( "item_tag", RACIAL_TYPE_GIANT,        5.0, ITEM_VISUAL_FIRE);
WarnRaceNearby( "item_tag", RACIAL_TYPE_OUTSIDER,     5.0, ITEM_VISUAL_HOLY);
//****************************************************************************
/*
OVERVIEW OF THE SCRIPT
----------------------
This script enables a weapon to show a visual effect once it is in within a
certain distance of a certain race of critter.

INSTALLATION
------------
From the top level menu, select Edit > Module Properties. Once in the 'Module
Properties' dialog box, selec the 'Events' tab. In the OnHeartbeat script slot,
select this script... _oh_itemwarning.

USAGE
-----
This script is the 'configuration' script. All the information that needs to
be changed for your application resides in the single script. Basically a new
line needs to be added for each unique combination of a specific item,
specific racial type, specific distance and specific item visual effect.

EXAMPLE #1
--------
WarnRaceNearby( "glanx", RACIAL_TYPE_HUMANOID_ORC, 45.0,  ITEM_VISUAL_ACID,);
WarnRaceNearby( "glanx", RACIAL_TYPE_GIANT,        15.0,  ITEM_VISUAL_FIRE,);
WarnRaceNearby( "glanx", RACIAL_TYPE_UNDEAD,       100.0, ITEM_VISUAL_HOLY,);

In this example, a single melee weapon with the tag "glanx" will react to
three different racial types. It will make a melee weapon drip acid if it
is within 45 feet of an orc. Likewise, this same melee weapon will burst
into flame once within 15 feet of a giant. Finally, this same sword will
gain a holy light once within 100 feet of undead.

EXAMPLE #2
--------
WarnRaceNearby( "airward", RACIAL_TYPE_HUMANOID_ORC, 5.0,  ITEM_VISUAL_SONIC,);
WarnRaceNearby( "bounder", RACIAL_TYPE_ANIMAL,       15.0, ITEM_VISUAL_EVIL,);
WarnRaceNearby( "hierfy",  RACIAL_TYPE_OUTSIDER,     50.0, ITEM_VISUAL_COLD,);

In this example, a three different melee weapons will have three different
effects around three different types of critters. A melee weapon with the
tag of "airward" will visually vibrate once within 5.0 feet of an orc. A
melee weapon with the tag of "bounder" will radiate a reddish evil glow
once within 15.0 feet of an animal. Finally a melee weapon with the tag
"hierfy" once within 50.0 feet of a demon or devil will grow so cold,
humidity will ice on it and fall off.

LIMITATIONS
-----------
The following limitations apply.
* This works only for melee weapons
* It is limited to the racial types defined in the  script editor.
* It is limited to the item visual effects defined in the  the script editor.

EXPLANATION OF VARIABLES
------------------------
This section describes each of the variables in the above custom function.
It covers the format and how it is used.

item tag
--------
This is the tag of the weapon you want to show the visual effect. It must be
placed in quotations because it is a string variable type. To customize this,
it is best to copy the tag from the item properties page and paste it into
this script directly.

racial type
-----------
This is the racial type that, if the PC is holding the item and within the
distance specified, will cause the item to gain the visual effect specified.
To customize this, it is best to highlight the entire constant
(RACIAL_TYPE_HUMAOIND_ORC in the template's case), then click on
the constants button and type in RACIAL_TYPE. This will show you all the
options that can be used. If you double-click it will then replace the value.

Likewise you can copy it from here.

RACIAL_TYPE_ABERRATION
RACIAL_TYPE_ANIMAL
RACIAL TYPE_BEAST
RACIAL_TYPE_CONSTRUCT
RACIAL_TYPE_DRAGON
RACIAL_TYPE_DWARF
RACIAL_TYPE_ELEMENTAL
RACIAL_TYPE_ELF
RACIAL_TYPE_FEY
RACIAL_TYPE_GIANT
RACIAL_TYPE_GNOME
RACIAL_TYPE_HALFELF
RACIAL_TYPE_HALFLING
RACIAL_TYPE_HALFORC
RACIAL_TYPE_HUMAN
RACIAL_TYPE_HUMANOID_GOBLINOID
RACIAL_TYPE_HUMANOID_MONSTROUS
RACIAL_TYPE_HUMANOID_ORC
RACIAL_TYPE_HUMANOID_REPTILIAN
RACIAL_TYPE_MAGICAL_BEAST
RACIAL_TYPE_OUTSIDER
RACIAL_TYPE_SHAPECHANGER
RACIAL_TYPE_UNDEAD
RACIAL_TYPE_VERMIN

distance
--------
This is the distance used to check for the item. If a critter with the
racial type is within in that distance, it will gain the visual effect
specified. The format is to the tenth such as XX.X. Without this format
the script will not run.

visual effect
-------------
This is the visual effect gained with a critter with the racial type is
within the distance specified. To customize this, it is best to highlight
the entire constant (ITEM_VISUAL_ACID in the template's case), then click on
the constants button and type in ITEM_VISUAL. This will show you all the
options that can be used. If you double-click it will then replace the value.

Likewise you can copy it from here.
ITEM_VISUAL_ACID
ITEM_VISUAL_COLD
ITEM_VISUAL_ELECTRICAL
ITEM_VISUAL_EVIL
ITEM_VISUAL_FIRE
ITEM_VISUAL_HOLY
ITEM_VISUAL_SONIC
*/
}
