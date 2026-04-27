//scoreboard tells the score to user
//aldaron 31032004/24042004

void main()
{
object oCTFScoreKeeper = GetObjectByTag("KOHScoreBoard");
int BlueScore = GetLocalInt(oCTFScoreKeeper, "BlueScore");
int RedScore = GetLocalInt(oCTFScoreKeeper, "RedScore");


string sBlueScore = IntToString (BlueScore);
string sRedScore = IntToString (RedScore);
string sScoreBoard = "Scores are: Blue Team: " + sBlueScore + " Red Team: " + sRedScore + ".";

ActionSpeakString (sScoreBoard, TALKVOLUME_TALK);


}
