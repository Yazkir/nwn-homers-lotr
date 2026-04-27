
/*************************************************************************
 * OnHeartbeat.txt by Mitchell M. Evans (gonecamping@cox.net)
 *
 * If you use it, or major parts of it, please keep some variety of
 * attribution.  It's only polite :)
 *
 * My Normal Server: Derelict's Server (usually running my custom modules)
 *
 * I've broken this script up functionally.  Since it's the heartbeat
 * function for the entire module, I can see where it might get large and
 * hard to manage otherwise ... as more and more "house rules" are
 * implemented.
 *
 *************************************************************************/

/*
 * I like to put all the things I can "tweak" in one place.  You could put
 * each behavior into the function in which it's used, but it's far easier
 * to find them this way.
 */
void loadBehaviors()
{
    /*
     * HP at which the player actually dies.  Cannot set below -10 due to
     * hardcoded game restrictions ... so the valid range is 0 to -10.
     * However, if it's zero, that's essentially what NWN does by default.
     */
    SetLocalInt(OBJECT_SELF, "DEATH_TARGET", -10);

    /*
     * If set to TRUE, the player will only grunt on the ground as he or
     * she dies.  If set to false, the player will also call for help
     * periodically.
     */
    SetLocalInt(OBJECT_SELF, "PLAYER_ONLY_GRUNTS_WHILE_DYING", FALSE);
}


/*
 * Checks the pc object to determine if the hit points are zero or less.
 * If so, and the player has not actually died, this function inflicts one
 * point of damage to the PC, and makes an appropriate sound (grunt, call for
 * aid, etc).  When the hit points have reached the desired target, this
 * function sends a death event to the pc object.
 */
void bleedCheck(object pc)
{
    // make sure a valid PC object was passed in
    if (!GetIsPC(pc))
        return;

    // get desired behaviors
    int DEATH_TARGET = GetLocalInt(OBJECT_SELF, "DEATH_TARGET");
    int PLAYER_ONLY_GRUNTS_WHILE_DYING = GetLocalInt(OBJECT_SELF, "PLAYER_ONLY_GRUNTS_WHILE_DYING");

    int hp = GetCurrentHitPoints(pc);

    // make sure pc is bleeding, and not already dead
    if ((hp <= 0) && (hp > DEATH_TARGET))
    {
        // damage pc
        effect dmg = EffectDamage(1);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, dmg, pc);
        int which = d6();

        // if the DM wants only grunts, only use first 3 cases in the
        // switch statement below
        if (PLAYER_ONLY_GRUNTS_WHILE_DYING)
            which = FloatToInt(IntToFloat(which) / 2.0 + 0.5);

        switch (which)
        {
            case 1:
                PlayVoiceChat(VOICE_CHAT_PAIN1, pc);
                break;

            case 2:
                PlayVoiceChat(VOICE_CHAT_PAIN2, pc);
                break;

            case 3:
                PlayVoiceChat(VOICE_CHAT_PAIN3, pc);
                break;

            case 4:
                PlayVoiceChat(VOICE_CHAT_HEALME, pc);
                break;

            case 5:
                PlayVoiceChat(VOICE_CHAT_NEARDEATH, pc);
                break;

            case 6:
                PlayVoiceChat(VOICE_CHAT_HELP, pc);
                break;
        }

    }
    else if (hp <= DEATH_TARGET)
    {
        // pc bled to death
        effect death = EffectDeath(FALSE, FALSE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, death, pc);
    }
}


/*
 * OnHeartbeat main
 */
void main()
{
    // load up desired behaviors for all OnHeartbeat scripts
    loadBehaviors();

    // enumerate all PCs, calling bleedCheck on each
    // if you want to add more / other scripts that act on all players
    // every heartbeat, this is the place to do it ... just put a call
    // to them after (or before) bleedCheck, within the while loop.
    object pc = GetFirstPC();

    while (GetIsObjectValid(pc))
    {
        bleedCheck(pc);

        pc = GetNextPC();
    }
}


