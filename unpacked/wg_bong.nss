///called from a placeable.. runs a circle around PC in slowmo while he falls, and generates some fx and whatnot.
///i've noticed a bit of camera angle lag if the module is running lengthy amounts

#include "cameraslowmo"
#include "lib_witchgrass"
#include "color"

void main()
{
object oMaster = GetLastUsedBy();
object oPC = OBJECT_SELF;
location lLoc;
float duration = HoursToSeconds(1);
{
object oBud = GetItemPossessedBy(oMaster,"witchbud");
AssignCommand(oMaster,ClearAllActions());

  if( oBud != OBJECT_INVALID )
{

SetCutsceneMode(oPC,TRUE);
    DelayCommand(10.0,SetCutsceneMode(oPC,FALSE));
    AssignCommand(oPC,StoreCameraFacing());
    DelayCommand(1.5,AssignCommand(oPC,PlayAnimation(ANIMATION_LOOPING_DEAD_BACK,1.0,8.0)));
    DelayCommand(1.7,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectVisualEffect(VFX_DUR_FREEZE_ANIMATION),oPC,5.0));
    GestaltCameraMove(1.7,GetFacing(oPC) + 90.0,18.0,30.0,GetFacing(oPC) + 450.0,12.0,50.0,5.0,40.0,oPC);

effect eSlow = EffectMovementSpeedDecrease(20);
effect eSpot = EffectSkillIncrease(SKILL_SPOT,2);
effect eWis = EffectAbilityIncrease(ABILITY_WISDOM,4);
effect eInt = EffectAbilityDecrease(ABILITY_INTELLIGENCE,2);

     ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eSlow, oPC, duration);
     ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eSpot, oPC, duration);
     ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eWis, oPC, duration);
     ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eInt, oPC, duration);


switch (d100())
{
                case 0:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >Mmm, thats the cronic, I gots to get effed up.")));
                    break;
                case 1:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >I'm a dope fiend baby, I dunno why, all I wanna do is get high.")));
                    break;
                case 2:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >Now I'm sleeping on the sidewalk and I know why, yaaay, because I got high, because I got high, because I got hiiiigh.")));
                    break;
                case 3:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >A-E-I-O-U, and sometimes W.")));
                    break;
                case 4:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >What? No. We can't stop here. This is bat country.")));
                    break;
                case 5:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >Hmm, I wonder if Heaven has got a ghetto.")));
                    break;
                case 6:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >Billie Jean is not my lover, she's a girl who claims that IIIII am the one... but the kid is not my son...dum chika dow wow")));
                    break;
                case 7:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >I like big butts and I cannot lie.")));
                    break;
                case 8:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >My milkshake brings all the boys to the yard.")));
                    break;
                case 9:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >Do you wonder what its like, living in a permanent imagination, sleeping to escape reality, but you like it like that.")));
                    break;
                case 10:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >We're just two lost souls, swimmming in a fish bowl.")));
                    break;
                case 11:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >If you don't eat yer meat, you can't have any pudding. How can you have any pudding if you don't eat your meat?")));
                    break;
                case 12:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >There is no pain, you are receding. A distant ship�s smoke on the horizon. You are only coming through in waves. Your lips move but I can�t hear what you�re sayin�. When I was a child I had a fever. My hands felt just like two balloons. Now I got that feeling once again. I can�t explain, you would not understand. This is not how I am. I have become comfortably numb.")));
                    break;
                case 13:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >Your head is humming and it won't go, in case you don't know, The piper's calling you to join him, Dear lady, can you hear the wind blow, and did you know Your stairway lies on the whispering wind.")));
                    break;
                case 14:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >Tangerine, Tangerine, Living reflection from a dream; I was her love, she was my queen, And now a thousand years between.")));
                    break;
                case 15:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >Lucy, is an artist. Lucy paints pictures of Barbara Streisand.")));
                    break;
                case 16:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >We've gotta get out of here. I think I'm getting the fear man.")));
                    break;
                case 17:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >As your attorney, I advise you to take a hit out of the little brown flask in my shaving kit.")));
                    break;
                case 18:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >We were just walking down this trail and I swear there was this noise 'Rawgh!!!' and it starting moving again.. I almosted crapped myself. No joke.....")));
                    break;
                case 19:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >You've gone all sideways, man.")));
                    break;
                case 20:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >Did I say two fingers? Better make that three.")));
                    break;
                case 21:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >I'm the backwards man, the backwards man, I can run back as fast as you can.")));
                    break;
                case 22:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >I'm a sophisticated sex robot sent back through time, to change the future for one lucky lady. ")));
                    break;
                case 23:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >He was my C.O. in NAM. CIA listed him as M.I.A. but the V.A. ID'd him and so we put out an APB.")));
                    break;
                case 24:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >Let me tell you something, bandejo. You pull any of your crazy stuff with us, you flash a piece out on the lanes, I'll take it away from you, stick it up your a** and pull the f*****g trigger 'til it goes 'click.' ")));
                    break;
                case 25:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >What's a... pederast, Walter?")));
                    break;
                case 26:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >Jackie Treehorn treats objects like women, man.")));
                    break;
                case 27:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >Ah - deh sah-sez-fren-forcher, and dah scar-her-cushons, wit dah matsen-seck-way-Core-Ver ")));
                    break;
                case 28:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >I'm a mog: half man, half dog. I'm my own best friend!")));
                    break;
                case 29:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � ># 9, # 9, # 9, # 9.....")));
                    break;
                case 30:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >Well hello Mister Fancypants. Well, I've got news for you pal, you ain't leadin' but two things: Jack and shit... and Jack just left town.")));
                    break;
                case 31:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >Gimme some sugar, baby.")));
                    break;
                case 32:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >It was a space ship. And there was these things, these killer clowns, and they shot popcorn at us! We barely got away!")));
                    break;
                case 33:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >And I like Vicki and she likes me back. And she showed me her boobies and I like them too.")));
                    break;
                case 34:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >Oh, but you can't expect to wield supreme executive power just because some watery tart threw a sword at you.")));
                    break;
                case 35:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >Are you suggesting coconuts migrate?")));
                    break;
                case 36:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >Yes, shrubberies are my trade. I am a shrubber. My name is Roger the Shrubber. I arrange, design, and sell shrubberies.")));
                    break;
                case 37:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >All I've ever wanted was an honest week's pay for an honest day's work.")));
                    break;
                case 38:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >You know what the trouble about real life is? There's no danger music")));
                    break;
                case 39:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >I was born a poor black child, ate grit and catfish fo breakfast.")));
                    break;
                case 40:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >I'm picking out a Thermos for you. Not an ordinary Thermos for you. But the extra best Thermos that you can buy, with vinyl and stripes and a cup built right in. ")));
                    break;
                case 41:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >Is that a ten-gallon hat, or are you just enjoying the show?")));
                    break;
                case 42:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >Time is never wasted when your wasted all the time.")));
                    break;
                case 43:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >You can turn your back on a person, but, never turn your back on a drug. Especially when it's waving a razor-sharp hunting knife in your eye.")));
                    break;
                case 44:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >Your mother was a Hamster and your father smelt of elderberries!")));
                    break;
                case 45:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >Good evening Sir, my name is Steve. I come from a rough area. I used to be addicted to crack but now I am off it and trying to stay clean. That is why I am selling magazine subscriptions.")));
                    break;
                case 46:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >He asked me to forcibly insert the Life Line exercise card into my anus.")));
                    break;
                case 47:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >Canadians are always dreaming up a lotta ways to ruin our lives. The metric system, for the love of God! Celsius! Neil Young!")));
                    break;
                case 48:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >Yes, that's right, I saw the Terrance and Phillip movie. Now who wants to touch me? ")));
                    break;
                case 49:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >We accidentally replaced your heart with a baked potato. You have about three seconds to live.")));
                    break;
                case 50:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >Phew! I haven't felt that good since Archie Gemmill scored against Holland in 1978!")));
                    break;
                case 51:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >You can get a good look at a T-bone steak by sticking your head up a butcher's ass, but wouldn't you rather to take his word for it?")));
                    break;
                case 52:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >You kids better pray to the god of skinny punks this wind doesn't pick up, cuz if it does I'm gonna sail over there and shove an oar up your ass.")));
                    break;
                case 53:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >Do you know where the weight room is? I'll check it out.")));
                    DelayCommand(5.0f, AssignCommand(oMaster, ActionPlayAnimation(ANIMATION_LOOPING_TALK_FORCEFUL)));
                    break;
                case 54:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >I've seen monkey-shyt fights at the zoo that are more organized than this. ")));
                    break;
                case 55:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >Girls only want boyfriends who have great skills. You know, like nunchuck skills, bowhunting skills, computer hacking skills...")));
                    break;
                case 56:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >This famous linguist once said that of all the phrases in the english language, of all the endless combonations of words in all of history, that cellar door is the most beautiful.")));
                    break;
                case 57:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >Excuse me, is your refrigerator running? Because if it is, it probably runs like you, very homosexually.")));
                    break;
                case 58:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >I never knew anyone who went crazy before, except for my invisible friend, Col. Schwartz.")));
                    break;
                case 59:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >Damn the toilet. It's made slaves of you all. It just sits there consuming other people's feces while contributing nothing of its own to society. ")));
                    break;
                case 60:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >No, you idiot. That's not baby powder, that's paprika. Ahhhhhh. Take that.")));
                    break;
                case 61:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >If I'm a child, you know what that makes you? A child molester, and I'll be damned if I stand here and get lectured by pervert.")));
                    break;
                case 62:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >HA! That's so funny I forgot to laugh! Excluding that first 'ha'.")));
                    break;
                case 63:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >Hello, China? I have something you may want. But it's gonna cost ya. That's right. All the tea.")));
                    break;
                case 64:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >Lost in oblivion. Dark and silent and complete. I found freedom. Losing all hope was freedom.")));
                    break;
                case 65:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � > # 9, #9, # 9, # 9.....")));
                    break;
                case 66:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >I dont think you trust in my, self righteous suicide. I cry when angels deserve to DIEEEEE!")));
                    break;
                case 67:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >Bright and early for the daily races, going nowhere. The tears are filing up their glasses, no expression.")));
                    break;
                case 68:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >You can have my isolation, You can have the hate that it brings, You can have my absence of faith, You can have my everything ")));
                    break;
                case 69:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >I'm tearing away. Pieces are falling, I cant seem to make them stay.  You run away. Fasters and faster, you cant seem to get away.... BREAK!")));
                    break;
                case 70:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >Gripping the wheel, his knuckles went white with desire! The wheels of his Mustang exploding on the highway like a slug from a .45. True death: 400 horsepower of maximum performance piercing the night... This is, black sunshine.")));
                    break;
                case 71:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >My mouth was a crib and it was growing lies I didn't know what love was on that day my heart's a tiny bloodclot I picked at it it never heals it never goes away.")));
                    break;
                case 72:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >We were out on a date in my daddy's car, we hadn't driven very far.  There in the road, straight ahead, a car was stalled, the engine was dead.  I couldnt stop, so I swerved to right. I'll never forget the sound that night, the screaming tires, the busting glass.  The painful scream that IIIII heard last.")));
                    break;
                case 73:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >It's Bone-N-Biggy, Biggy!! It's Bone-N-Biggy, Biggy!! It's Bone-N-Biggy, Biggy!! ")));
                    break;
                case 74:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >No one knows what it's like, To be the bad man, To be the sad man, Behind blue eyes, No one knows what it's like, To be hated, To be fated, To telling only lies, But my dreams, They aren't as empty, As my conscience seems to be, I have hours, only lonely, My love is vengeance,That's never free. ")));
                    break;
                case 75:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >Gimme that funk, that sweeet, that nasty, that gushy stuff.")));
                    break;
                case 76:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >Breathe it in and breath it out and pass it on,it's almost out. We're so creative,so much more, we're high above but on the floor. It's not an habit,it's cool,I feel alive. If you don't have it you're on the other side.")));
                    break;
                case 77:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >DU...DU HAST... DU HAST MICH.. DU HAST MICH GEFRAGT... DU HAST MICH GEFRAGT... UND ICH HAB NICHTS GESAGT!!")));
                    break;
                case 78:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >Do you know what it's like to fall in the mud and get kicked... in the head... with an iron boot? Of course you don't, no one does. It never happens. It's a dumb question... skip it.")));
                    break;
                case 79:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >You stay away from that ficus. That is a jiz-free ficus.")));
                    break;
                case 80:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >Sexually transmitted disease? Hello no!! Not me!... ")));
                    break;
                case 81:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >...Well, I have been feeling a burning sensation when I go the latrine?")));
                    break;
                case 82:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >No wonder Santa's so jolly, he knows where all the bad girls live.")));
                    break;
                case 83:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >I wonder why the #2 pencil is still #2.")));
                    break;
                case 84:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >It's beer o'clock, and I'm buying.")));
                    break;
                case 85:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >Five-foot-nine? I didn't know they stacked shit that high.")));
                    break;
                case 86:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >Noinch, Noinch, Noinch, Schmokin Weed, Schmokin' Weed, Doin' Coke, Drinkin' Beers...")));
                    break;
                case 87:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � > #9, # 9, # 9, # 9... ")));
                    break;
                case 88:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >I'm just trying to make a smudge on the collective unconscious. ")));
                    break;
                case 89:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >Every day I get up and look through the Forbes list of the richest people in America. If I'm not there, I go to work.")));
                    break;
                case 90:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >I like simple pleasures, like Half Dwarfs in black pumps and a matching mini-skirt .")));
                    break;
                case 91:     /////where i gave up
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >I like simple pleasures, like butter in my ass, lollipops in my mouth. That's just me. That's just something that I enjoy. ")));
                    break;
                case 92:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >It's beer o'clock, and I'm buying. ")));
                    break;
                case 93:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >I'm the backwards man, the backwards man, I can run back as fast as you can.")));
                    break;
                case 94:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >Hail to the king.")));
                    break;
                case 95:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >That's just pillow talk, baby")));
                    break;
                case 96:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >You wanta go get some Cantonese Bar B-Q? ")));
                    break;
                case 97:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >I never knew anyone who went crazy before, except for my invisible friend, Col. Schwartz.")));
                    break;
                 case 98:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >What's a... pederast, Walter?")));
                    break;
                case 99:
                    DelayCommand(5.0f, AssignCommand(oMaster,ActionSpeakString("<c � >Are you suggesting coconuts migrate?")));
                    break;
                }

DelayCommand(0.3f,ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_FNF_SMOKE_PUFF),oMaster));
DelayCommand(0.5f,ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_DUR_GHOSTLY_PULSE),oMaster));
DelayCommand(0.5f,ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_FNF_SCREEN_BUMP),oMaster));
DestroyObject(oBud);

effect eSleep = EffectSleep();
DelayCommand(40.5f,ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSleep, oMaster, 20.0f));
DelayCommand(40.5f,ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_IMP_SLEEP),oMaster, 20.0f));

}
  else
     {
     AssignCommand(oMaster,ActionSpeakString("I don't have anything to smoke! =("));
     }
 }
}
