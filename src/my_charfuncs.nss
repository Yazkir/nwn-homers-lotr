int GetBestClass(object oChar)
{
    int nFirst;
    int nSecond;
    int nThird;

    nFirst = GetLevelByPosition(1,oChar);
    nSecond = GetLevelByPosition(2,oChar);
    nThird = GetLevelByPosition(3,oChar);

    if(nFirst >= nSecond && nFirst >= nThird)
        return nFirst;
    else if(nSecond >= nFirst && nSecond >= nThird)
        return nSecond;
    else if(nThird >= nFirst && nThird >= nSecond)
        return nThird;


    return nFirst;
}
