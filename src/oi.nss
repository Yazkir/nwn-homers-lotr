// Function to close a placeable door.
void PlaceableDoorClose( object oDoor)
{ if( !GetIsObjectValid( oDoor)) return;
  string sGateBlock = GetLocalString( OBJECT_SELF, "CEP_L_GATEBLOCK");
  PlayAnimation( ANIMATION_PLACEABLE_CLOSE);
  SetLocalObject( oDoor, "GateBlock", CreateObject( OBJECT_TYPE_PLACEABLE, sGateBlock, GetLocation( oDoor)));
}
// OnUsed main function.
void main()
{ object oUser = GetLastUsedBy();
  if( !GetIsObjectValid( oUser)) return;

  // If the placeable is locked, it cannot be opened or closed
  if( GetLocked( OBJECT_SELF) == 1)
  { SpeakString("Locked");
    return;
  }

  string sGateBlock = GetLocalString( OBJECT_SELF, "CEP_L_GATEBLOCK");
  if( sGateBlock == "")
  { // The placeable is not a door
    if( GetIsOpen( OBJECT_SELF)) PlayAnimation( ANIMATION_PLACEABLE_CLOSE);
    else PlayAnimation( ANIMATION_PLACEABLE_OPEN);
    return;
  }

  // The placeable is a door
  if( GetIsOpen( OBJECT_SELF)) PlaceableDoorClose( OBJECT_SELF);
  else if( GetAlignmentGoodEvil( oUser) == ALIGNMENT_GOOD)
  { PlayAnimation( ANIMATION_PLACEABLE_OPEN);
    object oGateBlock = GetLocalObject( OBJECT_SELF, "GateBlock");
    if( GetIsObjectValid( oGateBlock))
    { DestroyObject( oGateBlock, 0.1f);
      DeleteLocalObject( OBJECT_SELF, "GateBlock");
    }
    // Make the door auto-close in 12 seconds.
    DelayCommand( 12.0f, PlaceableDoorClose( OBJECT_SELF));
  }
  else if( GetIsPC( oUser)) SendMessageToPC( oUser, "Only good players can open this door.");
}

