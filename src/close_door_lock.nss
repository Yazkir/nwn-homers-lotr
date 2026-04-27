void main()
{
DelayCommand(2.0f,ActionCloseDoor(OBJECT_SELF));
DelayCommand(2.5f,SetLocked(OBJECT_SELF,TRUE));
}
