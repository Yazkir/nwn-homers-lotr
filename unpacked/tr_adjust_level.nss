//::///////////////////////////////////////////////
//:: Name: tr_adjust_level
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
     Actually sets the correct XP on player.
*/
//:://////////////////////////////////////////////
//:: Created By: Cylvia
//:: Created On: 1-2-2004
//:://////////////////////////////////////////////
void main()
{
// take level number wanted stored on self.
string sLevel = GetLocalString(OBJECT_SELF,"trainer evaluate");
// now that we have the number, convert to integer
// so we can work with it.
int iLevel = StringToInt(sLevel);

// if number is less than 1, we change it to 1.
if (iLevel < 1)
    {
     iLevel = 1;
    }
// if number is greater than 40, we change it to 40.
if (iLevel > 40)
    {
     iLevel = 40;
    }

// here the actual XP function is set.
int iXP = iLevel*(iLevel-1)*500;

if (iLevel == 1)
    {iXP = 1;}
// and now we finally apply XP to the player.
SetXP(GetPCSpeaker(),iXP);
}
