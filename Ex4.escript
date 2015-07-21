
// Create a MeshBuilder instance
var mb = new Rendering.MeshBuilder();

// Set the normal of the next vertex
mb.normal(new Geometry.Vec3(0,0,1));

for(var i =0;i<10;i++)
{
	for(var j = 0;j<10; j++)
	{
		mb.color(new Util.Color4f( 1 , 0 , 0 , 0 ));  
		mb.position(new Geometry.Vec3(i+1, 2, j+1));
		var index1 = mb.addVertex();

		mb.color(new Util.Color4f( 0 , 1 , 0 , 0 ));
		mb.position(new Geometry.Vec3(i+2, 2, j+1));
		var index2 = mb.addVertex();

		mb.color(new Util.Color4f( 0 , 0 , 1 , 0 ));
		mb.position(new Geometry.Vec3(i+2, 2, j+2));
		var index3 = mb.addVertex();

		mb.color(new Util.Color4f( 0 , 0 , 0 , 0 ));
		mb.position(new Geometry.Vec3(i+1, 2, j+2));
		var index4 = mb.addVertex();

		mb.addQuad(index4 , index3 , index2 , index1 );
	}
}


// build the mesh
var mesh= mb.buildMesh();

var geoNode = new MinSG.GeometryNode();
geoNode.setMesh(mesh);
var sceneNode = new MinSG.ListNode();

PADrend.registerScene(sceneNode);
PADrend.selectScene(sceneNode);

sceneNode += geoNode;