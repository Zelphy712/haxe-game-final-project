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
    public var background:FlxTilemap;
    public var entities:FlxGroup;
    public var exit:entities.tiles.Exit;
    public var lvl:Int;
    public var levels = [AssetPaths.lvl1__json,AssetPaths.lvl2__json,AssetPaths.lvl3__json,AssetPaths.lvl4__json,AssetPaths.lvl5__json,AssetPaths.lvl6__json,AssetPaths.lvl7__json];

    public override function new(level:Int){
        super();
        entities = new FlxGroup();
        lvl = level;
        setUpLevel();
        
        
        add(background);
        add(map);
        add(entities);
        add(player);
        
        if (FlxG.sound.music == null) // don't restart the music if it's already playing
        {
            FlxG.sound.playMusic(AssetPaths.PuzzlingSpaces__wav, 1, true);
        }
        
        add(player.facingCollider);
    }


    private function setUpLevel():Void {
        levelLoader = new FlxOgmo3Loader(AssetPaths.ogmo_final_project__ogmo, 
            levels[lvl]);
            
		FlxG.worldBounds.setSize(
            levelLoader.getLevelValue("width"), levelLoader.getLevelValue("height"));
            
        background = levelLoader.loadTilemap(AssetPaths.walls__png,"background");
        background.setTileProperties(1,FlxObject.NONE);
		map = levelLoader.loadTilemap(AssetPaths.walls__png, "Walls");
        map.setTileProperties(1, FlxObject.ANY);
        

		levelLoader.loadEntities(placeEntities, "Entities");
    }
    
    private function placeEntities(entityData:EntityData):Void {
        

		if (entityData.name == "Player") {
            player = new Player(0,0,levels[lvl]);
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
        }else if(entityData.name == "exit"){
            exit = new entities.tiles.Exit(entityData.x-entityData.originX,entityData.y-entityData.originY);
            entities.add(exit);
        }else if(entityData.name == "collapsingFloor"){
            entities.add(new entities.tiles.CollapsingFloor(entityData.x-entityData.originX,entityData.y-entityData.originY));
        }
        // add(entities);
        if(player!= null){
            player.levelEntities = entities;
        }else{
            // trace("panic");
        }
	}

    public override function update(elapsed:Float){
        super.update(elapsed);
        FlxG.overlap(player,exit,nextLevel);
        if(FlxG.keys.justPressed.R){
            FlxG.switchState(new levels.Lvl1(lvl));
        }
        // FlxG.collide(player,map);
        // FlxG.collide(player,doors);
    }

    public function nextLevel(a,b):Void{
        if(lvl == levels.length-1){
            FlxG.switchState(new WinScreen());
        }else{
            FlxG.switchState(new levels.Lvl1(lvl+1));
        }
    }

}