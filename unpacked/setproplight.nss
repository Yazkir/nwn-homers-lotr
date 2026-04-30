void main()
{
    SetLocalString(GetPCSpeaker(), "MODIFY_PROPERTY", "Light");
    SetLocalInt(GetPCSpeaker(), "MODIFY_PARAM2", IP_CONST_LIGHTBRIGHTNESS_BRIGHT);
    SetLocalInt(GetPCSpeaker(), "MODIFY_PARAM3", IP_CONST_LIGHTCOLOR_WHITE);
}
