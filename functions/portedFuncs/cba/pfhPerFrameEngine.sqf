// prepare our handlers list
uiNamespace setVariable ["derp_PFHIDD", (_this select 0)];
((_this select 0) displayCtrl 40122) ctrlSetEventHandler ["Draw", "[_this] call derp_fnc_onFrame" ];
