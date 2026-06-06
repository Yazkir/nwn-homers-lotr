//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::: Shayan's Subrace Engine :::::::::::::::::::::::::::::
//:::::::::::::::::::::::File Name: _dm_subrace_lis1 :::::::::::::::::::::::::::
//:::::::::::::::::::::::::: OnSpawn script ::::::::::::::::::::::::::::::::::::
//:: Written By: Shayan.
//:: Contact: mail_shayan@yahoo.com
//
// :: This script controls the OnSpawn Event for the Subrace Listener.
// :: The Listener is used to detect DM speach.
void main()
{
    // Record spawn area so the creature can be leashed to it (see leash_to_area.nss).
    SetLocalLocation(OBJECT_SELF, "spawn", GetLocation(OBJECT_SELF));

   SetListening(OBJECT_SELF,TRUE);
   //Listen for anything...
   SetListenPattern(OBJECT_SELF,"**", 8686);
   //Disappear OnSpawn...
   DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY), OBJECT_SELF));
}
