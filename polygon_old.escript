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
points[counter++] = mb.addVertex(); 

mb.color(new Util.Color4f( 1, 0 , 0 , 0 ));
var pointC= new Geometry.Vec3(5, 0, 2);
mb.position(pointC);
points[counter++] = mb.addVertex(); 

mb.color(new Util.Color4f( 1, 0 , 0 , 0 ));
var pointD= new Geometry.Vec3(4, 0, 0);
mb.position(pointD);
points[counter++] = mb.addVertex(); 

mb.color(new Util.Color4f( 1, 0 , 0 , 0 ));
var pointE=new Geometry.Vec3(2, 0, 0);
mb.position(pointE);
points[counter++] = mb.addVertex();

mb.color(new Util.Color4f( 1, 0 , 0 , 0 ));
var pointF=new Geometry.Vec3(7, 0, 3);
mb.position(pointF);
points[counter++] = mb.addVertex(); 


outln("Creating polygon 1");

for(var i=0;i<4;i++)
{
	mb.addTriangle(points[0],points[i+1],points[i+2]);
	
}

// build the mesh
var mesh= mb.buildMesh();
var geoNode = new MinSG.GeometryNode();
geoNode.setMesh(mesh);

outln("DONE");

outln("Creating polygon 2");

// Create a MeshBuilder instance
var mb1 = new Rendering.MeshBuilder();
// Set the normal of the next vertex
mb1.normal(new Geometry.Vec3(0,0,1));

var x1= 3;
var z1= 4;

var x2= 5;
var z2=2;

var  polygon2 = [];
counter=0;

mb1.color(new Util.Color4f( 0, 1 , 0 , 0 ));
var point0 = new Geometry.Vec3(3, 0, 4);
mb1.position(point0);
polygon2[counter++] = mb1.addVertex();

mb1.color(new Util.Color4f( 0, 1 , 0 , 0 ));
var point1= new Geometry.Vec3(x1, 0, z1+1);
mb1.position(point1);
polygon2[counter++] = mb1.addVertex();

mb1.color(new Util.Color4f( 0, 1 , 0 , 0 ));
var point2= new Geometry.Vec3(x1+1, 0, z1+2);
mb1.position(point2);
polygon2[counter++] = mb1.addVertex();

mb1.color(new Util.Color4f( 0, 1 , 0 , 0 ));
var point3= new Geometry.Vec3(x1+5, 0, z1+1);
mb1.position(point3);
polygon2[counter++] = mb1.addVertex();

mb1.color(new Util.Color4f( 0, 1 , 0 , 0 ));
var point4= new Geometry.Vec3(5, 0, 2);
mb1.position(point4);
polygon2[counter++] = mb1.addVertex();



//outln("counter "+counter);

for(var j=0;j<counter-3;j++)
{
	mb1.addTriangle(polygon2[0],polygon2[j+1],polygon2[j+2]);
	mb1.color(new Util.Color4f( 0 , 0 , 1 , 0 ));
}


// build the mesh
var mesh1= mb1.buildMesh();

var geoNode1 = new MinSG.GeometryNode();
geoNode1.setMesh(mesh1);

var sceneNode = new MinSG.ListNode();

PADrend.registerScene(sceneNode);
PADrend.selectScene(sceneNode);

sceneNode += geoNode;
sceneNode += geoNode1;