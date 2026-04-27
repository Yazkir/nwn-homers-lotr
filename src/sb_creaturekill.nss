// Assign to the OnDeath script option for each creature in the module

void main()
{
    object oKiller = GetLastKiller();
    // Is this object a PC?

    // Increment the killer var
    int iKilled = GetLocalInt (oKiller,"iKilled");
    ++iKilled;
    SetLocalInt(oKiller,"iKilled",iKilled);
}
