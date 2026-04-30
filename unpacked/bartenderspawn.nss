//Sets the phrase to look for, and starts bartender listening
void main()
{
    SetListenPattern(OBJECT_SELF, "**please**", 69);
    SetListening(OBJECT_SELF, TRUE);
}
