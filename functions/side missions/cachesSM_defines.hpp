#define Land_i_House_Small_01_variant \
_box = (selectRandom ["Box_FIA_Wps_F", "Box_FIA_Ammo_F", "Box_FIA_Support_F"]) createVehicle (_building modelToWorldVisual (selectRandom [[0.125,-1.69922,3.2985], [-1.48242,-0.175781,3.48282], [-1.91016,-2.7832,3.3207]])); \
_box setDir (random 360); \
_ammoCaches pushBack _box;

#define Land_i_House_Small_02_variant \
_box = (selectRandom ["Box_FIA_Wps_F", "Box_FIA_Ammo_F", "Box_FIA_Support_F"]) createVehicle (AGLToASL (_building modelToWorldVisual (selectRandom [[2.83008,0.357422,-1.14991], [5.38281,0.138672,-1.15005], [-1.36523,-0.558594,-1.14906]]))); \
_box setDir (random 360); \
_ammoCaches pushBack _box;

#define Land_i_Stone_HouseSmall_variant \
_box = (selectRandom ["Box_FIA_Wps_F", "Box_FIA_Ammo_F", "Box_FIA_Support_F"]) createVehicle (AGLToASL (_building modelToWorldVisual (selectRandom [[4.66797,1.83008,-1.88735], [-1.97852,2.14648,-1.88664], [-5.74219,2.13867,-1.88722]]))); \
_box setDir (random 360); \
_ammoCaches pushBack _box;

#define Land_i_Stone_HouseBig_variant \
_box = (selectRandom ["Box_FIA_Wps_F", "Box_FIA_Ammo_F", "Box_FIA_Support_F"]) createVehicle (AGLToASL (_building modelToWorldVisual (selectRandom [[1.09766,0.583984,-1.86751], [0.966797,0.816406,-1.86752]]))); \
_box setDir (random 360); \
_ammoCaches pushBack _box;

#define Land_i_House_Big_01_variant \
_box = (selectRandom ["Box_FIA_Wps_F", "Box_FIA_Ammo_F", "Box_FIA_Support_F"]) createVehicle (AGLToASL (_building modelToWorldVisual (selectRandom [[1.26758,-3.25977,-3.09138], [-2.46094,5.46875,-3.09138], [1.24414,-0.816406,-3.09135]]))); \
_box setDir (random 360); \
_ammoCaches pushBack _box;

#define Land_i_House_Big_02_variant \
_box = (selectRandom ["Box_FIA_Wps_F", "Box_FIA_Ammo_F", "Box_FIA_Support_F"]) createVehicle (AGLToASL (_building modelToWorldVisual [0.537109,2.24023,-2.90897])); \
_box setDir (random 360); \
_ammoCaches pushBack _box;
