//////////////////////////////
//    Dynamic-AI-Creator    //
//    Version 3.1b - 2014   //
//--------------------------//
//    DAC_Config_Weapons    //
//--------------------------//
//    Script by Silola      //
//    silola@freenet.de     //
//////////////////////////////

private ["_TypNumber","_TempArray","_Weapon_Pool","_Magazine_Pool"];

_TypNumber = _this select 0;_TempArray = [];

switch (_TypNumber) do
{
//-------------------------------------------------------------------------------------------------
  case 1:
  {
    _Weapon_Pool  = ["","Binocular","ItemCompass","ItemMap"];
    _Magazine_Pool  = [["",6],["",6],["",2],["",2]];
  };
//-------------------------------------------------------------------------------------------------
  case 2:
  {
    _Weapon_Pool  = ["","ItemCompass","ItemMap"];
    _Magazine_Pool  = [["",6],["",6],["",2],["",2]];
  };
//-------------------------------------------------------------------------------------------------
Default
{
  if(DAC_Basic_Value != 5) then
  {
    DAC_Basic_Value = 5;publicvariable "DAC_Basic_Value";
    hintc "Error: DAC_Config_Weapons > No valid config number";
  };
  if(true) exitwith {};
  };
};

_TempArray = [_Weapon_Pool] + [_Magazine_Pool];
_TempArray
