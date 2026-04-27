/* Zach's Leggit reader this script will jail/Boot Uber
And a lil Thx too Xavior(TM) for giving me ideas!
*/
void oReason(object oPC, string reason)
{
    DelayCommand(0.5,SendMessageToPC(oPC,"<c?ò?>" + reason));
}

void kill(object thing)
{
    DestroyObject(thing);
}

int ItemCount(object oPC)
    {
    object oItem = GetFirstItemInInventory(oPC);
    int counts = 0;

    while(GetIsObjectValid(oItem))
    {
    counts++;
    oItem = GetNextItemInInventory(oPC);
    }
    return counts;
}

void oNoC(object oPC)
{
    AssignCommand(oPC,ClearAllActions());
    SetCommandable(FALSE,oPC);
    DelayCommand(0.2,SetPlotFlag(oPC,TRUE));
}

void oJail(object oMyTarget)
{
     object oTarget = GetWaypointByTag("jail");
     DelayCommand(1.0,AssignCommand(oMyTarget,JumpToObject(oTarget)));
     //BootPC(oPC);
}

void antihacker(object oPC)
{
    int wow =0;

    if(GetImmortal(oPC))
    {
    wow = 1;
    oReason(oPC,"Your Char Is Immortal, and its not allowed too be immortal here!");
    }
    else if(GetCreatureSize(oPC) > 3)
    {
    wow = 1;
    oReason(oPC,"Get rid Fat ass!");
    }
    else if(GetMaxHitPoints(oPC) > 3000)
    {
    wow = 1;
    oReason(oPC,"Your HP Is way to Much");
    }
    else if(GetAC(oPC) > 120)
    {
    wow = 1;
    oReason(oPC,"your AC is too much");
    }
    else if(GetMovementRate(oPC) != 2)
    {
    wow = 1;
    oReason(oPC,"Haking just isn't cool!");
    }
    //Set to o 9 Ability, incase The player usesan Ability incrase item or has legendary levels
    else if(GetAbilityScore(oPC,ABILITY_STRENGTH) > 90 ||
    GetAbilityScore(oPC,ABILITY_DEXTERITY) > 90 ||
    GetAbilityScore(oPC,ABILITY_CONSTITUTION) > 90 ||
    GetAbilityScore(oPC,ABILITY_WISDOM) > 90 ||
    GetAbilityScore(oPC,ABILITY_INTELLIGENCE) > 90 ||
    GetAbilityScore(oPC,ABILITY_CHARISMA) > 90)
    {
    wow = 1;
    oReason(oPC,"Your Char's Stats Are Too High");
    }
    if(GetFortitudeSavingThrow(oPC) > 50 ||
    GetWillSavingThrow(oPC) > 90 ||
    GetReflexSavingThrow(oPC) > 90)
    {
    wow = 1;
    oReason(oPC,"Your Char's Saves Are Too High");
    }
    if(GetSkillRank(SKILL_ALL_SKILLS, oPC) > 130)
    {
    wow = 1;
    oReason(oPC,"Skills To High");
    }
    string oNa = GetName(oPC);
    if(GetStringLength(oNa) < 2)
    {
    wow = 1;
    oReason(oPC,"Name Must Be Min 2 Letters");
    }
/*IF THE CHARS FAILS ONE OF THOSE TESTES IT WILL GET THAT MESSAGE AND AFTER THAT JAILING OR BOOTING
*/    if(wow == 1)
    {
    DelayCommand(1.0,oReason(oPC,"Character Failed Checks"));
    SetCommandable(TRUE,oPC);
    oJail(oPC);
    return;
    }
/*send this message if they are Passing ewry test and will not be sent to jail!
*/    else
    {
    DelayCommand(1.0,oReason(oPC,"Character Passed Checks"));
    }
}


