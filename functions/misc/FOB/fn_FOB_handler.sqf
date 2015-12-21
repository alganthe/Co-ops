/*
 * Author: alganthe
 * Deploy / unpack the FOB
 *
 * Arguments:
* 0: Vehicle to deploy the FOB on <OBJECT>
* 1: Deployed already? <BOOL>
* 2: Cleanup ? (Optionnal) <BOOL>
*
 * Return Value:
 * Nothing
 *
 * Example:
 *
 * ["FOBvehc",true,nil] call derp_fnc_FOB_handler
 */
params ["_vehicle","_deployed","_cleanup"];

//---------------------------- Check if the call was done correctl, vehicle will be server owned if _cleanup is defined
if (!(isNil "_cleanup")) then {
    //---------------------------- Unlock the vehicle
    _vehicle setVehicleLock "UNLOCKED";

    //---------------------------- If the FOB was already deployed remove it
   if !(isNil "MHQ_box") then {

       //---------------------------- Cleanup of the FOB
       deleteVehicle MHQ_Antenna;
       deleteVehicle MHQ_box;
       MHQ_Antenna = nil;
       MHQ_box = nil;
   };

   //---------------------------- Return nil to avoid executing the rest.
   _cleanup = nil;
   _deployed = nil;
};
//---------------------------- Check if the call was done properly
if (!isNil "_deployed" && {local _vehicle}) then {
    //---------------------------- FOB already deployed
    if (_deployed) then {
        _vehicle setVehicleLock "UNLOCKED";

        //***********Cleanup+pack hints
        deleteVehicle MHQ_Antenna;
        deleteVehicle MHQ_box;
        MHQ_Antenna = nil;
        MHQ_box = nil;
        _deployed = false;
    }
    //---------------------------- FOB NOT already deployed
    else {
        {moveOut _x} forEach crew _vehicle;
        _vehicle setVehicleLock "LOCKED";
        //---------------------------- Objects
        MHQ_box = "Box_NATO_AmmoVeh_F" createVehicle getPosWorld _vehicle;
        MHQ_box allowDamage false;
        MHQ_box attachTo [_vehicle,[2.5,0,-1]];
        MHQ_Antenna = "Land_TTowerSmall_1_F" createVehicle getPosWorld _vehicle;
        MHQ_Antenna allowDamage false;
        MHQ_Antenna attachTo [_vehicle,[4,10,-1]];

        //---------------------------- Add Ammo to box
        clearMagazineCargoGlobal MHQ_box;
        clearItemCargoGlobal MHQ_box;
        clearWeaponCargoGlobal MHQ_box;

        // Add your stuff here
        //---------------------------- Fin Hint for user+Grid broadcast(Use EH to broadcast hint)
        _hintText = format ["<t align='center' size='2.2'>FOB Deployed at </t><br/><t size='1.5' align='center' color='#FFCF11'>%1</t><br/>____________________<br/><br/><br/>",(getPosWorld _vehicle)];
        [_hintText] call derp_fnc_globalHint_handler;
        _deployed = true;
    };
};
