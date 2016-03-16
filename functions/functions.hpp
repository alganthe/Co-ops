class derp {
    class misc {
        file = "functions\misc";
        class VA_filter {};
        class daytime {};
        class find_flatPos {};
        class diary {};
        class findItemList {};
        class globalHint_handler {};
        class pilotCheck {};
        class curatorPingedEH {};
        class VAInitSorting {};
        class hintC {};
    };

    class AI {
        file = "functions\core\AI";
        class mainAOSpawnHandler {};
        class AISkill {};
        class AIOccupyBuilding {};
    };
};

class TAW_VD {
	tag = "TAWVD";

	class Initialize {
		file = "functions\misc\taw_vd";
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
