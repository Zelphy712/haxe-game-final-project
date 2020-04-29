package levels;

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
        
        var door = new Door(96,96,types.KeyColor.RED);
        entities.add(door);
        add(door);
        trace(entities.members);
        player.levelEntities = entities;
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
		}
	}

    public override function update(elapsed:Float){
        super.update(elapsed);
        // FlxG.collide(player,map);
        // FlxG.collide(player,doors);
    }


    


}