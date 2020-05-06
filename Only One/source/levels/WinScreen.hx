package levels;

import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.FlxState;
import flixel.text.FlxText;

class WinScreen extends FlxState
{
    private var button:FlxButton;
    private var text:FlxText;
	override public function create()
	{
		super.create();
        
        text = new FlxText(FlxG.width/2,FlxG.height/2-100,0,"YOU WON!",32);
        add(text);
		button = new FlxButton(FlxG.width/2,FlxG.height/2, "Replay",startGame);
		add(button);

	}

	private function startGame(){
		trace("Started");
		FlxG.switchState(new levels.Lvl1(0));
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
