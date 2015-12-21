/*
* Author: alganthe
* Set up arsenal boxes / dude depending on mission param
*
* Arguments:
* NONE
*
* Return Value:
* Nothing
*
* Example:
* [] call derp_fnc_VAInitSorting
*/
switch ("ArsenalFilter" call BIS_fnc_getParamValue) do {
    case (1): {
        [arsenalBox1,1] call derp_fnc_VA_filter;
        [arsenalBox2,1] call derp_fnc_VA_filter;
        [arsenalDude,1] call derp_fnc_VA_filter;
    };

    case (2): {
        [arsenalBox1,2] call derp_fnc_VA_filter;
        [arsenalBox2,2] call derp_fnc_VA_filter;
        [arsenalDude,2] call derp_fnc_VA_filter;
    };
};
