package entities;

import flixel.FlxObject;
import flixel.group.FlxGroup;
import types.Direction;
import flixel.math.FlxMath;
import flixel.math.FlxVector;
import haxe.DynamicAccess;
import lime.utils.Assets;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class Player extends FlxSprite {
    //change movement so that you move only if you were already looking in the direction you wan to move, otherwise turn to face that way.

    //General use variables
    public var tileSize:Int = 32; 
    var moveDirection:types.Direction;
    public var looking:types.Direction;

    //Map loading
    var file:String;
    var mapJSON:DynamicAccess<Dynamic>;
    public var map:Array<Int>;
    public var mapSize:FlxVector;
    public var playerPos:FlxVector;
    
    //Movement variables
    var moving:Bool;
    var lerp:Float;
    var oldPos:FlxVector;
    var newPos:FlxVector;
    public var entityBlocking:Bool;

    //Item variables
    var item:entities.items.Item;
    public var levelEntities:FlxGroup;
    public var facingCollider:FlxObject;


    public override function new(?x:Float=0, ?y:Float=0,?mapName:String=""){
        super(x,y);
        loadMap(mapName);
        // makeGraphic(32,32,FlxColor.MAGENTA);
        moving = false;
        lerp = 0;
        moveDirection = types.Direction.NONE;
        looking = types.Direction.NORTH;
        item = new entities.items.NullItem();
        facingCollider = new FlxObject((x - tileSize), y, 32, 32);
        entityBlocking = false;
        loadGraphic(AssetPaths.slimeTilesheet__png,true,32,32);
        animation.add("standN",[0],0,false);
        animation.add("standS",[0],0,false,false,true);
        animation.add("standE",[2],0,false);
        animation.add("standW",[2],0,false,true);
        animation.add("moveN",[0,1],10,true);
        animation.add("moveS",[0,1],10,true,false,true);
        animation.add("moveE",[2,3],10,true);
        animation.add("moveW",[2,3],10,true,true);
        animation.play("standN");
    }

    public function loadMap(mapName){
        file = Assets.getText(mapName);
        mapJSON = haxe.Json.parse(file);
        for(layer in cast (mapJSON.get('layers'),Array<Dynamic>)) {
            if(layer.name == "Walls"){
                map = layer.data;
                tileSize = layer.gridCellWidth;
                mapSize = new FlxVector(layer.gridCellsX, layer.gridCellsY);
            }
            if(layer.name == "Entities"){
                //loop through entities
                for(ent in cast(layer.entities,Array<Dynamic>)){
                    //set playerPos with it's x and y
                    if(ent.name == "Player"){
                        playerPos = new FlxVector(ent.x/tileSize,ent.y/tileSize);
                        // trace("playerPos: ", playerPos);
                        oldPos = new FlxVector(ent.x/tileSize,ent.y/tileSize);
                        newPos = new FlxVector(ent.x/tileSize,ent.y/tileSize);
                    }
                }
                
            }
        }
    }

    public function getMovementInput():types.Direction{
        var LR = 0;
        var UD = 0;
        if(FlxG.keys.anyPressed([A,LEFT])){
            LR -= 1;
        }
        if(FlxG.keys.anyPressed([D,RIGHT])){
            LR += 1;
        }
        if(FlxG.keys.anyPressed([W,UP])){
            UD -= 1;
        }
        if(FlxG.keys.anyPressed([S,DOWN])){
            UD += 1;
        }

        if(UD != 0 && LR != 0){
            return types.Direction.NONE;
        }else if(UD == -1){
            return types.Direction.NORTH;
        }else if(UD == 1){
            return types.Direction.SOUTH;
        }else if(LR == -1){
            return types.Direction.WEST;
        }else if(LR == 1){
            return types.Direction.EAST;
        }else{
            return types.Direction.NONE;
        }
        
    }

    public function setBlocked(facingCollider,entity):Void{
        var tile = cast(entity,entities.tiles.Tile);
        entityBlocking = tile.blocking;
    }

    public function allowedMove(moveDirection):Bool{
        FlxG.overlap(facingCollider,levelEntities,setBlocked);

        //check for block in position, array out of bound, etc.
        switch(moveDirection){
            case(NORTH):
            {
                if(((playerPos.x+playerPos.y*mapSize.x) - mapSize.x >= 0) && (map[cast((playerPos.x+playerPos.y*mapSize.x) - mapSize.x,Int)] <= 0) && !entityBlocking){
                    newPos.add(0,-1);
                    return true;
                }else{
                    return false;
                }
            }
            case(EAST):
            {
                if((playerPos.x + 1 < mapSize.x) && (map[cast((playerPos.x+playerPos.y*mapSize.x) + 1,Int)] <= 0) && !entityBlocking){
                    newPos.add(1,0);
                    return true;
                }else{
                    return false;
                }
            }
            case(WEST):
            {
                if(((playerPos.x) - 1 >=0 ) && (map[cast((playerPos.x+playerPos.y*mapSize.x) - 1,Int)] <= 0) && !entityBlocking){
                    newPos.add(-1,0);
                    return true;
                }else{
                    return false;
                }
            }
            case(SOUTH):
            {
                if(((playerPos.x+playerPos.y*mapSize.x) + mapSize.x < (mapSize.y+1) * mapSize.x) && (map[cast((playerPos.x+playerPos.y*mapSize.x) + mapSize.x,Int)] <= 0) && !entityBlocking){
                    newPos.add(0,1);
                    return true;
                }else{
                    return false;
                }
            }
            case(NONE):
                return false;
        }
    }

    public function useItem():Bool{
        //Bool is if use was successful
        if(item.type == "Null"){
            return false;
        }
        if(item.consumable){
            if(item.use(this)){
                item = new entities.items.NullItem();
                // trace(cast(item,entities.items.Item));
                return true;
            }else{
                return false;
            }
        }else{
            return item.use(this);
        }
        return false;
    }

    public function pickupItem(facingCollider,ItemBlock):Void{
        var targetTile = cast(ItemBlock,entities.tiles.Tile);
        if(targetTile.type == "Item"){
            var targetItem = cast(ItemBlock,entities.tiles.ItemBlock);//This may all be a bit excessive but im in a very explicit mood
            if((targetItem.itemType != this.item.type||targetItem.itemType == "Key"||this.item.type == "Null")&&targetItem.itemType != "Null"){
                var tempItem = targetItem.item;
                targetItem.itemType = this.item.type;
                targetItem.item = this.item;
                this.item = tempItem;
                targetItem.updateSprite();
            }
        }
        
    }

    public override function update(elapsed:Float){

        this.entityBlocking = false;

        //handling input
        if(!moving){
            switch(looking){
                case NORTH:
                    animation.play("standN");
                case SOUTH:
                    animation.play("standS");
                case EAST:
                    animation.play("standE");
                case WEST:
                    animation.play("standW");
                case NONE:
                    animation.play("standN");
            }
            if(FlxG.keys.justPressed.E){
                useItem();
            }
            if(FlxG.keys.justPressed.Q){
                FlxG.overlap(facingCollider,levelEntities,pickupItem);
            }
            //Testing color for locks
            if(FlxG.keys.justPressed.R){
                item = new entities.items.Key(types.KeyColor.RED);
            }
            if(FlxG.keys.justPressed.B){
                item = new entities.items.Key(types.KeyColor.BLUE);
            }
            moveDirection = getMovementInput();
            if(moveDirection != types.Direction.NONE){
                if(moveDirection == looking){
                    if(allowedMove(moveDirection)){
                        moving = true;
                    }
                }else{
                    looking = moveDirection;
                    moveDirection = types.Direction.NONE;
                    moving = false;
                }
            }
        }
        //lerping for positions
        if(moving){
            x = FlxMath.lerp(oldPos.x*tileSize,newPos.x*tileSize,lerp);
            y = FlxMath.lerp(oldPos.y*tileSize,newPos.y*tileSize,lerp);
            lerp +=.1;
            switch(looking){
                case NORTH:
                    animation.play("moveN");
                case SOUTH:
                    animation.play("moveS");
                case EAST:
                    animation.play("moveE");
                case WEST:
                    animation.play("moveW");
                case NONE:
                    animation.play("standN");
            }
        }
        //stop lerping and reset movement
        if(lerp > 1){
            moving = false;
            lerp = 0;
            playerPos = new FlxVector(x/tileSize,y/tileSize);
            oldPos.x = newPos.x;
            oldPos.y = newPos.y;
        }
        //consider changing this to store a direction coef for UD and LR and updatse when looking changes
        switch(looking){
            case NORTH:
                facingCollider.x = x;
                facingCollider.y = y-tileSize;
            case SOUTH:
                facingCollider.x = x;
                facingCollider.y = y+tileSize;
            case EAST:
                facingCollider.x = x+tileSize;
                facingCollider.y = y;
            case WEST:
                facingCollider.x = x-tileSize;
                facingCollider.y = y;
            case NONE:
                facingCollider.x = x;
                facingCollider.y = y;
        }
        

        super.update(elapsed);
    }


}