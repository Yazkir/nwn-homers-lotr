void main()
{
    object oPC = GetLastUsedBy();
    AssignCommand(oPC, JumpToObject(GetWaypointByTag("frombufftomain")));
}
