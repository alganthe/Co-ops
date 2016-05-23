_locationList = nearestLocations [[0,0,0], ["NameCityCapital", "NameCity", "NameVillage"], worldSize];

_locationList =_locationList apply {
     [(text _x), (position _x)];
};

_locationList
