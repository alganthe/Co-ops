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
waitUntil {!isNull player};

player createDiarySubject ["rules", "Rules"];
player createDiarySubject ["teamspeak", "Teamspeak"];
player createDiarySubject ["credits", "Credits"];
player createDiarySubject ["current issues", "Current issues"];

//-------------------------------------------------- Rules
player createDiaryRecord ["rules", ["Enforcement",
"your rules here"
]];

//-------------------------------------------------- Teamspeak
player createDiaryRecord ["teamspeak", ["TS3",
"
<br/> Teamspeak:
<br/> http://www.teamspeak.com/?page=downloads
<br/> your adress here
"
]];

player createDiaryRecord ["credits", ["credits",
"
<br/> Credits:
<br/> base layout: Ahoyworld
<br/> vehicle pad scripts: Ahoyworld
<br/> player icons on map: Quicksilver
<br/> ACE3 ported funcs: see the respective funcs headers
<br/> the rest: alganthe
<br/>
<br/> Contributors:
<br/> yourstruly
"
]];

player createDiaryRecord ["current issues", ["current issues",
"
<br/> BIS revive system breaks the zeus logic and unnasign the unit linked to it when that unit enter the revive state.
"
]];
