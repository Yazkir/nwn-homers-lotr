using System.Text;

namespace DungeonSolitaire.Nwn;

/// <summary>
/// Maps each Dungeon Solitaire card (by its engine <c>card.name</c>) to an NWN
/// creature blueprint resref, and renders the card's full rules text for the
/// spawned NPC's description (the "examine to read the card" mechanic).
///
/// Resrefs were resolved from module-index/creature_index.json per the analysis
/// in dungeon-solitaire.txt: exact/close matches and a few thematic substitutes
/// use real module creatures; characters with no module equivalent fall back to
/// Old Tagget (<see cref="Placeholder"/>) while keeping the card's real name.
/// </summary>
internal static class CardCreatureMap
{
    /// <summary>Old Tagget — placeholder appearance for characters not in the module (Frodo, Merry, …).</summary>
    public const string Placeholder = "old";

    /// <summary>Generic statue placeable spawned for face-down (hidden) cards. See unpacked/ds_facedown.utp.json.</summary>
    public const string FaceDownStatue = "ds_facedown";

    private static readonly Dictionary<string, string> ByName = new()
    {
        // Maiar
        ["Radiant Olorin"]          = "gandalf001",        // Gandalf the Gray (Olorin)
        ["Shining Curunir"]         = "alatar",            // Alatar the Blue
        // Servants of Sauron
        ["Gothmog the Burning"]     = "thehighmageofbar",  // Gothmog Lord of Barad-Dur
        ["Drowned Mouth of Sauron"] = "hoarmouththering",  // Hoarmouth the Ringwraith
        ["Khamul the Easterling"]   = "creature023",       // Rancid Skinner ... of Khamul
        ["Adunaphel the Quiet"]     = "adunaphelther001",
        ["The Witch-king of Angmar"]= "angmartheevoocat",
        // Orcs of Mordor (thematic substitutes)
        ["Grishnakh"]               = "bandit007",         // Groodok the Skinner
        ["Shagrat"]                 = "urukai016",         // Mordor Orc Lieutenant Soldier
        ["Gorbag"]                  = "fiendofmorgul",
        // Uruk-hai
        ["Ugluk"]                   = "urukai020",
        ["Lurtz"]                   = "urukai003",          // Urukai Captain
        ["Mauhur"]                  = "urukhaifirstborn",
        ["Isengard Executioner"]    = "urukai012",          // Uruk Hai Slayer
        ["Isengard Warchief"]       = "urukai013",          // Marshall of the White Hand
        ["Isengard Squire"]         = "urukai001",          // Urukai Trooper
        ["Grima Wormtongue"]        = Placeholder,
        // Hobbits / Shire
        ["Bill the Pony"]           = "hobbit001",
        ["Bilbo Baggins"]           = "bilbobaggins",
        ["Samwise Gamgee"]          = "samwise",
        ["Frodo Baggins"]           = Placeholder,
        ["Peregrin Took"]           = Placeholder,
        ["Meriadoc Brandybuck"]     = Placeholder,
        // Rohan
        ["Eomer of the Eastmark"]   = Placeholder,
        ["Eowyn Shieldmaiden"]      = "eowyntheshieldma",
        // Rangers of the North
        ["Halbarad"]                = "rangerofthe003",     // Greater Ranger of the North
        ["Elladan"]                 = "elfranger016",
        ["Elrohir"]                 = "elfranger016",
        // Wood-elves of Mirkwood
        ["Silvan Shapeshifter"]     = "bearbeorning001",    // Beorning (Shifted)
        ["Mirkwood Shade"]          = "mirkwoodforestwa",   // Mirkwood Forest Walker
        ["Thranduil's Scout"]       = "creature018",        // Thranduil's Defender
        ["Legolas Greenleaf"]       = "legolasgreenl001",
        // Fellowship / Gondor
        ["Aragorn Strider"]         = "aragornsonofarat",
        ["Boromir"]                 = "creature009",
        ["Faramir"]                 = "creature002",
        ["Denethor"]                = "creature003",
        ["Beregond"]                = "gondorianguar002",   // Gondorian Guardsman
        ["Gimli Son of Gloin"]      = "gimli",
        ["Galadriel"]               = "galadriel",
        ["Saruman the White"]       = "sarumanthewhi001",
    };

    /// <summary>Blueprint resref to spawn for a card; falls back to Old Tagget if unmapped.</summary>
    public static string Resolve(Card card)
        => card?.name != null && ByName.TryGetValue(card.name, out string? rr) ? rr : Placeholder;

    /// <summary>
    /// Full card text for the spawned NPC's description. Shown when the player
    /// examines the creature — this replaces the printed card face.
    /// </summary>
    public static string BuildDescription(Card card)
    {
        var sb = new StringBuilder();
        sb.Append(card.name);
        if (!string.IsNullOrWhiteSpace(card.flavorType) && card.flavorType != "default")
            sb.Append("  —  ").Append(card.flavorType);
        sb.Append('\n');

        // Allies (in hand) read as attackers; enemies (in a column) read as defenders.
        bool isEnemy = card.columnIndex >= 0;
        if (isEnemy)
            sb.Append($"HP {card.currentHealth}/{card.maxHealth}    Attack {card.baseAttack}    Reward {card.reward}\n");
        else
            sb.Append($"Attack {card.baseAttack}    HP {card.maxHealth}\n");

        AppendEffect(sb, "Attack", card.attackEffect);
        AppendEffect(sb, "Survivor", card.survivorEffect);
        AppendEffect(sb, "Death", card.deathEffect);
        return sb.ToString();
    }

    private static void AppendEffect(StringBuilder sb, string slot, Effect? eff)
    {
        if (eff == null || string.IsNullOrWhiteSpace(eff.name)) return;
        sb.Append('\n').Append(slot).Append(": ").Append(eff.name);
        if (eff.triggerWhen == TriggerWhen.InsteadOfAttack) sb.Append(" (instead of attacking)");
        else if (eff.triggerWhen == TriggerWhen.PreAttack)   sb.Append(" (before attack)");
        if (!string.IsNullOrWhiteSpace(eff.description))
            sb.Append('\n').Append("  ").Append(eff.description);
    }
}
