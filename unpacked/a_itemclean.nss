void CheckItem()
{

    if (GetItemPossessor(OBJECT_SELF) == OBJECT_INVALID)
    {
        int nUnAcqCount = GetLocalInt(OBJECT_SELF, "unacqcount") + 1;
        if(nUnAcqCount<4)
        {
            DelayCommand(150.0, CheckItem());
            SetLocalInt(OBJECT_SELF, "unacqcount", nUnAcqCount);
        }
        else if (nUnAcqCount>=4)
        {
            DestroyObject(OBJECT_SELF);
        }
    }
    else DeleteLocalInt(OBJECT_SELF, "unacqcount");
}

void main()
{
    if (GetItemPossessor(OBJECT_SELF) == OBJECT_INVALID) //Has someone picked up the item?
    {
        SetLocalInt(OBJECT_SELF, "unacqcount", 1);
        DelayCommand(150.0, CheckItem());
    }
}
