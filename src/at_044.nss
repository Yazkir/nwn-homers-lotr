//::///////////////////////////////////////////////
//:: FileName at_044
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 10/16/2002 10:34:28 PM
//:://////////////////////////////////////////////
void main()
{

    // Remove items from the player's inventory
    object oItemToTake;
    oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "venison");
    if(GetIsObjectValid(oItemToTake) != 0)
        DestroyObject(oItemToTake);
    // Set the variables
    int nCurVal=GetLocalInt(GetPCSpeaker(), "fooder");
    nCurVal++;
    SetLocalInt(GetPCSpeaker(), "fooder", nCurVal);

}
