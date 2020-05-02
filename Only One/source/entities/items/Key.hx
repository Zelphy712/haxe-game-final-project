package entities.items;

import flixel.FlxG;
import flixel.FlxObject;



class Key implements Item {

    public var type = "Key";
    public var consumable = true;
    public var color:types.KeyColor;
    public var used = false;

    public function new(color:types.KeyColor){
        this.color = color;
        
    }

    public function use(player:Player):Bool{
        //check what the player is looking at
        switch(player.looking){
            case NORTH:{
                    if(player.map[cast((player.playerPos.x+player.playerPos.y*player.mapSize.x) - player.mapSize.x,Int)] <= 0){
                        trace("no wall");
                        FlxG.overlap(player.facingCollider,player.levelEntities,openDoor);
                        return used;
                    }else{
                        trace("Wall");
                    }
                }
            case SOUTH:{
                    if(player.map[cast((player.playerPos.x+player.playerPos.y*player.mapSize.x) + player.mapSize.x,Int)] <= 0){
                        trace("no wall");
                        FlxG.overlap(player.facingCollider,player.levelEntities,openDoor);
                    return used;
                    }else{
                        trace("Wall");
                    }
                }
            case EAST:{
                if(player.map[cast((player.playerPos.x+player.playerPos.y*player.mapSize.x) + 1,Int)] <= 0){
                    trace("no wall");
                    FlxG.overlap(player.facingCollider,player.levelEntities,openDoor);
                    return used;
                }else{
                    trace("Wall");
                }
            }
            case WEST:
                if(player.map[cast((player.playerPos.x+player.playerPos.y*player.mapSize.x) - 1,Int)] <= 0){
                    trace("no wall");
                    FlxG.overlap(player.facingCollider,player.levelEntities,openDoor);
                    return used;
                }else{
                    trace("Wall");
                }
            case NONE:
                return false;
        }
        //check if it's interactable for this item
        //check if the door color is correct
        //if so, discard this key, and set the door to open
        //otherwise do nothing
        return false;
    }

    public function openDoor(key,door):Void{
        // trace("Key:",cast(key,entities.items.Key));
        trace("Key:",this);
        trace("Door:",cast(door,entities.tiles.Door));

        var door = cast(door,entities.tiles.Door);
        if(door.colour == color){
            used = door.open();
        }
    }


}