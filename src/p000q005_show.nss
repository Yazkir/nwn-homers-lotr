#include "nw_i0_plotwizard"
int StartingConditional()
{
	int nShow = GetLocalInt(GetPCSpeaker(), "p000state") >= 4;
	if (nShow)
	{
		PWSetMinLocalIntPartyPCSpeaker("p000state_ct_PlotGiver_AsnNP", 5);
		PWSetMinLocalIntPartyPCSpeaker("p000state", 5);
	}
	return nShow;
}
