package levels;

import entities.tiles.ItemBlock;
import entities.tiles.Door;
import flixel.group.FlxGroup;
import flixel.FlxObject;
import flixel.FlxG;
import entities.Player;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.tile.FlxTilemap;

class Lvl1 extends FlxState{
    public var player:Player;
	private var levelLoader:FlxOgmo3Loader;
    private var map:FlxTilemap;
    public var entities:FlxGroup;

    public override function new(door:Int){
        super();
        entities = new FlxGroup();
        
        setUpLevel();
        
        add(player);
        add(map);
        
        // var door = new Door(96,96,types.KeyColor.RED);
        // entities.add(door);
        // add(door);
        // trace(entities.members);
        // player.levelEntities = entities;
        add(player.facingCollider);
    }


    private function setUpLevel():Void {
		
        levelLoader = new FlxOgmo3Loader(AssetPaths.ogmo_final_project__ogmo, 
            AssetPaths.testLevel__json);
            
		FlxG.worldBounds.setSize(
            levelLoader.getLevelValue("width"), levelLoader.getLevelValue("height"));
            
		map = levelLoader.loadTilemap(AssetPaths.walls__png, "Walls");
        map.setTileProperties(1, FlxObject.ANY);

		levelLoader.loadEntities(placeEntities, "Entities");
    }
    
    private function placeEntities(entityData:EntityData):Void {
        player = new Player(0,0,AssetPaths.testLevel__json);
        // trace(entityData);
		if (entityData.name == "Player") {
			player.x = entityData.x - entityData.originX;// + Player.OFFSET_X;
            
            player.y = entityData.y - entityData.originY;// + Player.OFFSET_Y;
		}else if(entityData.name == "redDoor"){
            entities.add(new Door(entityData.x-entityData.originX,entityData.y-entityData.originY,types.KeyColor.RED));
        }else if(entityData.name == "blueDoor"){
            entities.add(new Door(entityData.x-entityData.originX,entityData.y-entityData.originY,types.KeyColor.BLUE));
        }else if(entityData.name == "greenDoor"){
            entities.add(new Door(entityData.x-entityData.originX,entityData.y-entityData.originY,types.KeyColor.GREEN));
        }else if(entityData.name == "redKey"){
            entities.add(new ItemBlock(entityData.x-entityData.originX,entityData.y-entityData.originY,new entities.items.Key(types.KeyColor.RED)));
        }else if(entityData.name == "blueKey"){
            entities.add(new ItemBlock(entityData.x-entityData.originX,entityData.y-entityData.originY,new entities.items.Key(types.KeyColor.BLUE)));
        }else if(entityData.name == "greenKey"){
            entities.add(new ItemBlock(entityData.x-entityData.originX,entityData.y-entityData.originY,new entities.items.Key(types.KeyColor.GREEN)));
        }
        add(entities);
        player.levelEntities = entities;
	}

    public override function update(elapsed:Float){
        super.update(elapsed);
        // FlxG.collide(player,map);
        // FlxG.collide(player,doors);
    }

}