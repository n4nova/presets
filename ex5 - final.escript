var createRectangularMesh = fn(length, width){ 
    var mb = new Rendering.MeshBuilder();
    mb.normal(new Geometry.Vec3(0 , 0 , 1 ));
    var index1; var index2; var index3; var index4;   
        
    for(var z=1;z<=length;z++){
            for(var x=1;x<=width;x++){
                     
                                 
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
    return [mesh,index3];
};

var sceneNode = new MinSG.ListNode();
PADrend.registerScene(sceneNode);
PADrend.selectScene(sceneNode);
var geoNode = new MinSG.GeometryNode();

var lengthMesh=100;var widthMesh=100;

[var mesh, var lastIndex] =createRectangularMesh(lengthMesh,widthMesh);


//var bitmap = Util.loadBitmap( __DIR__+"/heightmap.png");
//var bitmap = Util.loadBitmap( __DIR__+"/vishwak.png");
var bitmap = Util.loadBitmap( __DIR__+"/super.png");

var pixelAccessor = Util.PixelAccessor.create( bitmap );

var width = pixelAccessor.getWidth();

var height = pixelAccessor.getHeight();

// create a position attribute accessor
var posAccessor = Rendering.PositionAttributeAccessor.create(mesh, Rendering.VertexAttributeIds.POSITION);
// create a color attribute accessor
var colAccessor = Rendering.ColorAttributeAccessor.create(mesh, Rendering.VertexAttributeIds.COLOR);

for(var i=0;i<lastIndex;i++){
        var position = posAccessor.getPosition(i);
        
        var posx = (position.x()>widthMesh?widthMesh:position.x());
        var posz = (position.z()>lengthMesh?lengthMesh:position.z());
               
        var x = posx *((width-1)/widthMesh);
        var y = posz *((height-1)/lengthMesh);
                
        var clr = pixelAccessor.readColor4f(x,y);
        var r = clr.r();
       
        colAccessor.setColor( i , new Util.Color4f( r , r , r , 1 ));
        posAccessor.setPosition(i, new Geometry.Vec3(position.x(), r * 10, position.z()));
}

geoNode.setMesh(mesh);
sceneNode.addChild(geoNode);
