outln("Creating polygon 1");

// Create a MeshBuilder instance
var mb = new Rendering.MeshBuilder();

// Set the normal of the next vertex
mb.normal(new Geometry.Vec3(0,0,1));

var points = [];
var counter = 0;



mb.color(new Util.Color4f( 1, 0 , 0 , 0 ));
var pointA= new Geometry.Vec3(1, 0, 2);
mb.position(pointA);
points[counter++] = mb.addVertex();

mb.color(new Util.Color4f( 1, 0 , 0 , 0 ));
var pointB= new Geometry.Vec3(3, 0, 4);
mb.position(pointB);

mb.color(new Util.Color4f( 1, 0 , 0 , 0 ));
var pointC= new Geometry.Vec3(4, 0, 1);
mb.position(pointA);
points[counter++] = mb.addVertex();

mb.color(new Util.Color4f( 1, 0 , 0 , 0 ));
var pointD= new Geometry.Vec3(1, 0, 5);
mb.position(pointB);

var l1 = new Geometry.Line3(pointA, pointB);
outln("L1 : "+l1.toString());

var l2 = new Geometry.Line3(pointC, pointD);
outln("L2 :"+l2.toString());

var i;
i = l1.getIntersection( l2 );

//outln("Srijani "+ l1.getMaxParam());
	

points[counter++] = mb.addVertex();



var midPoint;
var midX = (pointA.x() + pointB.x())/2;
var midZ = (pointA.z() + pointB.z())/2;

midPoint = new Geometry.Vec3(midX,0,midZ);

var l = new Geometry.Line3(pointA, pointB);


// build the mesh
var mesh= mb.buildMesh();
var geoNode = new MinSG.GeometryNode();
geoNode.setMesh(mesh);

outln("DONE");


var sceneNode = new MinSG.ListNode();

PADrend.registerScene(sceneNode);
PADrend.selectScene(sceneNode);

sceneNode += geoNode;
