int Bad = 0 ;

//Main player scan
void main()
{
object oPC = GetEnteringObject();
string sName = GetName(oPC);
SetCommandable(FALSE,oPC);
DelayCommand(2.0,SetCommandable(TRUE,oPC));
object oEquipt;
object First_Next = GetFirstItemInInventory(oPC);
string Item_Name = GetName(First_Next);
if(GetIsPC(oPC))
{
SendMessageToPC(oPC,"<cß  >Vel.tesgames.com");
while(GetIsObjectValid(First_Next))
{

//Player scan continued
if(GetAbilityScore(oPC,ABILITY_CHARISMA)>56||
GetAbilityScore(oPC,ABILITY_CONSTITUTION)>56||
GetAbilityScore(oPC,ABILITY_DEXTERITY)>56||
GetAbilityScore(oPC,ABILITY_INTELLIGENCE)>56||
GetAbilityScore(oPC,ABILITY_STRENGTH)>56||
GetAbilityScore(oPC,ABILITY_WISDOM)>56)
{
SendMessageToPC(oPC,"<cã>Invalid Ability Score");
Bad = 1 ;
}
if(GetSkillRank(SKILL_ALL_SKILLS,oPC)>125)
{
SendMessageToPC(oPC,"<cã>Invalid Skill Points");
Bad = 1 ;
}
if(GetAC(oPC)>146)
{
SendMessageToPC(oPC,"<cã>Invlaid AC");
Bad = 1 ;
}
if(GetFortitudeSavingThrow(oPC)>80||
GetReflexSavingThrow(oPC)>80||
GetWillSavingThrow(oPC)>80)
{
Bad = 1 ;
SendMessageToPC(oPC,"<cã>Invalid Saves");
}

if(GetMaxHitPoints(oPC)>1380)
{
Bad = 1 ;
SendMessageToPC(oPC,"<cã>Invalid HP");
}

if(GetImmortal(oPC))
{
SendMessageToPC(oPC,"<cã>Immortal Flag Detected");
Bad = 1 ;
}

if(GetBaseAttackBonus(oPC)>30)
{
SendMessageToPC(oPC,"<cã>Epic Level Bug Detected");
Bad = 1 ;
}
if(Bad == 1 )
{
object oPC = GetLastSpeaker();
object theWayPiont = GetWaypointByTag("jail");
location rivendalia = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(rivendelia));
}
