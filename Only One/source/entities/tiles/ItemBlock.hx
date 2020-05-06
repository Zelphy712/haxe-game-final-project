package entities.tiles;

import types.KeyColor;
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
        // makeGraphic(32,32,FlxColor.BLUE);
        switch(itemType){
            case "Key":
                var tempItem = cast(item,entities.items.Key);
                if(tempItem.color == KeyColor.RED){
                    loadGraphic(AssetPaths.redKey__png,false,32,32);
                }else if(tempItem.color == KeyColor.GREEN){
                    loadGraphic(AssetPaths.greenKey__png,false,32,32);
                }else{
                    loadGraphic(AssetPaths.blueKey__png,false,32,32);
                }
            case "Null":
                trace("Null");
                loadGraphic(AssetPaths.blank__png,false,32,32);
            default:
                trace("other");
                loadGraphic(AssetPaths.blank__png,false,32,32);
            }
    }

    public override function update(elapsed:Float){
        super.update(elapsed);
    }

    public function updateSprite(){
        switch(itemType){
            case "Key":
                var tempItem = cast(item,entities.items.Key);
                if(tempItem.color == KeyColor.RED){
                    loadGraphic(AssetPaths.redKey__png,false,32,32);
                }else if(tempItem.color == KeyColor.GREEN){
                    loadGraphic(AssetPaths.greenKey__png,false,32,32);
                }else{
                    loadGraphic(AssetPaths.blueKey__png,false,32,32);
                }
            case "Null":
                trace("Null");
                loadGraphic(AssetPaths.blank__png,false,32,32);
            default:
                trace("other");
                loadGraphic(AssetPaths.blank__png,false,32,32);
            
        }
    }

    

}