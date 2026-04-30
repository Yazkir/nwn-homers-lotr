void main()
{
object oPC = GetPCSpeaker();

AdjustAlignment(oPC, ALIGNMENT_GOOD, 50);
ActionSpeakString("Adjusted 50 points to Good.");
}
