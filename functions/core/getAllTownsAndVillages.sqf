private _locationList = nearestLocations [[worldSize/2, worldSize/2 , 0], ["NameCityCapital", "NameCity", "NameVillage"], worldSize * sqrt 2];

_locationList =_locationList apply {
     [(text _x), (position _x)];
};

_locationList
