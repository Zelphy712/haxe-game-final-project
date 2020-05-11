package;

import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.FlxState;

class PlayState extends FlxState
{
	private var button:FlxButton;
	override public function create()
	{
		super.create();
		
		button = new FlxButton(FlxG.width/2,FlxG.height/2, "Start Game",startGame);
		add(button);

	}

	private function startGame(){
		FlxG.switchState(new levels.Lvl1(0));
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
