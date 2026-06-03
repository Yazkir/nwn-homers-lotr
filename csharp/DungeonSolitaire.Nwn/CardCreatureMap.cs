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
    /// <summary>Generic statue placeable spawned for face-down (hidden) cards. See unpacked/ds_facedown.utp.json.</summary>
    public const string FaceDownStatue = "ds_facedown";

    private static readonly Dictionary<string, string> ByName = new()
    {
        // Maiar
        ["Radiant Olorin"]          = "ds_gandalf001",
        ["Shining Curunir"]         = "ds_alatar",
        // Servants of Sauron
        ["Gothmog the Burning"]     = "ds_gothmog",
        ["Drowned Mouth of Sauron"] = "ds_hoarmouth",
        ["Khamul the Easterling"]   = "ds_creature023",
        ["Adunaphel the Quiet"]     = "ds_adunaphel",
        ["The Witch-king of Angmar"]= "ds_witchking",
        // Orcs of Mordor
        ["Grishnakh"]               = "ds_bandit007",
        ["Shagrat"]                 = "ds_urukai016",
        ["Gorbag"]                  = "ds_fiendofmorgul",
        // Uruk-hai
        ["Ugluk"]                   = "ds_urukai020",
        ["Lurtz"]                   = "ds_urukai003",
        ["Mauhur"]                  = "ds_mauhur",
        ["Isengard Executioner"]    = "ds_urukai012",
        ["Isengard Warchief"]       = "ds_urukai013",
        ["Isengard Squire"]         = "ds_urukai001",
        // Hobbits / Shire (ds_grima/frodo/merry/pippin are Dwarf placeholders, tune appearance in toolset)
        ["Grima Wormtongue"]        = "ds_grima",
        ["Bill the Pony"]           = "ds_hobbit001",
        ["Bilbo Baggins"]           = "ds_bilbobaggins",
        ["Samwise Gamgee"]          = "ds_samwise",
        ["Frodo Baggins"]           = "ds_frodo",
        ["Peregrin Took"]           = "ds_pippin",
        ["Meriadoc Brandybuck"]     = "ds_merry",
        // Rohan (ds_eomer is Dwarf placeholder, tune appearance in toolset)
        ["Eomer of the Eastmark"]   = "ds_eomer",
        ["Eowyn Shieldmaiden"]      = "ds_eowyn",
        // Rangers of the North
        ["Halbarad"]                = "ds_halbarad",
        ["Elladan"]                 = "ds_elladan",
        ["Elrohir"]                 = "ds_elrohir",
        // Wood-elves of Mirkwood
        ["Silvan Shapeshifter"]     = "ds_beorning",
        ["Mirkwood Shade"]          = "ds_mirkwood",
        ["Thranduil's Scout"]       = "ds_creature018",
        ["Legolas Greenleaf"]       = "ds_legolas",
        // Fellowship / Gondor
        ["Aragorn Strider"]         = "ds_aragorn",
        ["Boromir"]                 = "ds_creature009",
        ["Faramir"]                 = "ds_creature002",
        ["Denethor"]                = "ds_creature003",
        ["Beregond"]                = "ds_beregond",
        ["Gimli Son of Gloin"]      = "ds_gimli",
        ["Galadriel"]               = "ds_galadriel",
        ["Saruman the White"]       = "ds_saruman",
    };

    /// <summary>Blueprint resref to spawn for a card; returns empty string if unmapped (spawn will fail visibly).</summary>
    public static string Resolve(Card card)
        => card?.name != null && ByName.TryGetValue(card.name, out string? rr) ? rr : "";

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
