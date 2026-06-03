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
    /// Display name for the spawned NPC.
    /// Enemies (in a column): "Cardname (HP current/max) EffectName" — survivor effect name, falling back to death.
    /// Allies (in hand): "Cardname (ATK #) EffectName" — attack effect name.
    /// The NWN health bar / "badly wounded" tint is driven separately by the creature's HP (see CardActor.RefreshHealth).
    /// </summary>
    public static string BuildName(Card card)
    {
        bool isEnemy = card.columnIndex >= 0;
        if (isEnemy)
        {
            string eff = card.survivorEffect?.name ?? card.deathEffect?.name ?? "";
            string suffix = eff.Length > 0 ? $" {eff}" : "";
            return $"{card.name} (HP {card.currentHealth}/{card.maxHealth}){suffix}";
        }
        else
        {
            string eff = card.attackEffect?.name ?? "";
            string suffix = eff.Length > 0 ? $" {eff}" : "";
            return $"{card.name} (ATK {card.baseAttack}){suffix}";
        }
    }

    /// <summary>
    /// One-line label for this card as a row in the secondary-choice popup menu.
    /// <paramref name="asEnemy"/> is the sole determinant of role — callers like
    /// SelectCardFromGraveyard pass false even for cards whose columnIndex is still set,
    /// so we do not fall back to columnIndex here.
    /// </summary>
    public static string ChoiceLabel(Card card, bool asEnemy)
    {
        if (asEnemy)
        {
            string eff = card.survivorEffect?.name ?? card.deathEffect?.name ?? "";
            string suffix = eff.Length > 0 ? $" {eff}" : "";
            return $"{card.name} (HP {card.currentHealth}/{card.maxHealth}){suffix}";
        }
        else
        {
            string eff = card.attackEffect?.name ?? "";
            string suffix = eff.Length > 0 ? $" {eff}" : "";
            return $"{card.name} (ATK {card.baseAttack}){suffix}";
        }
    }

    /// <summary>
    /// Full card text for the spawned NPC's description. Shown when the player examines
    /// the creature. Only the effects relevant to the card's current role are shown.
    /// Enemies: survivor and/or death effect. Allies: attack effect only.
    /// Format: "EffectName: effect description"
    /// </summary>
    public static string BuildDescription(Card card)
    {
        var sb = new StringBuilder();
        bool isEnemy = card.columnIndex >= 0;

        if (!isEnemy)
        {
            if (card.attackEffect is { } atk && !string.IsNullOrWhiteSpace(atk.name))
                sb.Append(atk.name).Append(": ").Append(atk.description);
        }
        else
        {
            if (card.survivorEffect is { } sur && !string.IsNullOrWhiteSpace(sur.name))
                sb.Append(sur.name).Append(": ").Append(sur.description);
            if (card.deathEffect is { } dth && !string.IsNullOrWhiteSpace(dth.name))
            {
                if (sb.Length > 0) sb.Append('\n');
                sb.Append(dth.name).Append(": ").Append(dth.description);
            }
        }

        return sb.ToString();
    }
}
