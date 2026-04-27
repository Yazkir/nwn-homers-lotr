void main()
{
object oPC = GetPCSpeaker();

AdjustAlignment(oPC, ALIGNMENT_NEUTRAL, 50);
ActionSpeakString("Adjusted 50 points to Neutral.");
}
