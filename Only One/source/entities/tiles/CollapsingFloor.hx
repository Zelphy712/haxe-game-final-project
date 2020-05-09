package entities.tiles;

import flixel.util.FlxColor;
import flixel.FlxSprite;

class CollapsingFloor extends FlxSprite implements Tile{

    public var type = "Collapse";
    public var blocking:Bool;

    public override function new(x:Float,y:Float){
        super(x,y);
        this.blocking = false;
        makeGraphic(32,32,FlxColor.PINK);
        loadGraphic(AssetPaths.grateTilesheet__png,true,32,32);
        animation.add("static",[0],0,false);
        animation.add("sparking",[1,2],30,true);
        animation.play("static");
    }

    public override function update(elapsed:Float){
        super.update(elapsed);
    }

    public function breakFloor():Void{
        trace("colided");
        if(blocking == false){
            trace("breaking floor");
            this.blocking = true;
            animation.play("sparking");
        }
    }

}