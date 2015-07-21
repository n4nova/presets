var rectangleMesh = Rendering.MeshBuilder.createRectangle(1.0 , 1.0);
var geoNode = new MinSG.GeometryNode();
geoNode.setMesh( rectangleMesh );

var sceneNode = new MinSG.ListNode();

PADrend.registerScene(sceneNode);
PADrend.selectScene(sceneNode);


//create a new node holding the slides of the cube
var cube = new MinSG.ListNode();

//front
var side1 = geoNode.clone();
side1.moveLocal(0.0, 0.0, 0.5);
side1.rotateLocal_deg(180.0, 0.0, 1.0, 0.0);
cube.addChild(side1);

//back
var side2 = geoNode.clone();
side2.moveLocal(0.0, 0.0, -0.5);
cube.addChild(side2);

//left
var side3 = geoNode.clone();
side3.moveLocal(-0.5, 0.0, 0.0);
side3.rotateLocal_deg(90.0, 0.0, 1.0, 0.0);
cube.addChild(side3);

//right
var side4 = geoNode.clone();
side4.moveLocal(0.5, 0.0, 0.0);
side4.rotateLocal_deg(-90.0, 0.0, 1.0, 0.0);
cube.addChild(side4);

//top
var side5 = geoNode.clone();
side5.moveLocal(0.0, 0.5, 0.0);
side5.rotateLocal_deg(90.0, 1.0, 0.0, 0.0);
cube.addChild(side5);

//bottom
var side6 = geoNode.clone();
side6.moveLocal(0.0, 0.5, 0.0);
side6.rotateLocal_deg(-90.0, 1.0, 0.0, 0.0);
cube.addChild(side6);



sceneNode.addChild(cube);



