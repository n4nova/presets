var MultiProcedure = module ('Std/MultiProcedure');

static AccelerationMultiplier = 0.0001;
//static keyValueFunctionMap @(private) := {
//    "14" : this.update,
//    "G_pressed" : Car.gearUp
//};

/***Car***/
static Car = new Type;
Car._printableName @(override) ::= $Car;
Car.velocity := 0;
Car.direction := Geometry.Vec2;
Car.acceleration := Geometry.Vec2;
Car.mass := Number;
Car.cameraNode := MinSG.CameraNode;
Car.move @(private):= MultiProcedure;
Car.listNode @(private):= MinSG.ListNode;
Car.posx @(private):= 0;
Car.posz @(private):= 0;
Car.isAccelerating @(private) := false;

Car._constructor ::=fn(Number mass, String carMeshFilePath, 
                       Geometry.Vec2 initialDirection = new Geometry.Vec2(0,1), 
                       Geometry.Vec2 initialAcceleration  = new Geometry.Vec2(0,0)){
    this.direction = initialDirection;
    this.acceleration = initialAcceleration;
    this.mass = mass;
    this.move = new MultiProcedure();
   
    this.listNode = MinSG.loadModel(carMeshFilePath);
    //Util.registerExtension('PADrend_KeyPressed', this->fn(evt){handleInput(evt);});
    Util.registerExtension('PADrend_UIEvent', this->fn(evt){handleInput(evt);});
    Util.registerExtension('PADrend_BeforeRendering', this->fn(evt){update(evt);});
    outln("Car created");
};

Car.update ::=fn(evt){
    //outln("Sayan: Inside Car.update() ");
    this.updateVelocity();
    //TODO: update the velocity by acceleration.
    //this.velocity = this.velocity + this.acceleration;
    /*this.velocity = new Geometry.Vec2((this.velocity.getX() + this.acceleration.getX()), 
                                    (this.velocity.getY() + this.acceleration.getY()));*/
    if(this.velocity >0 ){                                        
        var tempVelocity = new Geometry.Vec2(this.direction.getX() * this.velocity, this.direction.getY() * this.velocity);
        this.posx +=tempVelocity.getX();
        this.posz +=tempVelocity.getY();
        outln(this.velocity," ",this.posx," ",this.posz);
        this.listNode.moveLocal(this.posx,0,-this.posz);
		this.onMove();
    }
};

Car.onMove @(private) ::=fn(){
    if(this.move != void)
        this.move();
};

Car.addMoveHandler ::=fn(moveHandler){
    this.move += moveHandler;
};

Car.removeMoveHandler ::=fn(moveHandler){
    this.move -= moveHandler;
};

Car.handleInput ::=fn(evt){
    //TODO
    //update the velocity vector.    
    //outln("Handle input called, evt.key: "+evt.key);
//    var handler = keyValueFunctionMap[evt.key];
//    outln(handler);
//    if(handler != void){
//        handler();
//    }
	if(evt.type==Util.UI.EVENT_KEYBOARD){
        if(evt.key == 14){
                if(evt.pressed){
                        outln("14 pressed");
                        this.onKeyDown(evt.key);
                }
                else{
                    outln("14 not pressed");
                    this.onKeyUp(evt.key);
                }
        }
	}
};

Car.onKeyDown ::=fn(key){
    //manipulate keyValue if needed
    /*Car.keyValueFunctionMap[keyValue]();
    if-else ladder checks the keyvalue and invokes approporiate method.
    */
    if(key == 14) 
            this.isAccelerating = true;
};

Car.onKeyUp ::=fn(key){
    
    /*
    manipulate keyValue if needed
    Car.keyValueFunctionMap[keyValue]();
    if-else ladder checks the keyvalue and invokes approporiate method.
    */
    
    if(key == 14) 
            this.isAccelerating = false;
};

Car.gearUp ::=fn(){
    this.acceleration = this.acceleration * AccelerationMultiplier;
};

Car.gearDown ::=fn(){
    this.acceleration = this.acceleration / AccelerationMultiplier;
};


Car.updateVelocity ::= fn(){
    if(this.isAccelerating){            
        this.velocity = this.velocity + AccelerationMultiplier;
    }
    else{
		var temp = this.velocity - AccelerationMultiplier;
	this.velocity = temp < 0 ? 0 : temp;
	}
};


Car.addToScene ::=fn(MinSG.ListNode sceneNode){
    sceneNode.addChild(this.listNode);
};

return Car;
