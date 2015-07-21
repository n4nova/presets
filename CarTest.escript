var module = load ("../PADrend/modules/EScript/Std/module.escript");

//var box = new Geometry.Box (0 ,0 ,0 ,1 ,1 ,1); //x,y,z,width ,height , depth
//var boxMesh = Rendering.MeshBuilder.createBox(box);

var Car = module("Car");

//var car = new Car(new Geometry.Vec2(1,2),new Geometry.Vec2(1,2),10,boxMesh);
//var car = new Car(10,"data/mesh/Cars/1.obj",new Geometry.Vec2(0.00001,0.00001),new Geometry.Vec2(0,0));
var car = new Car(10,"data/mesh/Cars/1.obj",new Geometry.Vec2(-1,0));
//car.handleInput();
//outln(car.velocity.getY());

var sceneNode = new MinSG.ListNode();
PADrend.registerScene(sceneNode);
PADrend.selectScene(sceneNode);
car.addToScene(sceneNode);
