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
    var oldX:Float;
    var oldY:Float;
    var newX:Float;
    var newY:Float;
    



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
        //set newX and newY from moveDirection if applicable
        //for now just returnig true to work on other things
        return true;
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
                }
            }
        }else if(lerp > 1){ 
            moving = false;
            lerp = 0;
        }else{
            FlxMath.lerp(oldX,newX,lerp);
            FlxMath.lerp(oldY,newY,lerp);
            lerp +=.1;
        }

        super.update(elapsed);
    }


}