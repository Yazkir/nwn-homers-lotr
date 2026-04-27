//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::: Shayan's Subrace Engine :::::::::::::::::::::::::::::
//:::::::::::::::::::::::File Name: _dm_subrace_lis2 :::::::::::::::::::::::::::
//:::::::::::::::::::::::::: OnConversation script :::::::::::::::::::::::::::::
//:: Written By: Shayan.
//:: Contact: mail_shayan@yahoo.com
//
// :: This script controls the OnConversation Event for the Subrace Listener.
// :: The Listener is used to detect DM speach.
void main()
{
   int nMatch = GetListenPatternNumber();
   object oSpeaker = GetLastSpeaker();
   if(GetLocalObject(OBJECT_SELF, "DM_SUMMONER") == oSpeaker)
   {
       if(nMatch == 8686)
       {
          SetLocalString(OBJECT_SELF, "DM_SUBRACE_CHOSEN", GetMatchedSubstring(0));
       }
   }
}
