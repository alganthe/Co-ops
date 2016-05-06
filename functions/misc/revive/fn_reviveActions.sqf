#include "reviveDefines.hpp"

params ["_unit"];

_unit addAction [
    "<t color='#ff0000'> Revive </t>",
    {
        params ["", "_caller", "", "_args"];
        _args params ["_medicAnim"];

        _caller playAction _medicAnim;

        [
            10, // Time the action takes to complete
            [_caller], // Args passed to the code
            {
                [cursorObject, "REVIVED"] remoteExecCall ["derp_fnc_switchState", cursorObject];
            }, // code executed upon action completion
            {}, // Code executed upon action failure
            format ["Reviving %1", name cursorObject], // Title text
            {
                (alive cursorObject) && {cursorObject getVariable ["derp_revive_downed", false]} && {isNull objectParent ((_this select 0) select 0)}
            } // Code to check each frame
        ] call derp_fnc_progressBar;
    },
    [DERP_REVIVE_MEDICANIM],
    10,
    true,
    true,
    "",
    "(cursorObject getVariable ['derp_revive_downed', false]) && {!(_this getVariable ['derp_revive_downed', false])} && {isNull objectParent _this}" // condition
];
