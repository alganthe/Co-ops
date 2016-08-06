#define names_idc 99999

class RscStructuredText
{
    access = 0;
    type = 13;
    idc = -1;
    style = 0;
    colorText[] =
    {
        1,
        1,
        1,
        1
    };
    class Attributes
    {
        font = "PuristaMedium";
        color = "#ffffff";
        align = "left";
        shadow = 1;
    };
    x = 0;
    y = 0;
    h = 0.035;
    w = 0.1;
    text = "";
    size = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
    shadow = 1;
};

class HudNames {
    idd = -1;
    fadeout=0;
    fadein=0;
    duration = 0.1;
    name= "HudNames";
    onLoad = "uiNamespace setVariable ['HudNames', _this select 0]";

    class controlsBackground {
        class HudNames_1:RscStructuredText
        {
            idc = names_idc;
            type = CT_STRUCTURED_TEXT;
            size = 0.040;
            x = (SafeZoneX + 0.015);
            y = (SafeZoneY + 0.60);
            w = 0.4; h = 0.65;
            colorText[] = {1,1,1,1};
            lineSpacing = 3;
            colorBackground[] = {0,0,0,0};
            text = "";
            font = "PuristaLight";
            shadow = 2;
            class Attributes {
                align = "left";
            };
        };
    };
};
