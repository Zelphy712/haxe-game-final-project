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
                loadGraphic(AssetPaths.redDoor__png,false,32,32);
            case GREEN:
                loadGraphic(AssetPaths.greenDoor__png,false,32,32);
            case BLUE:
                loadGraphic(AssetPaths.blueDoor__png,false,32,32);
        }
    }

    public override function update(elapsed:Float){
        super.update(elapsed);
    }

    public function open():Bool{
        this.blocking = false;
        loadGraphic(AssetPaths.blank__png,false,32,32);
        return true;
    }

}