void main()
{
object oPC = GetPCSpeaker();

AdjustAlignment(oPC, ALIGNMENT_EVIL, 50);
ActionSpeakString("Adjusted 50 points to Evil.");
}
