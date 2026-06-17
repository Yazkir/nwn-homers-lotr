#!/usr/bin/env python3
"""Apply LLM-reviewed typo corrections to .dlg.json conversation files.

Each entry: (filename, old_text, new_text, replace_all)
replace_all=True replaces every occurrence in the file.
"""
import json
import sys
from pathlib import Path

UNPACKED = Path(__file__).parent.parent / "unpacked"

CORRECTIONS = [
    # adas
    ("adas.dlg.json", "weapons of death form afar", "weapons of death from afar", False),

    # ajdla
    ("ajdla.dlg.json", "An assasin of Sauron must be well equiped", "An assassin of Sauron must be well equipped", False),

    # alatar
    ("alatar.dlg.json", "truely are", "truly are", False),
    ("alatar.dlg.json", "welcome lormaster", "welcome loremaster", False),

    # andrick
    ("andrick.dlg.json", "Aparently not", "Apparently not", False),

    # andrick2
    ("andrick2.dlg.json", "little expidition", "little expedition", False),
    ("andrick2.dlg.json", "new expidition", "new expedition", False),
    ("andrick2.dlg.json", "garaunteed", "guaranteed", False),
    ("andrick2.dlg.json", "I got unough deck swabbies", "I got enough deck swabbies", False),
    ("andrick2.dlg.json", "get paddling casue", "get paddling cause", False),

    # appearance_guy
    ("appearance_guy.dlg.json", "What king of wings?", "What kind of wings?", False),

    # avanger
    ("avanger.dlg.json", "we have one the day", "we have won the day", False),
    ("avanger.dlg.json", "catastophe", "catastrophe", False),
    ("avanger.dlg.json", "etherreal", "ethereal", False),
    ("avanger.dlg.json", "Scepter br brought", "Scepter be brought", False),
    ("avanger.dlg.json", "back ot the island", "back to the island", False),
    ("avanger.dlg.json", "somehting", "something", False),

    # barliman
    ("barliman.dlg.json", "I here there are some Goblins", "I hear there are some Goblins", False),

    # barmaind1
    ("barmaind1.dlg.json", "servcice", "service", True),

    # barmaind2
    ("barmaind2.dlg.json", "servcice", "service", True),

    # b_guard_convo1
    ("b_guard_convo1.dlg.json", "ya never know whet might be lurking", "ya never know what might be lurking", False),

    # b_miller_convo1
    ("b_miller_convo1.dlg.json", "shipment fo Ale", "shipment of Ale", False),
    ("b_miller_convo1.dlg.json", "going ot make it", "going to make it", False),

    # b_oldwoman_con1
    ("b_oldwoman_con1.dlg.json", "Winks wich looks frightening similair", "Winks which looks frighteningly similar", False),

    # breafarmer
    ("breafarmer.dlg.json", "heat destoys", "heat destroys", False),

    # captivech
    ("captivech.dlg.json", "Ah help us there going to boil us", "Ah help us they're going to boil us", False),

    # clericq
    ("clericq.dlg.json", "truly a worth subject", "truly a worthy subject", False),

    # contestparch
    ("contestparch.dlg.json", "Contest of Champios", "Contest of Champions", False),

    # doorman
    ("doorman.dlg.json", "Go in Saurman expects you", "Go in Saruman expects you", False),

    # dunharrow_shop
    ("dunharrow_shop.dlg.json", "told to asist you", "told to assist you", False),

    # elrondconv
    ("elrondconv.dlg.json", "naked in the forrest!", "naked in the forest!", False),
    ("elrondconv.dlg.json", "lord Elrond you generosity", "lord Elrond your generosity", False),

    # elvenrange
    ("elvenrange.dlg.json", "Is this you home here?", "Is this your home here?", False),
    ("elvenrange.dlg.json", "the secret to of entrance", "the secret to entrance", False),

    # erktalk
    ("erktalk.dlg.json", "brave heros!", "brave heroes!", False),

    # erktalk1
    ("erktalk1.dlg.json", "come ot our aid", "come to our aid", False),
    ("erktalk1.dlg.json", "Thank you for you aid Erkenbrand", "Thank you for your aid Erkenbrand", False),
    ("erktalk1.dlg.json", "listens to often to", "listens too often to", False),
    ("erktalk1.dlg.json", "Worm Tongues advise", "Worm Tongue's advice", False),

    # eviltele
    ("eviltele.dlg.json", "Isengrad", "Isengard", False),

    # emotewand
    ("emotewand.dlg.json", "Suarons Hall", "Sauron's Hall", False),

    # fxwand
    ("fxwand.dlg.json", "Dunk man sings about an Ogre", "Drunk man sings about an Ogre", False),

    # glorfind
    ("glorfind.dlg.json", "Essense of a Drake", "Essence of a Drake", False),
    ("glorfind.dlg.json", "Thanks Glrofindel", "Thanks Glorfindel", False),

    # gondorscribe
    ("gondorscribe.dlg.json", "fend of the night", "fend off the night", False),
    ("gondorscribe.dlg.json", "beseiged", "besieged", False),
    ("gondorscribe.dlg.json", "cheif lieutenant", "chief lieutenant", False),
    ("gondorscribe.dlg.json", "dessemated", "decimated", False),
    ("gondorscribe.dlg.json", "tomes of wisdon", "tomes of wisdom", False),
    ("gondorscribe.dlg.json", "expidition", "expedition", True),
    ("gondorscribe.dlg.json", "place know as", "place known as", False),
    ("gondorscribe.dlg.json", "Guarding somehting?", "Guarding something?", False),
    ("gondorscribe.dlg.json", "Arthedian", "Arthedain", True),
    ("gondorscribe.dlg.json", "You valiance will go far", "Your valiance will go far", False),
    ("gondorscribe.dlg.json", "Do he....", "Does he....", False),
    ("gondorscribe.dlg.json", "its here.", "it's here.", False),

    # greendragon1
    ("greendragon1.dlg.json", "How may I server you?", "How may I serve you?", False),

    # greendragon2
    ("greendragon2.dlg.json", "loosing your job", "losing your job", False),
    ("greendragon2.dlg.json", "should loose customers", "should lose customers", False),
    ("greendragon2.dlg.json", "unintrested", "uninterested", False),
    ("greendragon2.dlg.json", "oldfashined", "old-fashioned", False),
    ("greendragon2.dlg.json", "annyoing", "annoying", False),
    ("greendragon2.dlg.json", "eyeborws", "eyebrows", False),

    # guidetalkinto
    ("guidetalkinto.dlg.json", "hay day", "heyday", False),
    ("guidetalkinto.dlg.json", "Mirkwood Forrest", "Mirkwood Forest", True),

    # gwath_quest
    ("gwath_quest.dlg.json", "imporant", "important", True),
    ("gwath_quest.dlg.json", "acomplish", "accomplish", False),
    ("gwath_quest.dlg.json", "we have slayed the", "we have slain the", False),

    # hungrypeas
    ("hungrypeas.dlg.json", "begger!", "beggar!", False),

    # intros
    ("intros.dlg.json", "ressurected", "resurrected", False),
    ("intros.dlg.json", "vise versa", "vice versa", False),

    # kashanquest
    ("kashanquest.dlg.json", "appear alittle down", "appear a little down", False),
    ("kashanquest.dlg.json", "your a good person", "you're a good person", False),

    # kohadjuster
    ("kohadjuster.dlg.json", "to adust my alignment", "to adjust my alignment", False),

    # kpb_banker
    ("kpb_banker.dlg.json", "depositers", "depositors", False),

    # kpb_broker
    ("kpb_broker.dlg.json", "ingenius", "ingenious", True),
    ("kpb_broker.dlg.json", "investements", "investments", False),

    # lagmonster
    ("lagmonster.dlg.json", "Pleasedo not complain", "Please do not complain", False),

    # lakebear
    ("lakebear.dlg.json", "most grateful for you help", "most grateful for your help", False),
    ("lakebear.dlg.json", "to get some me some help", "to get me some help", False),

    # lakeguard
    ("lakeguard.dlg.json", "Watch you purse here", "Watch your purse here", False),

    # laxus_talk2
    ("laxus_talk2.dlg.json", "Hell to you again friend", "Hail to you again friend", False),

    # laxus_talk
    ("laxus_talk.dlg.json", "the captian of this", "the captain of this", True),
    ("laxus_talk.dlg.json", "beyond that dore", "beyond that door", False),
    ("laxus_talk.dlg.json", "a vary special", "a very special", False),
    ("laxus_talk.dlg.json", "found it tow months", "found it two months", False),
    ("laxus_talk.dlg.json", "did not dear to step", "did not dare to step", False),
    ("laxus_talk.dlg.json", "exsplore", "explore", False),
    ("laxus_talk.dlg.json", "intreasted", "interested", False),
    ("laxus_talk.dlg.json", "be carefull there", "be careful there", False),
    ("laxus_talk.dlg.json", "many peaople", "many people", False),
    ("laxus_talk.dlg.json", "island called called Gwathdor", "island called Gwathdor", False),

    # lonemerch
    ("lonemerch.dlg.json", "If your looking for the finest", "If you're looking for the finest", False),

    # lowyns
    ("lowyns.dlg.json", "I though nothing of the kind", "I thought nothing of the kind", False),
    ("lowyns.dlg.json", "it so rare to come across", "it is so rare to come across", False),

    # m2q2ajax2
    ("m2q2ajax2.dlg.json", "artfiact", "artifact", True),

    # m3q04g13yuan
    ("m3q04g13yuan.dlg.json", "this rooom by", "this room by", False),

    # m3q04h04drag
    ("m3q04h04drag.dlg.json", "studpidest", "stupidest", False),

    # maggie
    ("maggie.dlg.json", "see wants down crazy", "see what's down crazy", False),

    # minstevil
    ("minstevil.dlg.json", "let us here your tale", "let us hear your tale", False),
    ("minstevil.dlg.json", "a couter offensive", "a counter offensive", False),
    ("minstevil.dlg.json", "preistesses", "priestesses", False),

    # mistgood
    ("mistgood.dlg.json", "lets here it", "lets hear it", False),
    ("mistgood.dlg.json", "elven ranger and Ronger of the north", "elven ranger and Ranger of the north", False),
    ("mistgood.dlg.json", "unconcious", "unconscious", False),
    ("mistgood.dlg.json", "this all was mastermind by", "this all was masterminded by", False),

    # moody
    ("moody.dlg.json", "Troll Shalls", "Troll Shaws", False),
    ("moody.dlg.json", "atleast", "at least", False),
    ("moody.dlg.json", "You theif I want", "You thief I want", False),

    # mystics
    ("mystics.dlg.json", "Planets aling our", "Planets align our", False),
    ("mystics.dlg.json", "prophets fortold", "prophets foretold", False),
    ("mystics.dlg.json", "Mirkwood forrest", "Mirkwood forest", True),
    ("mystics.dlg.json", "A terible end", "A terrible end", False),
    ("mystics.dlg.json", "trecherous", "treacherous", False),
    ("mystics.dlg.json", "seeks to raize", "seeks to raze", False),
    ("mystics.dlg.json", "grevious", "grievous", False),
    ("mystics.dlg.json", "You help is fortold", "Your help is foretold", False),
    ("mystics.dlg.json", "Lady Mistic", "Lady Mystic", True),
    ("mystics.dlg.json", "desicration", "desecration", False),
    ("mystics.dlg.json", "heart of you long lost sister", "heart of your long lost sister", False),
    ("mystics.dlg.json", "And you save the lives", "And you saved the lives", False),

    # nara_convo2
    ("nara_convo2.dlg.json", "anyhting", "anything", False),
    ("nara_convo2.dlg.json", "better that this?", "better than this?", False),

    # neutraltele
    ("neutraltele.dlg.json", "Weclome", "Welcome", False),

    # npc_banker
    ("npc_banker.dlg.json", "ammount", "amount", True),
    ("npc_banker.dlg.json", "withdrawl", "withdrawal", True),
    ("npc_banker.dlg.json", "untill", "until", True),

    # npc_bankmanager
    ("npc_bankmanager.dlg.json", "untill", "until", True),

    # pccorpse_conv
    ("pccorpse_conv.dlg.json", "far to long", "far too long", False),

    # plump
    ("plump.dlg.json", "I here there are some foul spiders", "I hear there are some foul spiders", False),

    # quests
    ("quests.dlg.json", "dwarves steak out", "dwarves stake out", False),
    ("quests.dlg.json", "fromt he barrows", "from the barrows", False),
    ("quests.dlg.json", "Free People of middl earth", "Free People of Middle Earth", False),
    ("quests.dlg.json", "and have allow others", "and allow others", False),
    ("quests.dlg.json", "bets on the outsomes", "bets on the outcomes", False),
    ("quests.dlg.json", "perhaps a dule to the first cut", "perhaps a duel to the first cut", False),

    # rangermerch
    ("rangermerch.dlg.json", "Whould you care", "Would you care", False),

    # rohanguard
    ("rohanguard.dlg.json", "friend of foe?", "friend or foe?", False),
    ("rohanguard.dlg.json", "traveling though.", "traveling through.", False),

    # ronus_craft_book
    ("ronus_craft_book.dlg.json", "what your thinking", "what you're thinking", False),
    ("ronus_craft_book.dlg.json", "Now were was I?", "Now where was I?", False),
    ("ronus_craft_book.dlg.json", "very perticular", "very particular", False),

    # roulette
    ("roulette.dlg.json", "include1-4", "include 1-4", False),
    ("roulette.dlg.json", "adjacent to eachother", "adjacent to each other", False),
    ("roulette.dlg.json", "a dash inbetween", "a dash in between", False),

    # saldsrequest
    ("saldsrequest.dlg.json", "You seam to be a fine", "You seem to be a fine", False),

    # smithisland
    ("smithisland.dlg.json", "in afew days", "in a few days", False),

    # store059
    ("store059.dlg.json", "Well-Mart.Would", "Well-Mart. Would", False),

    # tag_game
    ("tag_game.dlg.json", "Tag your it!", "Tag you're it!", False),

    # tharbadgen
    ("tharbadgen.dlg.json", "im sure weather your heading in or going out", "I'm sure whether you're heading in or going out", False),

    # tharbadguard
    ("tharbadguard.dlg.json", "businees", "business", False),

    # theoden
    ("theoden.dlg.json", "Have your returned triumphant?", "Have you returned triumphant?", False),
    ("theoden.dlg.json", "in troubles times", "in troubled times", False),
    ("theoden.dlg.json", "What would be to you taste?", "What would be to your taste?", False),
    ("theoden.dlg.json", "Isangard outer rim", "Isengard outer rim", False),
    ("theoden.dlg.json", "outside Saurman's Wall", "outside Saruman's Wall", False),

    # tilith
    ("tilith.dlg.json", "fullfill", "fulfill", False),

    # warfmerch
    ("warfmerch.dlg.json", "of the dwaves do ya?", "of the dwarves do ya?", False),

    # wecome
    ("wecome.dlg.json", "with afew very simple rules", "with a few very simple rules", False),
    ("wecome.dlg.json", "wanker that trys to pick", "wanker that tries to pick", False),
    ("wecome.dlg.json", "a little to hardcore", "a little too hardcore", False),
    ("wecome.dlg.json", "I have already grew bored", "I have already grown bored", False),
    ("wecome.dlg.json", "The DMs are to server me", "The DMs are to serve me", False),

    # x0_skill_ctrap
    ("x0_skill_ctrap.dlg.json", "primairy", "primary", True),
    ("x0_skill_ctrap.dlg.json", "secondairy", "secondary", True),

    # xpbank
    ("xpbank.dlg.json", "available for withdrawl", "available for withdrawal", False),
]


def fix_text_in_entry_list(entries: list, old: str, new: str, replace_all: bool) -> int:
    """Apply a text replacement across all entries. Returns count of replacements."""
    count = 0
    for entry in entries:
        text_field = entry.get("Text")
        if not isinstance(text_field, dict):
            continue
        val = text_field.get("value")
        if not isinstance(val, dict) or "0" not in val:
            continue
        text = val["0"]
        if not isinstance(text, str):
            continue
        if old in text:
            if replace_all:
                val["0"] = text.replace(old, new)
                count += text.count(old)
            else:
                val["0"] = text.replace(old, new, 1)
                count += 1
    return count


def main():
    applied = 0
    not_found = []

    for filename, old, new, replace_all in CORRECTIONS:
        dlg_path = UNPACKED / filename
        if not dlg_path.exists():
            print(f"MISSING: {filename}")
            continue

        with open(dlg_path) as f:
            try:
                data = json.load(f)
            except json.JSONDecodeError as e:
                print(f"ERROR parsing {filename}: {e}")
                continue

        count = 0
        for list_key in ("EntryList", "ReplyList"):
            entry_list = data.get(list_key)
            if not entry_list:
                continue
            entries = entry_list.get("value", [])
            count += fix_text_in_entry_list(entries, old, new, replace_all)

        if count > 0:
            with open(dlg_path, "w") as f:
                json.dump(data, f, indent=2, ensure_ascii=False)
                f.write("\n")
            print(f"  [{count}x] {filename}: {old!r} → {new!r}")
            applied += count
        else:
            not_found.append((filename, old))

    print(f"\nApplied {applied} replacements.")
    if not_found:
        print(f"\nNot found ({len(not_found)} — may have been fixed already or text differs):")
        for fn, old in not_found:
            print(f"  {fn}: {old!r}")


if __name__ == "__main__":
    main()
