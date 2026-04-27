void main()
{
    object oPc = GetPCSpeaker();
    int nCurxp = GetXP(oPc);
    int nCurlevel = GetHitDice(oPc);
    int nDelevelxp = ((nCurlevel-1)*(nCurlevel-2))*500;
    SetXP(oPc, nDelevelxp);
    SetXP(oPc, nCurxp);
}
