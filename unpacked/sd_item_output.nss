// ****************************************************************
//
// @project Moo Filter 1.1
// @author Sean Darrenkamp
// @date 5/7/2004
// @file sd_item_output
// Copyright 2004 Sean Darrenkamp
//
// This code is licensed under the GPL for use. See the GNU.org
// site for more information.
//
// http://www.gnu.org/licenses/gpl.html
//
// ****************************************************************

//
// Notes: I used this script attached to a barrels onOpen event to view
//        item properties on things. This gave me the information I needed
//        to generate the script for filtering things. Use it to snag item's
//        properties that arn't wanted and add them to the filterSignature()
//        method in sd_filter_inc. Think of this as the tool to get new NWN
//        "Virus" signatures. :)
//

// Report the properties on an item.
void report(object oItem)
{
    itemproperty prop = GetFirstItemProperty(oItem);

    AssignCommand(OBJECT_SELF, SpeakString("Scanning [" + GetName(oItem) + "]", TALKVOLUME_TALK));
    AssignCommand(OBJECT_SELF, SpeakString("Tag [" + GetTag(oItem) + "]", TALKVOLUME_TALK));

    while (GetIsItemPropertyValid(prop))
    {
        int ptype = GetItemPropertyType(prop);
        int psubtype = GetItemPropertySubType(prop);
        int param1 = GetItemPropertyParam1(prop);
        int param1val = GetItemPropertyParam1Value(prop);
        int costTable = GetItemPropertyCostTable(prop);
        int costTableValue = GetItemPropertyCostTableValue(prop);
        string msg = "Property Type [" + IntToString(ptype) + "]\n";
               msg += "Property Sub Type [" + IntToString(psubtype) + "]\n";
               msg += "Parameter 1 [" + IntToString(param1) + "]\n";
               msg += "Parameter 1 Value [" + IntToString(param1val) + "]\n";
               msg += "Cost Table [" + IntToString(costTable) + "]\n";
               msg += "Cost Table Value [" + IntToString(costTableValue) + "]\n";

        AssignCommand(OBJECT_SELF, SpeakString(msg, TALKVOLUME_TALK));

        prop = GetNextItemProperty(oItem);
    }
}

// Main method that loops through items in the objects inventory.
void main()
{
    object oItem = GetFirstItemInInventory(OBJECT_SELF);

    while (GetIsObjectValid(oItem))
    {
        report(oItem);
        oItem = GetNextItemInInventory(OBJECT_SELF);
    }
}
