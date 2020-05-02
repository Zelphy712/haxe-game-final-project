package entities.tiles;

import flixel.util.FlxColor;
import flixel.FlxSprite;

class Door extends FlxSprite implements Tile{

    public var type = "Door";
    public var colour:types.KeyColor;
    public var blocking:Bool;

    public override function new(x:Float,y:Float,color:types.KeyColor){
        super(x,y);
        this.colour = color;
        this.blocking = true;
        switch(colour){
            case RED:
                makeGraphic(32,32,FlxColor.RED);
            case GREEN:
                makeGraphic(32,32,FlxColor.GREEN);
            case BLUE:
                makeGraphic(32,32,FlxColor.BLUE);
        }
    }

    public override function update(elapsed:Float){
        super.update(elapsed);
    }

    public function open():Bool{
        trace("OPENED!");
        this.blocking = false;
        return true;
    }

}