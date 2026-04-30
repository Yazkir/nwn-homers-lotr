#include "NW_I0_GENERIC"

void main()
{   int result = 0;
    int nChair = 1;
    object oChair;
    result = Random(5);
    //Remember to rename Chair01 to the tag of your particular chair
    oChair = GetNearestObjectByTag("Chair01d", OBJECT_SELF, nChair);
    switch(result){
        case 0: ClearAllActions();
                ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING, 1.0, 3.0);
                break;
        case 1: ClearAllActions();
                ActionPlayAnimation(ANIMATION_LOOPING_PAUSE_DRUNK, 1.0, 5.0);
                break;
        case 2: ClearAllActions();
                ActionRandomWalk();
                break;
        case 3: ClearAllActions();
                ActionSit(oChair);
                break;
        case 4: break;
        }
}
