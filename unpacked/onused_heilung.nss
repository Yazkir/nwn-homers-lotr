/////////////////////////////
//                         //
//   Stefan Thieme, 2003   //
//                         //
/////////////////////////////

// Dieses Script steuert die Heilung

// Platzieren Sie deises Script im OnUsed-Event eines platzierbaren Objektes

void main()
{
    object oUser = GetLastUsedBy();
    int oTP =  GetMaxHitPoints(oUser) - GetCurrentHitPoints(oUser);
    effect oHeilung = EffectHeal(oTP);
    effect eHeilung = EffectVisualEffect(VFX_IMP_RESTORATION_GREATER);
    effect eKrankheit = GetFirstEffect(oUser);

    // Trefferpunkte wiederherstellen
    ApplyEffectToObject(DURATION_TYPE_INSTANT, oHeilung, oUser);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeilung, oUser);

    // Krankheiten kurieren
    do{
        object oVerursacher = GetEffectCreator(eKrankheit);
        if (oVerursacher != oUser)
                RemoveEffect(oUser, eKrankheit);
    }while((GetIsEffectValid(eKrankheit = GetNextEffect(oUser))) != FALSE);
}
