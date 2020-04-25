package entities.tiles;

import flixel.util.FlxColor;
import flixel.FlxSprite;

class Door extends FlxSprite{

    public var colour:types.KeyColor;

    public override function new(x:Float,y:Float,color:types.KeyColor){
        super(x,y);
        this.colour = color;

        switch(colour){
            case RED:
                makeGraphic(32,32,FlxColor.RED);
            case GREEN:
                makeGraphic(32,32,FlxColor.GREEN);
            case BLUE:
                makeGraphic(32,32,FlxColor.BLUE);
            
        }



    }

}