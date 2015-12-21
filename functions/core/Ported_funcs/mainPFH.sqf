//Singe PFEH to handle execNextFrame, waitAndExec and waitUntilAndExec:
[{
    //Handle the waitAndExec array:
    while {!(derp_waitAndExecArray isEqualTo []) && {derp_waitAndExecArray select 0 select 0 <= derp_time}} do {
        private _entry = derp_waitAndExecArray deleteAt 0;
        (_entry select 2) call (_entry select 1);
    };

    //Handle the execNextFrame array:
    {
        (_x select 0) call (_x select 1);
        false
    } count derp_nextFrameBufferA;

    //Swap double-buffer:
    derp_nextFrameBufferA = derp_nextFrameBufferB;
    derp_nextFrameBufferB = [];
    derp_nextFrameNo = diag_frameno + 1;

}, 0, []] call CBA_fnc_addPerFrameHandler;
