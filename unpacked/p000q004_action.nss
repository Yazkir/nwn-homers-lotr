#include "nw_i0_plotwizard"
void main()
{
	PWSetMinLocalIntPartyPCSpeaker("p000state_ct_PlotGiver_AsnNP", 4);
	PWSetMinLocalIntPartyPCSpeaker("p000state", 4);
	PWGiveExperienceParty(GetPCSpeaker(), 100);
}
