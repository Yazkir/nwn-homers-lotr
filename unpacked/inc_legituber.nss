/*
Butchas Legit Ubering & Lame fix OnEnter Script
Scripted By:Butcha
s_tossmann@hotmail.com
*/
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#include "x2_inc_itemprop"
//Check For Not alowed propertys
//Scripted BY:BUTCHA
void RemovePropertys(object oItem);
//Check For Item STack max = 255
//Scripted BY:BUTCHA
void CheckItemStack(object oItem);
//Identivy alle items
//Scripted BY:BUTCHA
void Identivy(object oItem);
//Remove Largebox
//Scripted BY:BUTCHA
void RemoveBox(object oItem);
//Destroy Thieved items
//Scripted BY:BUTCHA
void CheckThieveFlag(object oItem);
//Destroy monster slots
//Scripted BY:BUTCHA
void DestroyMosnterslot(object oPC);
//Remvoe Shop Items
//Scripted BY:BUTCHA
void CheckForShopItem(object oItem,object oPC);
//Check For DlChars
//Scripted BY:BUTCHA
void CheckForDlChars(object oPC);
//Send message to all player
//Scripted BY:BUTCHA
void SendPuplicMessage(string sMessage);
//Script information
//Scripted BY:BUTCHA
void InformationMessage(object oPC);
//STart the LegitUber script whit this command
//Scripted BY:BUTCHA
void StartCheck(object oPC);
//Add items to spetzific player
//Scripted BY:BUTCHA
void ItemForSpetzificPlayer(object oPC,string sPlayer,string sItem);
//Player bann  Onenter
//Scripted BY:BUTCHA
void Autoboot(object oPC,string sAccount,string sKey,string sIp,int iVisual);
//Chance appearance to a another if hes NOT a normal appearance
//Scripted BY:BUTCHA
void CheckAppearance(object oTarget,int Newappearance);
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//Chech For Not alowed propertys
void RemovePropertys(object oItem)
{
itemproperty Old_Property = GetFirstItemProperty(oItem);
while(GetIsItemPropertyValid(Old_Property))
{
if((GetItemPropertyType(Old_Property) == ITEM_PROPERTY_DAMAGE_VULNERABILITY)||
   (GetItemPropertyType(Old_Property) == ITEM_PROPERTY_DECREASED_ABILITY_SCORE)||
   (GetItemPropertyType(Old_Property) == ITEM_PROPERTY_DECREASED_AC)||
   (GetItemPropertyType(Old_Property) == ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER)||
   (GetItemPropertyType(Old_Property) == ITEM_PROPERTY_DECREASED_DAMAGE)||
   (GetItemPropertyType(Old_Property) == ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER)||
   (GetItemPropertyType(Old_Property) == ITEM_PROPERTY_DECREASED_SAVING_THROWS)||
   (GetItemPropertyType(Old_Property) == ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC)||
   (GetItemPropertyType(Old_Property) == ITEM_PROPERTY_DECREASED_SKILL_MODIFIER)||
   (GetItemPropertyType(Old_Property) == ITEM_PROPERTY_NO_DAMAGE)||
   (GetItemPropertyType(Old_Property) == ITEM_PROPERTY_WEIGHT_INCREASE)||
   (GetItemPropertyType(Old_Property) == ITEM_PROPERTY_DAMAGE_VULNERABILITY)||
   (GetItemPropertyType(Old_Property) == ITEM_PROPERTY_TURN_RESISTANCE)||
   (GetItemPropertyType(Old_Property) == ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC)||
   (GetItemPropertyType(Old_Property) == ITEM_PROPERTY_AC_BONUS_VS_ALIGNMENT_GROUP)||
   (GetItemPropertyType(Old_Property) == ITEM_PROPERTY_AC_BONUS_VS_DAMAGE_TYPE)||
   (GetItemPropertyType(Old_Property) == ITEM_PROPERTY_AC_BONUS_VS_RACIAL_GROUP)||
   (GetItemPropertyType(Old_Property) == ITEM_PROPERTY_AC_BONUS_VS_SPECIFIC_ALIGNMENT)||
   (GetItemPropertyType(Old_Property) == ITEM_PROPERTY_ON_MONSTER_HIT)||
   (GetItemPropertyType(Old_Property) == ITEM_PROPERTY_ON_HIT_PROPERTIES)||
   (GetItemPropertyType(Old_Property) == ITEM_PROPERTY_THIEVES_TOOLS)||
   (GetItemPropertyType(Old_Property) == ITEM_PROPERTY_CAST_SPELL)||
   (GetItemPropertyType(Old_Property) == ITEM_PROPERTY_POISON))
  {
RemoveItemProperty(oItem, Old_Property);
}
Old_Property = GetNextItemProperty(oItem);
}
}
//Destroy Stolen items
void CheckThieveFlag(object oItem)
{
if(GetStolenFlag(oItem) == TRUE)
{
DestroyObject(oItem);
}
}
//Remove items whit more then 150 propertys
void CheckItemStack(object oItem)
{
if(IPGetNumberOfItemProperties(oItem)>150)
{
DestroyObject(oItem);
}
}
//Identivy all inventory items(before the item check)
void Identivy(object oItem)
{
if(GetIdentified(oItem) == FALSE)
{
SetIdentified(oItem,TRUE);
}
}
//Remvoe largebox FIx chest bugg
void RemoveBox(object oItem)
{
if((GetBaseItemType(oItem) == 66)||
   (GetBaseItemType(oItem) == 23)||
   (GetBaseItemType(oItem) == 30)||
   (GetBaseItemType(oItem) == 43)||
   (GetBaseItemType(oItem) == 306)||
   (GetBaseItemType(oItem) == 48)||
   (GetBaseItemType(oItem) == 54)||
   (GetBaseItemType(oItem) == 67)||
   (GetBaseItemType(oItem) == 68))
  {
DestroyObject(oItem);
}
}

void CheckForShopItem(object oItem,object oPC)
{
string sItenName = GetName(oItem);
if((GetStringLeft(GetTag(oItem),8)=="DeadFred")||
(GetStringLeft(GetName(oItem),4)=="Zurc")||
(GetStringLeft(GetName(oItem),4)=="Vamp")||
(GetStringLeft(GetTag(oItem),10)=="cc3cLceccc")||
(GetStringLeft(GetTag(oItem),3)=="HFA")||
(GetStringRight(GetTag(oItem),3)=="HFA"))
{
SetLocalInt(oPC,"iIUseShit",1);
AssignCommand(oPC,ActionSpeakString("<cë>Im a noob and use <cò>"+sItenName+"<cë> Gear",TALKVOLUME_SHOUT));
DestroyObject(oItem);
}
if(GetLocalInt(oPC,"iIUseShit")== 1)
{
WriteTimestampedLogEntry("Shop Items Detected: Name ="+GetName(oPC)+" / Acc="+GetPCPlayerName(oPC)+" / Tag="+GetTag(oPC)+" / Key ="+GetPCPublicCDKey(oPC)+" / Ip="+GetPCIPAddress(oPC));
}
}
void CheckForDlChars(object oPC)
{
if((GetTag(oPC)=="BanishedDLSpawn")||
   (GetTag(oPC)=="RAIDEN")||
   (GetTag(oPC)=="BODY")||
   (GetTag(oPC)=="UBER"))
 {
SetLocalInt(oPC,"iIUseDL",1);
AssignCommand(oPC,ActionSpeakString("<cë>My Character is a Stupid <cò>Download ! !<cë>..Now I Get Booted",TALKVOLUME_SHOUT));
DelayCommand(10.0,BootPC(oPC));
}
if(GetLocalInt(oPC,"iIUseDL")==1)
{
WriteTimestampedLogEntry("Download Char Detected: Name ="+GetName(oPC)+" / Acc="+GetPCPlayerName(oPC)+" / Tag="+GetTag(oPC)+" / Key ="+GetPCPublicCDKey(oPC)+" / Ip="+GetPCIPAddress(oPC));
}
}
//send message to all Player
void SendPuplicMessage(string sMessage)
{
object oPC =  GetFirstPC();
while(GetIsObjectValid(oPC))
{
SendMessageToPC(oPC,sMessage);
oPC = GetNextPC();
}
}
//Strings messages & information
void InformationMessage(object oPC)
{
string sName1 = GetName(oPC);
string sName2 = GetPCPlayerName(oPC);
string sKey   = GetPCPublicCDKey(oPC);
string skey1  = GetPCIPAddress(oPC);
int iMamber = GetCampaignInt("cRegistred","iMamber",oPC);
string sMamber = IntToString(iMamber);
string sMessage;
string sInfoMessage;
sMessage +="<cÕÉ‹>Player Joined";
sMessage +="\n";
sMessage +="<c0-(>---------------------<cÕÉ‹><<-->><c0-(>---------------------";
sMessage +="\n";
sMessage +="<cÕÉ‹>Name</c= "+sName1;
sMessage +="\n";
sMessage +="<cÕÉ‹>Account</c= <cü>"+sName2;
sMessage +="\n";
sMessage +="<cÕÉ‹>Identifications CdKey</c= <cü>"+sKey;
sMessage +="\n";
sMessage +="<cÕÉ‹>Ip Of Player</c= <cü>"+skey1;
sMessage +="\n";
sMessage +="<c0-(>---------------------<cÕÉ‹><<-->><c0-(>---------------------";
SendPuplicMessage(sMessage);
}
//creatan item for spetzific player
void ItemForSpetzificPlayer(object oPC,string sPlayer,string sItem)
{
if(GetPCPlayerName(oPC) == sPlayer)
{
CreateItemOnObject(sItem,oPC,1);
}
}
void Autoboot(object oPC,string sAccount,string sKey,string sIp,int iVisual)
{
effect eVFX = EffectVisualEffect(iVisual);
if(GetPCPlayerName(oPC) == sAccount ||
  (GetPCPublicCDKey(oPC) == sKey ||
  (GetPCIPAddress(oPC) == sIp)))
{
DelayCommand(8.0,FloatingTextStringOnCreature("<cï¥>You Was Been banned",oPC));
DelayCommand(10.0,FloatingTextStringOnCreature("<cï¥>Auto boot activated!",oPC));
DelayCommand(10.8,ApplyEffectToObject(DURATION_TYPE_INSTANT,eVFX,oPC));
DelayCommand(12.0,BootPC(oPC));
}
}
void CheckAppearance(object oTarget,int Newappearance)
{
if((GetAppearanceType(oTarget) > 6)||
   (GetAppearanceType(oTarget)==APPEARANCE_TYPE_INVISIBLE_HUMAN_MALE))
{
SetCreatureAppearanceType(oTarget,Newappearance);
}
}
void StartCheck(object oPC)
{
object oItem;
int FirstNext;
if((GetIsPC(oPC) == TRUE)&&(GetIsDM(oPC) == FALSE))//Check only Pc (not dm or creatures)
{
SetPlotFlag(oPC,FALSE);//Remove Plot
SetImmortal(oPC,FALSE);//Remove Immortal
for(FirstNext = 0;FirstNext<13;FirstNext++)
{
//Check Equipt inventory
oItem = GetItemInSlot(FirstNext,oPC);
if(GetIsObjectValid(oItem))
{
Identivy(oItem);
DelayCommand(1.0,CheckItemStack(oItem));
DelayCommand(2.0,CheckThieveFlag(oItem));
DelayCommand(3.0,RemoveBox(oItem));
DelayCommand(4.0,RemovePropertys(oItem));
//DelayCommand(5.0,CheckForShopItem(oItem,oPC));
}
//Check UnEquipt Inventory
oItem = GetFirstItemInInventory(oPC);
while (GetIsObjectValid(oItem))
{
Identivy(oItem);
DelayCommand(1.0,CheckItemStack(oItem));
DelayCommand(2.0,CheckThieveFlag(oItem));
DelayCommand(3.0,RemoveBox(oItem));
DelayCommand(4.0,RemovePropertys(oItem));
//DelayCommand(5.0,CheckForShopItem(oItem,oPC));
oItem = GetNextItemInInventory(oPC);
}
}
InformationMessage(oPC);
DelayCommand(6.6,DestroyMosnterslot(oPC));
DelayCommand(7.0,CheckAppearance(oPC,APPEARANCE_TYPE_HUMAN));
//DelayCommand(8.0,CheckForDlChars(oPC));
if((GetLevelByClass(CLASS_TYPE_WEAPON_MASTER,oPC)==38)&&(GetLevelByClass(CLASS_TYPE_PALADIN,oPC)==1))
{
DelayCommand(10.0,AssignCommand(oPC,ActionSpeakString("<c××>My Classes Are Bugged(<cõ>38 <cï>Weaponmaster <cï>& <cõ>1 <cï>Paladin)<c××> Time to be Booted",TALKVOLUME_SHOUT)));
DelayCommand(15.0,BootPC(oPC));
}
}
}

