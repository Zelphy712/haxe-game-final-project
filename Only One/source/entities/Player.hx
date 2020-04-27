package entities;

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


    static inline var TILE_SIZE:Int = 32;

    
    static inline var MOVEMENT_SPEED:Int = 2;
 
    
    public var moveToNextTile:Bool;

    var moveDirection:types.Direction;
    var looking:types.Direction;


    var file:String;
    var mapJSON:DynamicAccess<Dynamic>;
    var map:Array<Int>;
    var mapSize:FlxVector;
    var playerPos:FlxVector;
    
    var moving:Bool;
    var lerp:Float;
    var oldPos:FlxVector;
    var newPos:FlxVector;
    



    public override function new(?x:Float=0, ?y:Float=0,?mapName:String=""){
        super(x,y);
        loadMap(mapName);
        makeGraphic(32,32,FlxColor.MAGENTA);
        moving = false;
        lerp = 0;
        moveDirection = types.Direction.NONE;
        looking = types.Direction.NORTH;
    }

    public function loadMap(mapName){
        //TODO:set tile size from json also

        file = Assets.getText(mapName);
        mapJSON = haxe.Json.parse(file);
        for(layer in cast (mapJSON.get('layers'),Array<Dynamic>)) {
            if(layer.name == "Walls"){
                map = layer.data;
                mapSize = new FlxVector(layer.gridCellsX, layer.gridCellsY);
            }
            if(layer.name == "Entities"){
                //loop through entities
                for(ent in cast(layer.entities,Array<Dynamic>)){
                    //set playerPos with it's x and y
                    if(ent.name = "Player"){
                        playerPos = new FlxVector(ent.x/TILE_SIZE,ent.y/TILE_SIZE);
                        trace("playerPos: ", playerPos);
                        oldPos = newPos = playerPos;
                    }
                }
                
                //TODO:create a collection of of enitites for collision and pickup (maybe)
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

    public function allowedMove(moveDirection):Bool{
        //check for block in position, array out of bound, etc.
        switch(moveDirection){
            case(NORTH):
            {
                if(((playerPos.x+playerPos.y*mapSize.x) - mapSize.x >= 0)/*won't move off map*/ && (map[cast((playerPos.x+playerPos.y*mapSize.x) - mapSize.x,Int)] <= 0)){
                    newPos.add(0,-1);
                    return true;
                }
            }
            case(EAST):
            {
                if((playerPos.x + 1 < mapSize.x)/*won't move off map*/ && (map[cast((playerPos.x+playerPos.y*mapSize.x) + 1,Int)] <= 0)){
                    newPos.add(1,0);
                    return true;
                }
            }
            case(WEST):
            {
                if(((playerPos.x) - 1 >=0 )/*won't move off map*/ && (map[cast((playerPos.x+playerPos.y*mapSize.x) - 1,Int)] <= 0)){
                    newPos.add(-1,0);
                    return true;
                }
            }
            case(SOUTH):
            {
                if(((playerPos.x+playerPos.y*mapSize.x) + mapSize.x < (mapSize.y+1) * mapSize.x)/*won't move off map*/ && (map[cast((playerPos.x+playerPos.y*mapSize.x) + mapSize.x,Int)] <= 0)){
                    newPos.add(0,1);
                    return true;
                }
            }
            case(NONE):
            return false;
        }
    }

    public override function update(elapsed:Float){

        if(!moving){
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
        if(lerp > 1){
            moving = false;
            lerp = 0;
            playerPos = new FlxVector(x/TILE_SIZE,y/TILE_SIZE);
            oldPos = newPos;
        }
        if(moving){
            x = FlxMath.lerp(oldPos.x*TILE_SIZE,newPos.x*TILE_SIZE,lerp);
            y = FlxMath.lerp(oldPos.y*TILE_SIZE,newPos.y*TILE_SIZE,lerp);
            lerp +=.05;
        }

        super.update(elapsed);
    }


}