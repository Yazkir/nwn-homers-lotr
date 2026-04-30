void main()
{

object oGwathHolder = GetObjectByTag("GwathdorHolder");
int nLordSpawn = GetLocalInt (oGwathHolder, "SpawnLord");
location lLordSpawnPlace = GetLocation (GetObjectByTag("GLordSpawn"));

if (nLordSpawn == 1)
{
//ActionSpeakString ("Lord spawns", TALKVOLUME_SHOUT); //debug
SetLocalInt (oGwathHolder, "SpawnLord", 0);
//spawn the lord:
CreateObject (OBJECT_TYPE_CREATURE, "gwathdorlord", lLordSpawnPlace, FALSE);
CreateObject (OBJECT_TYPE_CREATURE, "gwathsorcerer", lLordSpawnPlace, FALSE);
CreateObject (OBJECT_TYPE_CREATURE, "gwathsorcerer", lLordSpawnPlace, FALSE);

}
if (nLordSpawn != 1)
{
//ActionSpeakString ("Lord doesnt spawn", TALKVOLUME_SHOUT);//debug
}


}
