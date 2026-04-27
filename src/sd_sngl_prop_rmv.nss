void main()
{
    object oItem = GetFirstItemInInventory(OBJECT_SELF);

    if (GetIsObjectValid(oItem))
    {
        string sName = GetName(oItem);
        string sTag = GetTag(oItem);
        itemproperty prop = GetFirstItemProperty(oItem);
        string msg = "Name [" + sName + "]\nTag [" + sTag + "]\n";

        if (GetIsItemPropertyValid(prop))
        {
            string ptype = IntToString(GetItemPropertyType(prop));
            string psubtype = IntToString(GetItemPropertySubType(prop));
            string param1 = IntToString(GetItemPropertyParam1(prop));
            string param1val = IntToString(GetItemPropertyParam1Value(prop));
            string costTable = IntToString(GetItemPropertyCostTable(prop));
            string costTableValue = IntToString(GetItemPropertyCostTableValue(prop));

            msg += "Removing first property...\n";
            msg += "Property Type [" + ptype + "]\n";
            msg += "Property Sub Type [" + psubtype + "]\n";
            msg += "Parameter 1 [" + param1 + "]\n";
            msg += "Parameter 1 Value [" + param1val + "]\n";
            msg += "Cost Table [" + costTable + "]\n";
            msg += "Cost Table Value [" + costTableValue + "]\n";
            RemoveItemProperty(oItem, prop);
        }
        else
        {
            msg += "No properties detected!";
        }
        SpeakString(msg, TALKVOLUME_TALK);
    }
}
