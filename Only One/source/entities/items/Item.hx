package entities.items;

interface Item {
    //include a sprite for ui later
    public var consumable:Bool;
    public function use(player:Player):Void;
}