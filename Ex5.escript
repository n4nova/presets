
// Create a MeshBuilder instance
var mb = new Rendering.MeshBuilder();

// Set the normal of the next vertex
mb.normal(new Geometry.Vec3(0,0,1));


/*for(var i =0;i<10;i++)
{
	for(var j = 0;j<10; j++)
	{
		mb.color(new Util.Color4f( 0 , 0 , 0 , 0 ));  
		mb.position(new Geometry.Vec3(i, 0, j));
		var index1 = mb.addVertex();

		mb.color(new Util.Color4f( 0 , 0 , 0 , 0 ));
		mb.position(new Geometry.Vec3(i+1, 0, j+1));
		var index2 = mb.addVertex();

		mb.color(new Util.Color4f( 0 , 0 , 0 , 0 ));
		mb.position(new Geometry.Vec3(i+2, 0, j+2));
		var index3 = mb.addVertex();

		mb.color(new Util.Color4f( 0 , 0 , 0 , 0 ));
		mb.position(new Geometry.Vec3(i+1, 0, j+2));
		var index4 = mb.addVertex();

		mb.addQuad(index4 , index3 , index2 , index1 );
	}
}
// build the mesh
var mesh= mb.buildMesh(); */

var index1; var index2; var index3; var index4;  
for(var z=1;z<=257;z++){
            for(var x=1;x<=257;x++){
                     
                                 
                    if(x===1){
                        mb.color(new Util.Color4f( 0 , 0 , 0 , 0 ));  
                        mb.position(new Geometry.Vec3(x, 0, z));
                        index1 = mb.addVertex();
                    }
                    mb.color(new Util.Color4f( 0 , 0 , 0 , 0 ));
                    mb.position(new Geometry.Vec3(x+1, 0, z));
                    index2 = mb.addVertex();
                    
                    mb.color(new Util.Color4f( 0 , 0 , 0 , 0 ));
                    mb.position(new Geometry.Vec3(x+1, 0, (z+1)));
                    index3 = mb.addVertex();
                    
                    if(x===1){
                        mb.color(new Util.Color4f( 0 , 0 , 0 , 0 ));
                        mb.position(new Geometry.Vec3(x, 0, (z+1)));
                        index4 = mb.addVertex();
                    }

                    if(x===1){
                        mb.addQuad(index4 , index3 , index2 , index1 );
                    }
                    else if (x===2){
                        mb.addQuad(index2-2 , index3 , index2 , index2-3 );
                    }
                    else {                            
                        mb.addQuad(index2-1 , index3 , index2 , index2-2 );
                    }
                
        }
    }
    // build the mesh
    var mesh = mb. buildMesh();


var bitmap = Util . loadBitmap (__DIR__+ "/heightmap.png");


var pixelAccessor = Util . PixelAccessor . create ( bitmap );
var width = pixelAccessor . getWidth ();
var height = pixelAccessor . getHeight ();

var posAccessor = Rendering . PositionAttributeAccessor . create (mesh , Rendering . VertexAttributeIds . POSITION );
var colAccessor = Rendering . ColorAttributeAccessor . create (mesh , Rendering . VertexAttributeIds . COLOR );

var index=0;
var count=0;
var i=0 ;
var j =0;


count=0;
for(var k=0;k<132611;k++)
{
	var position = posAccessor . getPosition (k);
	
	var x = position.x();
	var z = position.z();
	var r = pixelAccessor.readColor4f(x,z).r();
	
	colAccessor . setColor (k,new Util.Color4f(r,r,r,0));
	
	posAccessor . setPosition ( k , new Geometry.Vec3(position.x(),r*10,position.z()) );
	
	outln(k);
}


var geoNode = new MinSG.GeometryNode();
geoNode.setMesh(mesh);
var sceneNode = new MinSG.ListNode();

PADrend.registerScene(sceneNode);
PADrend.selectScene(sceneNode);

sceneNode += geoNode;