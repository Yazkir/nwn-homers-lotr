void main() {

object oPC = GetPCSpeaker();

if (GetIsPC(oPC)) {
     int currHP = GetCurrentHitPoints(oPC);
     int maxHP = GetMaxHitPoints(oPC);
     if(currHP < maxHP) {
       ActionCastSpellAtObject(SPELL_HEAL, oPC, METAMAGIC_ANY, 0, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
        SpeakString("There you go!", 5);
     } else {
        SpeakString("But, you don't need healing... I'm sorry. See me again when you need some healing.", 5);
     }
}

}
