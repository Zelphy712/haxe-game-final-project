package entities;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class Player extends FlxSprite {
    //change movement so that you move only if you were already looking in the direction you wan to move, otherwise turn to face that way.

    public var looking = types.Direction;

    static inline var TILE_SIZE:Int = 32;

    
    static inline var MOVEMENT_SPEED:Int = 2;
 
    
    public var moveToNextTile:Bool;

    var moveDirection:types.Direction;

    public override function new(?x:Float=0, ?y:Float=0){
        super(x,y);
        makeGraphic(32,32,FlxColor.MAGENTA);
    }

    public override function update(elapsed:Float){

        // Move the player to the next block
		if (moveToNextTile){
            switch (moveDirection)
            {
                case NORTH:
                    y -= MOVEMENT_SPEED;
                case SOUTH:
                    y += MOVEMENT_SPEED;
                case WEST:
                    x -= MOVEMENT_SPEED;
                case EAST:
                    x += MOVEMENT_SPEED;
            }
        }
    
            // Check if the player has now reached the next block
        if ((x % TILE_SIZE == 0) && (y % TILE_SIZE == 0)){
            moveToNextTile = false;
        }

        if (FlxG.keys.anyPressed([DOWN, S])){
            moveTo(types.Direction.SOUTH);
        }
        else if (FlxG.keys.anyPressed([UP, W]))
        {
            moveTo(types.Direction.NORTH);
        }
        else if (FlxG.keys.anyPressed([LEFT, A]))
        {
            moveTo(types.Direction.WEST);
        }
        else if (FlxG.keys.anyPressed([RIGHT, D]))
        {
            moveTo(types.Direction.EAST);
        }

        super.update(elapsed);
    }

    public function moveTo(Direction:types.Direction):Void{
        // Only change direction if not already moving
        if (!moveToNextTile)
        {
            moveDirection = Direction;
            moveToNextTile = true;
        }
    }

}