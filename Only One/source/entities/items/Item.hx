package entities.items;

interface Item {
    //include a sprite for ui later
    public var type:String;
    public var consumable:Bool;
    //bool represents if the use was successful/item was consumed
    public function use(player:Player):Bool;
}