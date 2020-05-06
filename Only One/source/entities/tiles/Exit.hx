package entities.tiles;

import flixel.FlxSprite;

class Exit extends FlxSprite implements Tile{

    public var type:String = "Exit";
    public var blocking:Bool;

    public override function new(x:Float,y:Float){
        super(x,y);
        this.blocking = false;
        loadGraphic(AssetPaths.exitTilesheet__png,true,32,32);
        animation.add("passive",[0,1,2,3],8,true);
        animation.play("passive");
    }



}