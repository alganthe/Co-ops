/*
* Author: unknown
* Rewrote by: alganthe
* Display the crew and vehicle heading / target
*
* Arguments:
* Nothing
*
* Return Value:
* Nothing
*/
[{
    params ["_args", "_pfhID"];

    if (isNull objectParent player) then {
        _pfhID call derp_fnc_removePerFrameHandler;
    } else {
        disableSerialization;

        1000 cutRsc ["HudNames","PLAIN"];
        private _ui = uiNameSpace getVariable "HudNames";
        private _HudNames = _ui displayCtrl 99999;

        private _name = "";
        private _vehicle = assignedVehicle player;
        private _weap = currentWeapon vehicle player;

        {
            if ((driver _vehicle == _x) || (gunner _vehicle == _x)) then {
                if (driver _vehicle == _x) then {
                    _name = format ["<t size='0.85' color='#f0e68c'>%1 %2</t> <img size='0.7' color='#6b8e23' image='a3\ui_f\data\IGUI\Cfg\Actions\getindriver_ca.paa'/><br/>", _name, (name _x)];
                } else {
                    private _target = cursorTarget;
                    private _picture = getText (configFile >> "cfgVehicles" >> typeOf _target >> "displayname");
                    private _vehtarget =  format ["%1",_picture];
                    private _wepdir =  (vehicle player) weaponDirection _weap;
                    private _Azimuth = round  (((_wepdir select 0) ) atan2 ((_wepdir select 1) ) + 360) % 360;
                    _name = format ["<t size='0.85' color='#f0e68c'>%1 %2</t> <img size='0.7' color='#6b8e23' image='a3\ui_f\data\IGUI\Cfg\Actions\getingunner_ca.paa'/><br/> <t size='0.85' color='#f0e68c'>Heading :<t/> <t size='0.85' color='#ff0000'>%3</t><br/><t size='0.85' color='#f0e68c'> Target : </t><t size='0.85' color='#ff0000'>%4</t><br/>", _name, (name _x), _Azimuth, _vehtarget];
                };
            } else {
                _name = format ["<t size='0.85' color='#f0e68c'>%1 %2</t> <img size='0.7' color='#6b8e23' image='a3\ui_f\data\IGUI\Cfg\Actions\getincargo_ca.paa'/><br/>", _name, (name _x)];
            };

        } forEach crew _vehicle;

        _HudNames ctrlSetStructuredText parseText _name;
        _HudNames ctrlCommit 0;

    };
}, 0, []] call derp_fnc_addPerFrameHandler;
