package entities.items;

class NullItem implements Item {

    public var type = "Null";
    public var consumable = false;
    
    public function use(player:Player):Bool{
        //Shouldn't ever be called
        return false;
    }

    public function new():Void{

    }
}