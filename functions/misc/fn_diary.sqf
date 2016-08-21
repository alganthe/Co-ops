/*
* Author: alganthe
* Adds the required briefing entries.
*
* Arguments:
* >NONE
*
* Return Value:
* nothing
*/
player createDiarySubject ["rules", "Rules"];
player createDiarySubject ["teamspeak", "Teamspeak"];
player createDiarySubject ["Co-ops", "Co-ops"];

//-------------------------------------------------- Rules
player createDiaryRecord ["rules", ["Enforcement",
"your rules here"
]];

//-------------------------------------------------- Teamspeak
player createDiaryRecord ["teamspeak", ["TS3",
"
<br/> <font face= 'PuristaLight' color= '#D3D3D3' size= 14>Teamspeak:</font> <font size= 14>http://www.teamspeak.com/?page=downloads</font>
<br/>
<br/> your adress here
"
]];

//-------------------------------------------------- Mission related, don't touch
player createDiaryRecord ["Co-ops", ["FAQ",
"
<br/> <font face= 'PuristaLight' color= '#D3D3D3' size= 14>Q:</font> <font size= 14>How do I paradrop?</font>
<br/> <font face= 'PuristaLight' color= '#D3D3D3' size= 14>A:</font> <font size= 14>If it's enabled talk to the arsenal guy when an AO is up, an action will show up.
<br/> If a pilot is present on the server a helo will be necessary to be around the ao to paradrop.</font>
<br/>
<br/> <font face= 'PuristaLight' color= '#D3D3D3' size= 14>Q:</font> <font size= 14>Why is my view distance really low even when my video options says it's high?</font>
<br/> <font face= 'PuristaLight' color= '#D3D3D3' size= 14>A:</font> <font size= 14>Scroll down and click on view settings.</font>
<br/>
<br/> <font face= 'PuristaLight' color= '#D3D3D3' size= 14>Q:</font> <font size= 14>How long do vehicles take to respawn?</font>
<br/> <font face= 'PuristaLight' color= '#D3D3D3' size= 14>A:</font> <font size= 14>It can vary from server to server, it's highly configurable, ask on side chat.</font>
<br/>
"
]];

player createDiaryRecord ["Co-ops", ["Credits",
"
<br/> <font face= 'PuristaLight' color= '#D3D3D3' size= 14>Player icons on map:</font> <font size= 14>Quicksilver</font>
<br/> <font face= 'PuristaLight' color= '#D3D3D3' size= 14>Glorious PFHs:</font> <font size= 14>The CBA_A3 team, check the headers of the functions for more specific informations</font>
<br/> <font face= 'PuristaLight' color= '#D3D3D3' size= 14>TAW VD:</font> <font size= 14>Bryan 'Tonic' Boardwine</font>
<br/> <font face= 'PuristaLight' color= '#D3D3D3' size= 14>The rest:</font> <font size= 14>Alganthe</font>
<br/>
<br/> <font face= 'PuristaLight' color= '#D3D3D3' size= 14>Contributors:</font>
<br/> <font size= 14>yourstruly</font>
"
]];

player createDiaryRecord ["Co-ops", ["Issues",
"
<br/> <font face= 'PuristaLight' color= '#D3D3D3' size= 14>You have issues to report?</font> <execute expression=""copyToClipboard 'https://github.com/alganthe/Co-ops/issues';"">https://github.com/alganthe/Co-ops/issues</execute>
<br/>
<br/> <font face= 'PuristaLight' color= '#D3D3D3' size= 14>Known issues:</font> <font size= 14>None at the moment!</font>
"
]];
