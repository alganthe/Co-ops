#define true 1
#define false 0

#define CT_STATIC     0
#define CT_BUTTON     1
#define CT_EDIT       2
#define CT_SLIDER     3
#define CT_COMBO      4
#define CT_LISTBOX      5
#define CT_TOOLBOX      6
#define CT_CHECKBOXES   7
#define CT_PROGRESS     8
#define CT_HTML       9
#define CT_STATIC_SKEW    10
#define CT_ACTIVETEXT   11
#define CT_TREE       12
#define CT_STRUCTURED_TEXT  13
#define CT_CONTEXT_MENU   14
#define CT_CONTROLS_GROUP 15
#define CT_SHORTCUTBUTTON 16
#define CT_XKEYDESC     40
#define CT_XBUTTON      41
#define CT_XLISTBOX     42
#define CT_XSLIDER      43
#define CT_XCOMBO     44
#define CT_ANIMATED_TEXTURE 45
#define CT_OBJECT     80
#define CT_OBJECT_ZOOM    81
#define CT_OBJECT_CONTAINER 82
#define CT_OBJECT_CONT_ANIM 83
#define CT_LINEBREAK    98
#define CT_ANIMATED_USER  99
#define CT_MAP        100
#define CT_MAP_MAIN     101
#define CT_LISTNBOX     102

// Static styles
#define ST_POS            0x0F
#define ST_HPOS           0x03
#define ST_VPOS           0x0C
#define ST_LEFT           0x00
#define ST_RIGHT          0x01
#define ST_CENTER         0x02
#define ST_DOWN           0x04
#define ST_UP             0x08
#define ST_VCENTER        0x0c

#define ST_TYPE           0xF0
#define ST_SINGLE         0
#define ST_MULTI          16
#define ST_TITLE_BAR      32
#define ST_PICTURE        48
#define ST_FRAME          64
#define ST_BACKGROUND     80
#define ST_GROUP_BOX      96
#define ST_GROUP_BOX2     112
#define ST_HUD_BACKGROUND 128
#define ST_TILE_PICTURE   144
#define ST_WITH_RECT      160
#define ST_LINE           176

#define ST_SHADOW         0x100
#define ST_NO_RECT        0x200 // this style works for CT_STATIC in conjunction with ST_MULTI
#define ST_KEEP_ASPECT_RATIO  0x800

#define ST_TITLE          ST_TITLE_BAR + ST_CENTER

// Slider styles
#define SL_DIR            0x400
#define SL_VERT           0
#define SL_HORZ           0x400

#define SL_TEXTURES       0x10

// Listbox styles
#define LB_TEXTURES       0x10
#define LB_MULTI          0x20
#define FONT_DERP       "RobotoCondensed"

class derp_gui_RscProgress {
  type = 8;
  style = 0;
  colorFrame[] = {1,1,1,0.7};
  colorBar[] = {1,1,1,0.7};
  texture = "#(argb,8,8,3)color(1,1,1,0.7)";
  x = "1 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)";
  y = "10 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)";
  w = "38 * (((safezoneW / safezoneH) min 1.2) / 40)";
  h = "0.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
};

class derp_gui_staticBase {
  idc = -1;
  type = CT_STATIC;
  x = 0.0;
  y = 0.0;
  w = 0.183825;
  h = 0.104575;
  style = ST_LEFT;
  font = FONT_DERP;
  sizeEx = 0.03921;
  colorText[] = {0.95, 0.95, 0.95, 1.0};
  colorBackground[] = {0, 0, 0, 0};
  text = "";
};

class derp_ProgressBar_Dialog {
    idd = -1;
    movingEnable = false;
    onLoad = "uiNamespace setVariable ['derp_ctrlProgressBG',(_this select 0) displayCtrl 1]; uiNamespace setVariable ['derp_ctrlProgressBar',(_this select 0) displayCtrl 2]; uiNamespace setVariable ['derp_ctrlProgressBarTitle',(_this select 0) displayCtrl 3];";
    objects[] = {};

    class controlsBackground {
        class Background {
            idc = -1;
            moving = 0;
            font = "TahomaB";
            text = "";
            sizeEx = 0;
            lineSpacing = 0;
            access = 0;
            type = 0;
            style = 0;
            size = 1;
            colorBackground[] = {0, 0, 0, 0.0};
            colorText[] = {0, 0, 0, 0};
            x = "safezoneX";
            y = "safezoneY";
            w = "safezoneW";
            h = "safezoneH";
        };

        class TitleBackground: derp_gui_staticBase {
            idc = 1;
            style = ST_CENTER;
            sizeEx = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
            colorBackground[] = {0, 0, 0, 0.5};
            colorText[] = {1, 1, 1, 1};
            x = "1 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)";
            y = "0 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)";
            w = "38 * (((safezoneW / safezoneH) min 1.2) / 40)";
            h = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
        };

        class Progress: derp_gui_RscProgress {
            idc = 2;
            x = "1.2 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)";
            y = "0.1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)";
            w = "38 * (((safezoneW / safezoneH) min 1.2) / 40)";
            h = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
            colorFrame[] = {1,1,1,0.5};
            colorBar[] = {0.77,0.51,0.08,0.8};
            texture = "#(argb,8,8,3)color(1,1,1,0.7)";
        };

        class TitleText: TitleBackground {
            idc = 3;
            colorBackground[] = {0, 0, 0, 0};
        };
    };
};

class derp_DisableMouse_Dialog {
    idd = -1;
    movingEnable = false;
    onLoad = "uiNamespace setVariable [['derp_dlgDisableMouse', _this select 0]];";
    objects[] = {};
    class controlsBackground {
        class Background {
            idc = -1;
            moving = 0;
            font = "TahomaB";
            text = "";
            sizeEx = 0;
            lineSpacing = 0;
            access = 0;
            type = 0;
            style = 0;
            size = 1;
            colorBackground[] = {0, 0, 0, 0};//0.5
            colorText[] = {0, 0, 0, 0};
            x = "safezoneX";
            y = "safezoneY";
            w = "safezoneW";
            h = "safezoneH";
        };
    };
};
