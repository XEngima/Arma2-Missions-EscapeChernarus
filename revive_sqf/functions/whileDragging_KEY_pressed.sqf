// whileDragging_KEY_pressed.sqf

waitUntil {animationState player != "acinpknlmstpsraswrfldnon" && animationState player != "acinpknlmwlksraswrfldb"};

sleep 2;

if (vehicle player == player) then 
{
	player playMove "aidlpknlmstpslowwrfldnon";
};