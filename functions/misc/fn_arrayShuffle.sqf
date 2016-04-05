private _cnt = count _this;

for "_i" from 1 to _cnt do {
    _this pushBack (_this deleteAt floor random _cnt);
};

_this
