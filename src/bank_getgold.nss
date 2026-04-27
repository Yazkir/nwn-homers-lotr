void main()
{
    int gold = GetCampaignInt("Bank", "BankGold", GetLastSpeaker());
    SetCustomToken(4958, IntToString(gold));
}
