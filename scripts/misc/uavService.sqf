/*
* Author: alganthe
* Handler for the vehicle service pad (UAVs)
*
* Arguments:
* 0: Vehicle to be serviced <OBJECT>
*
* Return Value:
* Nothing
*/
params ["_vehicle"];

if (_vehicle isKindOf "UAV") then {

    _vehicle setFuel 0;
    _vehicle vehicleChat "Servicing started, this process should be finished in 45s";

    //---------- RE-ARMING
    sleep 10;
    _vehicle vehicleChat "Re-arming ...";

    //---------- REPAIRING
    sleep 10;
    _vehicle vehicleChat "Repairing ...";

    //---------- REFUELING
    sleep 10;
    _vehicle vehicleChat "Refueling ...";

    //---------- FINISHED
    sleep 10;
    _vehicle setDamage 0;
    _vehicle vehicleChat "Repaired (100%).";

    _vehicle setVehicleAmmo 1;
    _vehicle vehicleChat "Re-armed (100%).";

    _vehicle setFuel 1;
    _vehicle vehicleChat "Refuelled (100%).";

    sleep 2;
    _vehicle vehicleChat "Service complete.";

} else {
    _vehicle vehicleChat "This pad is for uav sevice only";

};
