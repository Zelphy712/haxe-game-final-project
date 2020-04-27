package entities.items;



class Key implements Item {

    public var consumable = true;
    public var color:types.KeyColor;

    public function new(color:types.KeyColor){
        this.color = color;
        
    }

    public function use(player:Player):Void{
        //check what the player is looking at
        //check if it's interactable for this item
        //check if the door color is correct
        //if so, discard this key, and set the door to open
        //otherwise do nothing

    }


}