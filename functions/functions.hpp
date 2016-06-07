class derp {

    class CBA {
        file = "functions\portedFuncs\cba";
        class pfhPreInit { preInit = 1; };
        class addPerFrameHandler {};
        class removePerFrameHandler {};
        class execNextFrame {};
        class waitAndExecute {};
        class waitUntilAndExecute {};
        class pfhPostInit { postInit = 1; };
        class getTurret {};
    };

    class ACE3 {
        file = "functions\portedFuncs\ace3";
        class progressBar {};
    };

    class misc {
        file = "functions\misc";
        class VA_filter {};
        class daytime {};
        class diary {};
        class findItemList {};
        class globalHint_handler {};
        class pilotCheck {};
        class curatorPingedEH {};
        class hintC {};
        class arrayShuffle {};
        class paradrop {};
        class gearLimitations {};
        class remoteAddCuratorEditableObjects {};
        class syncAnim {};
        class mapLinesHandler {};
        class baseCleaning {};
        class cleaner {};
        class crewNames {};
    };

    class AI {
        file = "functions\core\AI";
        class mainAOSpawnHandler {};
        class AISkill {};
        class AIOccupyBuilding {};
    };
};

class derp_revive {

    class Revive {
        file = "functions\revive";
        class onPlayerKilled {};
        class onPlayerRespawn {};
        class executeTemplates {};
        class switchState {};
        class reviveTimer {};
        class reviveActions {};
        class startDragging {};
        class startCarrying {};
        class dragging {};
        class carrying {};
        class dropPerson {};
        class hotkeyHandler {};
        class uiElements {};
        class animChanged {};
        class drawDowned {};
    };
};

class derp_vehicleHandler {

    class vehicleHandler {
        file = "functions\vehicle_handler";
        class quadInit {};
        class quadPFH {};
        class vehicleInit {};
        class vehiclePFH {};
        class vehicleSetup {};
    };
};

class TAW_VD {
    tag = "TAWVD";

    class Initialize {
        file = "functions\taw_vd";
        class stateTracker {
            ext = ".fsm";
            postInit = 1;
            headerType = -1;
        };

        class onSliderChanged {};
        class onTerrainChanged {};
        class updateViewDistance {};
        class openMenu {};
        class onChar {};
        class openSaveManager {};
        class onSavePressed {};
        class onSaveSelectionChanged {};
    };
};
