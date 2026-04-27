void main()
{
location lClick = GetItemActivatedTargetLocation();
CreateObject(OBJECT_TYPE_PLACEABLE, "bomb" , lClick);
}
