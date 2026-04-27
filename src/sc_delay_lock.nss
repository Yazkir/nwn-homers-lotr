void main()
{
    DelayCommand(3.0, ActionCloseDoor(OBJECT_SELF));
    DelayCommand(3.5, ActionLockObject(OBJECT_SELF));
    return;
}
