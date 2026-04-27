void main()
{
location elbstreif1 = GetLocation(GetWaypointByTag("WP1_ElbStreife_01"));
location elbstreif2 = GetLocation(GetWaypointByTag("WP2_ElbStreife_02"));

DelayCommand(8.0, AssignCommand(OBJECT_SELF,ActionMoveToLocation (elbstreif1)));
DelayCommand(12.0, AssignCommand(OBJECT_SELF,ActionMoveToLocation (elbstreif2)));
}
