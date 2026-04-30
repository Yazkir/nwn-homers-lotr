// Deletes character file
// Credit goes to Sean Anaya

void deletechar(string sPlayerName, string sCharName, object oPC);

void main()
{
    object oPC = GetPCSpeaker();
    object oMod = GetModule();
    string sPlayerName = GetPCPlayerName(oPC),
           sCharName = GetName(oPC);
    ActionSpeakString("Deleting in 5 seconds....");
    DelayCommand(5.0, deletechar(sPlayerName, sCharName, oPC));
}

void deletechar(string sPlayerName, string sCharName, object oPC)
  {
    object oMod = GetModule();
      string sPlayerName = GetPCPlayerName(oPC),
             sCharName = GetName(oPC);
      if (!GetIsPC(oPC)) return;
      ExportSingleCharacter(oPC);
      BootPC(oPC);
      if (GetStringLength(sPlayerName) < 1) return;
      AssignCommand(oMod, DelayCommand(0.2, SetLocalString(oMod, "NWNX!DELETECHAR!DELETE", sPlayerName + "?" + sCharName)));
  }

