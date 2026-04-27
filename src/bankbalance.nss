void main()
{
object oPC = GetPCSpeaker();

int newgp = GetCampaignInt("Bankgp",GetPCPublicCDKey(oPC));

    SetCustomToken(101,IntToString(newgp));

}
