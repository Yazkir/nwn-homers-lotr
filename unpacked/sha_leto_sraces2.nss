//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::: Shayan's Subrace Engine :::::::::::::::::::::::::::::
//:::::::::::::::::File Name: sha_leto_sraces2 ::::::::::::::::::::::::::::::::::::
//::::::::::::::::::::: OnModuleLoad script ::::::::::::::::::::::::::::::::::::
//:: Written By: Shayan.
//:: Contact: mail_shayan@yahoo.com
//
// Description: This script holds the pre-made 'wacky' subraces. These sub-races
//              are either planar or monsterous. These include things like:
//              Ogre, Illithid, Pixies... just to name a few.
//              This script is the Leto equivalent of sha_subraces2.
//              It will give players permanent ability scores,feats, etc rather than
//              as a bonus from skin/creature hide. It may also contain added benefits like
//              wings.



#include "sha_subr_methds"
void main()
{




//:::::::::::::::::::::::::::::::::
//:::: SUBRACE: Human - Illithid ::
//:::::::::::::::::::::::::::::::::

//Subrace Name: Illithid.

//Properties from the Skin:
    //AC Bonus +3

    //Immunity: Miscellaneous: Mind-Affecting Spells

//Abilities from the unique item:
    //Cast Spell: Charm Monster (10) 1 Use/Day
    //Cast Spell: Charm Person (10) 1 Use/Day

//Must be Human, and is light sensitive.
//ECL: + 2
   CreateSubrace(RACIAL_TYPE_HUMAN, "illithid", "sha_pcl_illithid", "sha_subrace_illi", TRUE, 0, FALSE, 0, 3);

//LETO - Change ability scores:
    //Ability Bonus: Charisma +2
    //Ability Bonus: Constitution -4
    //Ability Bonus: Dexterity +4
    //Ability Bonus: Intelligence +8
    //Ability Bonus: Strength +2
    //Ability Bonus: Wisdom +4
    struct SubraceBaseStatsModifier IllithidStats = CustomBaseStatsModifiers(2, 4, -4, 8, 4, 2, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier("illithid", IllithidStats, 1);

//LETO - Feats:
    //Darkvision
    ModifySubraceFeat("illithid", FEAT_DARKVISION, 1);

//Lawful Evil Only
   CreateSubraceAlignmentRestriction("illithid", FALSE, FALSE, TRUE, TRUE, FALSE, FALSE);

//Favored Class: Male: Wizard, Female: Wizard.
   AddSubraceFavoredClass("illithid", CLASS_TYPE_WIZARD, CLASS_TYPE_WIZARD);

//Can only be Monk, Cleric or Wizard
   CreateSubraceClassRestriction("illithid", FALSE, FALSE, TRUE, FALSE, FALSE, TRUE, FALSE, FALSE,  FALSE, FALSE, TRUE);

//Spell Resistance: Base: 25, Max: 65.  (25 + 1 per level)
   CreateSubraceSpellResistance("illithid", 25, 65);

//Appearance is permanently changed to Mind flayers (male is different from female)
   CreateSubraceAppearance("illithid", TIME_BOTH, APPEARANCE_TYPE_MINDFLAYER, APPEARANCE_TYPE_MINDFLAYER_2);













//:::::::::::::::::::::::::::::::::::
//:::: SUBRACE: Dwarf - Azer ::::::::
//:::::::::::::::::::::::::::::::::::

//Subrace Name: Azer

//Properties from the Skin:
    //AC Bonus +6
    //Damage Vulnerability: Cold 50% Damage Vulnerability
    //Immunity: Damage Type: Fire 100% Immunity Bonus

//Must be: Dwarf
//ECL: + 3
     CreateSubrace(RACIAL_TYPE_DWARF, "azer", "sha_pcl_azer", "", FALSE, 0, FALSE, 0, 3);

//LETO - Change ability scores:
    //Ability Bonus: Constitution +2
    //Ability Bonus: Dexterity +2
    //Ability Bonus: Intelligence +2
    //Ability Bonus: Strength +2
    //Ability Bonus: Wisdom +2
    struct SubraceBaseStatsModifier AzerStats = CustomBaseStatsModifiers(2, 2, 2, 2, 2, 0, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier("azer", AzerStats, 1);

//LETO - Feats:
    //Darkvision
    ModifySubraceFeat("azer", FEAT_DARKVISION, 1);

//Appearance: Azer - Permanent.
     CreateSubraceAppearance("azer", TIME_BOTH, APPEARANCE_TYPE_AZER_MALE, APPEARANCE_TYPE_AZER_FEMALE);

//Spell Resistance: 13 + 1 Per Level.
     CreateSubraceSpellResistance("azer", 13, 53);










//:::::::::::::::::::::::::::::::::::::::
//:::: SUBRACE: Halfling - Pixie ::::::::
//:::::::::::::::::::::::::::::::::::::::

//Subrace Name: Pixie

//Properties from the Skin:
    //AC Bonus +1
    //Damage Reduction: +1 Soak 5 Damage


//Abilities from the unique item:
    //Cast Spell: Confusion (10) 1 Use/Day
    //Cast Spell: Entangle (5) 1 Use/Day
    //Cast Spell: Invisibility (3) 1 Use/Day
    //Cast Spell: Lesser Dispel (5) 1 Use/Day
    //Cast Spell: Polymorph Self (7) 1 Use/Day


//Must be: Halfling.
//ECL: +3
    CreateSubrace(RACIAL_TYPE_HALFLING, "pixie", "sha_pcl_pixie", "sha_subrace_pixi", FALSE, 0, FALSE, 0, 3);


//LETO - Change ability scores:
    //Ability Bonus: Charisma +6
    //Ability Bonus: Dexterity +8
    //Ability Bonus: Intelligence +6
    //Ability Bonus: Wisdom +4
    //Decreased Ability Score: Constitution -4
    //Decreased Ability Score: Strength -4
    //Movement Speed: Fast
    struct SubraceBaseStatsModifier PixieStats = CustomBaseStatsModifiers(-4, 8, -4, 6, 4, 6, MOVEMENT_SPEED_FAST);
    CreateBaseStatModifier("pixie", PixieStats, 1);


//LETO - Feats:
    //Darkvision
    //Bonus Feat: Dodge
    ModifySubraceFeat("pixie", FEAT_DARKVISION, 1);
    ModifySubraceFeat("pixie", FEAT_DODGE, 1);


//Alignment Restriction: Neutral Only.
    CreateSubraceAlignmentRestriction("pixie", FALSE, TRUE, FALSE);

//Class Restriction: Can only be either: Bard, Rogue, Sorcerer or Wizard.
    CreateSubraceClassRestriction("pixie", FALSE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, TRUE);

//Favored Class: Sorcerer.
    AddSubraceFavoredClass("pixie", CLASS_TYPE_SORCERER, CLASS_TYPE_SORCERER);

//Appearance Change: Permanent - Pixie
    CreateSubraceAppearance("pixie", TIME_BOTH, APPEARANCE_TYPE_FAIRY, APPEARANCE_TYPE_FAIRY);

//Effect: Visual Effect - Fairy Dust.
    AddSubraceEffect("pixie", EFFECT_TYPE_VISUALEFFECT, VFX_DUR_PIXIEDUST, FALSE, DURATION_TYPE_PERMANENT, 0.0, TIME_BOTH);

//Spell Resistance: Base (at Level 1): 15, Max(at Level 40): 55.
   CreateSubraceSpellResistance("pixie", 15, 55);

//Can only use tiny weapons.
   SubraceRestrictUseOfWeaponsOfType("pixie", SUBRACE_RESTRICTION_WEAPON_TINY, TIME_BOTH, TRUE);

//Can only wear clothing. Can't use any shields.
   SubraceRestrictUseOfArmourAndShieldsOfType("pixie", SUBRACE_RESTRICTION_DEFENSE_CLOTHING, TIME_BOTH, TRUE);






//:::::::::::::::::::::::::::::::::::::::
//:::: SUBRACE: Half-Orc - Ogre :::::::::
//:::::::::::::::::::::::::::::::::::::::

//Subrace Name: Ogre

//Properties from the Skin:
    //AC Bonus +5



//Must be:  Half-Orc
//ECL: + 2
     CreateSubrace(RACIAL_TYPE_HALFORC, "ogre", "sha_pcl_ogre", "", FALSE, 0, FALSE, 0, 2);

//LETO - Change ability scores:
    //Ability Bonus: Constitution +4
    //Ability Bonus: Strength +6
    //Decreased Ability Score: Charisma -4
    //Decreased Ability Score: Dexterity -2
    //Decreased Ability Score: Intelligence -4
    struct SubraceBaseStatsModifier OgreStats = CustomBaseStatsModifiers(6, -2, 4, -4, 0, -4, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier("ogre", OgreStats, 1);

//LETO - Feats:
    //Darkvision
    //Bonus Feat: Armor Proficiency (light)
    //Bonus Feat: Armor Proficiency (medium)
    //Bonus Feat: Shield Proficiency
    //Bonus Feat: Weapon Proficiency (martial)
    //Bonus Feat: Weapon Proficiency (simple)
    ModifySubraceFeat("ogre", FEAT_DARKVISION, 1);
    ModifySubraceFeat("ogre", FEAT_ARMOR_PROFICIENCY_LIGHT, 1);
    ModifySubraceFeat("ogre", FEAT_ARMOR_PROFICIENCY_MEDIUM, 1);
    ModifySubraceFeat("ogre", FEAT_SHIELD_PROFICIENCY, 1);
    ModifySubraceFeat("ogre", FEAT_WEAPON_PROFICIENCY_MARTIAL, 1);
    ModifySubraceFeat("ogre", FEAT_WEAPON_PROFICIENCY_SIMPLE, 1);

//LETO - Skills:
    //Decreased Skill Modifier: Move Silently -5
    //Decreased Skill Modifier: Hide -8
    ModifySubraceSkill("ogre", SKILL_HIDE, -8, 1, FALSE);
    ModifySubraceSkill("ogre", SKILL_MOVE_SILENTLY, -5, 1, FALSE);

//Alignment Restriction - Cannot be Lawful.
     CreateSubraceAlignmentRestriction("ogre", TRUE, TRUE, TRUE, FALSE);

//Appearance: Ogre - Permanent.
     CreateSubraceAppearance("ogre", TIME_BOTH, APPEARANCE_TYPE_OGRE_CHIEFTAIN, APPEARANCE_TYPE_OGREB);

//Can't use any Tiny weapons (Too big to hold them!!)
    SubraceRestrictUseOfWeaponsOfType("ogre", SUBRACE_RESTRICTION_WEAPON_TINY, TIME_BOTH);







//:::::::::::::::::::::::::::::::::::::::
//:::: SUBRACE: Half-Orc - Troll ::::::::
//:::::::::::::::::::::::::::::::::::::::

//Subrace Name: Troll

//Properties from the Skin:
    //AC Bonus +4
    //Regeneration +3
    //Decreased Skill Modifier: Hide -8
    //Decreased Skill Modifier: Move Silently -5

//Must be: Half-Orc
//ECL: + 2
    CreateSubrace(RACIAL_TYPE_HALFORC, "troll", "sha_pcl_troll","", FALSE, 0, FALSE, 0, 2);

//LETO - Change ability scores:
    //Ability Bonus: Constitution +6
    //Ability Bonus: Strength +6
    //Decreased Ability Score: Charisma -4
    //Decreased Ability Score: Intelligence -4
    //Decreased Ability Score: Wisdom -2
    struct SubraceBaseStatsModifier TrollStats = CustomBaseStatsModifiers(6, 0, 6, -4, -2, -4, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier("troll", TrollStats, 1);

//LETO - Feats:
    //Darkvision
    ModifySubraceFeat("troll", FEAT_DARKVISION, 1);

//LETO - Skills:
    //Decreased Skill Modifier: Move Silently -5
    //Decreased Skill Modifier: Hide -8
    ModifySubraceSkill("troll", SKILL_HIDE, -8, 1, FALSE);
    ModifySubraceSkill("troll", SKILL_MOVE_SILENTLY, -5, 1, FALSE);

//Appearance: Troll - Permanent.
     CreateSubraceAppearance("troll", TIME_BOTH, APPEARANCE_TYPE_TROLL_CHIEFTAIN, APPEARANCE_TYPE_TROLL_SHAMAN);

//Can't use any Tiny weapons (Too big to hold them!!)
    SubraceRestrictUseOfWeaponsOfType("troll", SUBRACE_RESTRICTION_WEAPON_TINY, TIME_BOTH);

//Favored Class: Fighter.
    AddSubraceFavoredClass("troll", CLASS_TYPE_FIGHTER, CLASS_TYPE_FIGHTER);










//:::::::::::::::::::::::::::::::::::::::
//:::: SUBRACE: Halfling - Bugbear ::::::
//:::::::::::::::::::::::::::::::::::::::

//Subrace Name: Bugbear.

//Properties from the Skin:
    //AC Bonus +3

//Must be: Halfling.
//ECL: + 1
     CreateSubrace(RACIAL_TYPE_HALFLING, "bugbear", "sha_pcl_bugbear", "", FALSE, 0 , FALSE, 0, 1);

//LETO - Change ability scores:
    //Ability Bonus: Constitution +2
    //Ability Bonus: Strength +4
    //Decreased Ability Score: Charisma -2
    struct SubraceBaseStatsModifier BugbearStats = CustomBaseStatsModifiers(4, 0, 2, 0, 0, -2, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier("bugbear", BugbearStats, 1);

//LETO - Feats:
    //Darkvision
    //Bonus Feat: Armor Proficiency (light)
    //Bonus Feat: Shield Proficiency
    //Bonus Feat: Weapon Proficiency (simple)
    ModifySubraceFeat("bugbear", FEAT_DARKVISION, 1);
    ModifySubraceFeat("bugbear", FEAT_ARMOR_PROFICIENCY_LIGHT, 1);
    ModifySubraceFeat("bugbear", FEAT_SHIELD_PROFICIENCY, 1);
    ModifySubraceFeat("bugbear", FEAT_WEAPON_PROFICIENCY_SIMPLE, 1);

//Apearance: Bugbear - Permanent.
    CreateSubraceAppearance("bugbear", TIME_BOTH, APPEARANCE_TYPE_BUGBEAR_CHIEFTAIN_A, APPEARANCE_TYPE_BUGBEAR_A);









//:::::::::::::::::::::::::::::::::::::::
//:::: SUBRACE: Halfling - Goblin :::::::
//:::::::::::::::::::::::::::::::::::::::

//Subrace Name: Goblin

//Must be: Halfling.
      CreateSubrace(RACIAL_TYPE_HALFLING, "goblin");

//LETO - Change ability scores:
    //Decreased Ability Score: Charisma -2
    struct SubraceBaseStatsModifier GoblinStats = CustomBaseStatsModifiers(0, 0, 0, 0, 0, -2, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier("goblin", GoblinStats, 1);

//LETO - Feats:
    //Darkvision
    ModifySubraceFeat("goblin", FEAT_DARKVISION, 1);

//Apearance: Goblin - Permanent.
      CreateSubraceAppearance("goblin", TIME_BOTH, APPEARANCE_TYPE_GOBLIN_CHIEF_A, APPEARANCE_TYPE_GOBLIN_A);











//::::::::::::::::::::::::::::::::::::
//::::: SUBRACE: Undead - Lich :::::::
//::::::::::::::::::::::::::::::::::::

//This is an example of how you can equip different skins on Players at different level.
//So that you do not necessarily have to give all subrace feats at once.


//Subrace Name: Lich

//Properties from the Skin:
    //Level 1:
        //Damage Reduction: +1 Soak 15 Damage
        //Turn Resistance +4
        //Immunity: Damage Type: Cold 100% Immunity Bonus
        //Immunity: Damage Type: Electrical 100% Immunity Bonus

    //Level 5:
        //Gains - Immunity: Miscellaneous: Disease

    //Level 10:
        //Gains - Immunity: Miscellaneous: Poison

    //Level 15:
        //Gains - Immunity: Miscellaneous: Paralysis

    //Level 20:
        //Gains - Immunity: Miscellaneous: Level/Ability Drain

    //Level 25:
        //Gains - Immunity: Miscellaneous: Mind-Affecting Spells

    //Level 30:
        //Gains - Immunity: Miscellaneous: Death Magic

    //Level 35:
        //Gains - Immunity: Miscellaneous: Sneak Attack

    //Level 40:
        //Gains - Immunity: Miscellaneous: Critical Hits


//Abilities from the unique item:
    //Cast Spell: Destruction (13) 1 Use/Day
    //Cast Spell: Vampiric Touch (5) 1 Use/Day

//Human. Light Sensitive. Takes 4 Divine Damage While in Sunlight.
//ECL: + 3
//Undead
    CreateSubrace(RACIAL_TYPE_HUMAN, "lich", "sha_pcl_lich", "sha_subrace_lich", TRUE, 4, FALSE, 0, 3, TRUE);


//LETO - Change ability scores:
    //Level 1:
        //Ability Bonus: Charisma +2
        //Ability Bonus: Intelligence +2
        //Ability Bonus: Wisdom +2
    struct SubraceBaseStatsModifier LichStats = CustomBaseStatsModifiers(0, 0, 0, 2, 2, 2, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier("lich", LichStats, 1);


//Can also be Elf.
    AddAdditionalBaseRaceToSubrace("lich", RACIAL_TYPE_ELF);

//Can also be Half-Elf.
    AddAdditionalBaseRaceToSubrace("lich", RACIAL_TYPE_HALFELF);

//The different skins to be equipped at different levels...
    AddAdditionalSkinsToSubrace("lich", "sha_pcl_lich1", 5);
    AddAdditionalSkinsToSubrace("lich", "sha_pcl_lich2", 10);
    AddAdditionalSkinsToSubrace("lich", "sha_pcl_lich3", 15);
    AddAdditionalSkinsToSubrace("lich", "sha_pcl_lich4", 20);
    AddAdditionalSkinsToSubrace("lich", "sha_pcl_lich5", 25);
    AddAdditionalSkinsToSubrace("lich", "sha_pcl_lich6", 30);
    AddAdditionalSkinsToSubrace("lich", "sha_pcl_lich7", 35);
    AddAdditionalSkinsToSubrace("lich", "sha_pcl_lich8", 40);

//Alignment Restriction - Must be Evil.
    CreateSubraceAlignmentRestriction("lich", FALSE, FALSE, TRUE);

//Class Restriction - Can only be Wizard or Sorcerer.
    CreateSubraceClassRestriction("lich", FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE);

//Spell Resistance: 10 + 1/2 Per Level.
    CreateSubraceSpellResistance("lich", 10, 30);

//Appearance: Lich - Permanent.
    CreateSubraceAppearance("lich", TIME_BOTH, APPEARANCE_TYPE_LICH, APPEARANCE_TYPE_HEURODIS_LICH);

//Favored Class: Pale Master
    AddSubraceFavoredClass("lich", CLASS_TYPE_WIZARD, CLASS_TYPE_WIZARD);











//::::::::::::::::::::::
//:::SUBRACE: Vampire ::
//::::::::::::::::::::::

//Subrace Name: Vampire

//Properties from the Skin:

    //Level 1:
        //Damage Vulnerability: Divine 100% Damage Vulnerability
        //Decreased Saving Throws: Divine -5
        //Regeneration +1

    //Level 5:
        //Gains - Immunity: Miscellaneous: Paralysis

    //Level 10:
        //Gains - Immunity: Miscellaneous: Poison

    //Level 15:
        //Gains - Immunity: Miscellaneous: Disease

    //Level 20:
        //Gains - Immunity: Miscellaneous: Death Magic
        //        Regeneration Increases by +1

    //Level 25:
        //Gains - Immunity: Miscellaneous: Level/Ability Drain

    //Level 30:
        //Gains - Immunity: Miscellaneous: Mind-Affecting Spells

    //Level 35:
        //Gains - Immunity: Miscellaneous: Sneak Attack


    //Level 40:
        //Gains - Immunity: Miscellaneous: Critical Hits
        //        Regeneration Increases by +1

//NOTE: Final Regeneration rate (At Level 40) is +3.


//Human. Light Sensitive. Takes 2 Divine Damage while in Sunlight.
//ECL: + 3
//Undead
   CreateSubrace(RACIAL_TYPE_HUMAN, "vampire", "sha_pc_vamp001", "sha_subrace_vamp", TRUE, 2, FALSE, 0, 3, TRUE);


//LETO - Change ability scores:
    //Level 1:
        //Decreased Ability Score: Charisma -2
    struct SubraceBaseStatsModifier VampireStats = CustomBaseStatsModifiers(0, 0, 0, 0, 0, -2, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier("vampire", VampireStats, 1);

//LETO - Feats:
    //Darkvision
    ModifySubraceFeat("vampire", FEAT_DARKVISION, 1);

//Can also be Elf
   AddAdditionalBaseRaceToSubrace("vampire", RACIAL_TYPE_ELF);

//Can also be Half-Elf
   AddAdditionalBaseRaceToSubrace("vampire", RACIAL_TYPE_HALFELF);

//Skins that are equipped at certain levels...
   AddAdditionalSkinsToSubrace("vampire", "sha_pcl_vamp002", 5);
   AddAdditionalSkinsToSubrace("vampire", "sha_pcl_vamp003", 10);
   AddAdditionalSkinsToSubrace("vampire", "sha_pcl_vamp004", 15);
   AddAdditionalSkinsToSubrace("vampire", "sha_pcl_vamp005", 20);
   AddAdditionalSkinsToSubrace("vampire", "sha_pcl_vamp006", 25);
   AddAdditionalSkinsToSubrace("vampire", "sha_pcl_vamp007", 30);
   AddAdditionalSkinsToSubrace("vampire", "sha_pcl_vamp008", 35);
   AddAdditionalSkinsToSubrace("vampire", "sha_pcl_vamp009", 40);

//Alignment Restriction: Can only be evil.
   CreateSubraceAlignmentRestriction("vampire", FALSE, FALSE, TRUE);

//Appearance: Change the Appearance to a Vampire during night time, and revert back to normal during day time.
  CreateSubraceAppearance("vampire", TIME_NIGHT, APPEARANCE_TYPE_VAMPIRE_MALE, APPEARANCE_TYPE_VAMPIRE_FEMALE, 1);

//Temporary Stats: Bonuses at Night time.
//Increase Strength by 6 points, Dexterity by 4 points, Consitution by 4, Charisma by 2, and AC by 5 and AB 10 during the Night.
   struct SubraceStats VampStats1 =  CreateCustomStats(SUBRACE_STAT_MODIFIER_TYPE_POINTS, 6.0, 4.0, 4.0, 0.0, 0.0, 2.0, 5.0, 10.0);
   CreateTemporaryStatModifier("vampire", VampStats1, TIME_NIGHT);

//Favored Class: Rogue.
   AddSubraceFavoredClass("vampire", CLASS_TYPE_ROGUE, CLASS_TYPE_ROGUE);

}
