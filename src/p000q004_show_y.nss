int StartingConditional()
{
	int nShow = GetLocalInt(GetPCSpeaker(), "p000state") >= 3;
	return nShow;
}
