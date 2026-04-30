//bunch of colors, use as an include

const string COLOR_BLUE         = "<cfÌþ>";
const string COLOR_DARK_BLUE    = "<c fþ>";
const string COLOR_GRAY         = "<c®®®>";
const string COLOR_GREEN        = "<c þ >";
const string COLOR_LIGHT_BLUE   = "<c®þþ>";
const string COLOR_LIGHT_GRAY   = "<c°°°>";
const string COLOR_LIGHT_ORANGE = "<cþ® >";
const string COLOR_LIGHT_PURPLE = "<cÌ®Ì>";
const string COLOR_ORANGE       = "<cþf >";
const string COLOR_PURPLE       = "<cÌwþ>";
const string COLOR_RED          = "<cþ  >";
const string COLOR_WHITE        = "<cþþþ>";
const string COLOR_YELLOW       = "<cþþ >";
const string COLOR_NONE         = "";
const string COLOR_END          = "</c>";

int GetIsColorTagValid( string sColorTag);
int GetIsColorTagValid( string sColorTag)
{ if( sColorTag == COLOR_BLUE)         return TRUE;
  if( sColorTag == COLOR_DARK_BLUE)    return TRUE;
  if( sColorTag == COLOR_GRAY)         return TRUE;
  if( sColorTag == COLOR_GREEN)        return TRUE;
  if( sColorTag == COLOR_LIGHT_BLUE)   return TRUE;
  if( sColorTag == COLOR_LIGHT_GRAY)   return TRUE;
  if( sColorTag == COLOR_LIGHT_ORANGE) return TRUE;
  if( sColorTag == COLOR_LIGHT_PURPLE) return TRUE;
  if( sColorTag == COLOR_ORANGE)       return TRUE;
  if( sColorTag == COLOR_PURPLE)       return TRUE;
  if( sColorTag == COLOR_RED)          return TRUE;
  if( sColorTag == COLOR_WHITE)        return TRUE;
  if( sColorTag == COLOR_YELLOW)       return TRUE;
  return FALSE;
}
string ColorString( string sString, string sColorTag);
string ColorString( string sString, string sColorTag)
{ return (!GetIsColorTagValid( sColorTag) ? sString : (sColorTag +sString +COLOR_END));
}

