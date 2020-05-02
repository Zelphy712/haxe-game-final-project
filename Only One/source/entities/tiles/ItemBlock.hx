package entities.tiles;

import flixel.util.FlxColor;
import flixel.FlxSprite;

class ItemBlock extends FlxSprite implements entities.tiles.Tile{

    public var type = "Item";
    public var item:entities.items.Item;
    public var itemType:String;
    public var blocking:Bool;

    public override function new(x:Float,y:Float,item:entities.items.Item){
        super(x,y);
        this.blocking = false;//maybe change to true later.
        this.item = item;
        itemType = item.type;
        makeGraphic(32,32,FlxColor.BLUE);
    }

    public override function update(elapsed:Float){
        super.update(elapsed);
    }

    

}