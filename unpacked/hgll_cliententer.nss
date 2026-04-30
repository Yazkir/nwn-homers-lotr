void main()
{
    object oPC = GetEnteringObject();
    //below removes the Letoscript string so the changes won't be applied again on the next logout
    string Script = GetLocalString(oPC, "LetoScript");
    if( Script != "" )
    {
        SetLocalString(oPC, "LetoScript", "");



     object oPC = GetEnteringObject();
     object oDeathAmulet;
     effect eDeath = EffectDeath( FALSE, FALSE );
     oDeathAmulet = GetFirstItemInInventory(oPC);

     while( GetIsObjectValid(oDeathAmulet))
     {
        if( GetTag( oDeathAmulet ) == "deathamulet" )
        {
           ApplyEffectToObject( DURATION_TYPE_INSTANT, eDeath, oPC);
           break;
        }
        oDeathAmulet = GetNextItemInInventory( oPC );

  }
  }

}
