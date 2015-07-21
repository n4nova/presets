// "imports"
var Vec2 = Geometry.Vec2;
var Vec3 = Geometry.Vec3;
var GeoNode = MinSG.GeometryNode;


static ChunkManager = new Type;
{
	var T = ChunkManager;
	T._constructor ::= void; // prevent instantiation
	T.seed ::= 0;
	T.random ::= new Math.RandomNumberGenerator();
	T.children @(private) ::= []; //array, containing all top level chunks
	T.onStart ::= fn() {
		//read/set seed
		this.random.setSeed(this.seed);
		Car.addEventListener(this.onMove);
	};
	T.onMove ::= fn(Car car) {
		var radius = …;
	};
	T.getSeedFor ::= fn(Number x, Number z) {
		//calc seed
		var prime = 937;
		return seed * prime * prime + x * prime + z;
	};
	T.addChunk ::= fn(Chunk c){
		this.children += c;
	};
	// @returns Chunk object, containing the given point
	//	or void if no such chunk exists
	T.getChunkForPoint ::= fn(Vec2 point) {
		if(!this.children.empty()){
			//iterate over children and find the right chunk
			foreach(this.children as var chunk){
				var enclosingChunk = chunk.getChunkForPoint(point);
				if(enclosingChunk !== void){
					return enclosingChunk;
				}
			}
		}
		return void;
	};
}


var Polygon = new Type;
{
	Polygon.vertices @(private, init) := Array; //array of Vec2 objects,
												//representing the vertices
	Polygon._constructor ::= fn(vert){
		this.vertices = vert;
		//sort vertices clockwise
		this.sortVertices();
	};
	//sorts the vertices of the polygon clockwise
	//works for convex polygons only
	Polygon.sortVertices @(private) ::= fn(){
		//calculate inner point
		// added the z component at we need to compare for x and z axis
		var x = 0;
		var y = 0;
		var z = 0;
		foreach(this.vertices as var v){
			x += v.x();
			y += v.y();
			z += v.z();
		}
		
		// modified Vec2 to Vec3 as we need to use 3D points in mesh
		static innerPoint = new Geometry.Vec3(x / this.vertices.count(), y / this.vertices.count(), z / this.vertices.count());
		//sort clockwise according to angle towards the inner point
		this.vertices.sort(fn(a,b){
			var aVec = innerPoint - a;
			var bVec = innerPoint - b;
			
			//modified this method, because lesser than 
			//function not comparing properly between the point which are lying of same x axis or z axis.
			return Math.atan2(aVec.x(), aVec.z()).radToDeg() <= Math.atan2(bVec.x(), bVec.z()).radToDeg();
		});
		
	};
	Polygon.getNumVertices ::= fn(){
		return this.vertices.count();
	};
	Polygon.getVertices ::= fn(){
		return this.vertices;
	};
}

// Function added by Srijani, Neel to draw a polygon using the points
var Draw = new Type;
{
	Draw.vertices @(private, init) := Array;
	Draw._constructor ::= fn(sortedVertices){
		this.vertices = sortedVertices;
		this.drawPolygon();
	};
	Draw.drawPolygon @(private) := fn(){
		outln("Creating polygon 1");

		// Create a MeshBuilder instance
		var mb = new Rendering.MeshBuilder();

		// Set the normal of the next vertex
		mb.normal(new Geometry.Vec3(0,0,1));

		var points = [];
		var counter = 0;
		mb.color(new Util.Color4f( 1, 0 , 0 , 0 ));
		
		foreach(this.vertices as var v){
			var point= v;
			mb.position(point);
			points[counter++] = mb.addVertex();
		}
		
		outln("Creating polygon 1 --> "+ points.count());

		for(var i=0;i<points.count()-2;i++)
		{
			outln("Adding points : "+ 0 +","+ (i+1)+","+ (i+2));
			mb.addTriangle(points[0],points[i+1],points[i+2]);
			
		}

		// build the mesh
		var mesh= mb.buildMesh();
		var geoNode = new MinSG.GeometryNode();
		geoNode.setMesh(mesh);

		outln("DONE");

		var sceneNode = new MinSG.ListNode();

		PADrend.registerScene(sceneNode);
		PADrend.selectScene(sceneNode);

		sceneNode += geoNode;
	};
}

static Chunk = new Type;
{
	var T = Chunk;
	T.center := void; //init in constructor
	T.seed := 0;
	T.border @(private) := void;
	T.geometry @(private, init) := GeoNode;
	T.children @(private, init) := Array; //array, containing all child chunks
	T.random := void; //init in constructor
	T._constructor ::= fn(Number x, Number z, Polygon p) {
		this.center = new Vec2(x,z);
		this.border = p; //set border of chunk
		this.seed = ChunkManager.getSeedFor(x, z);
		this.random = new Math.RandomNumberGenerator();
		this.random.setSeed(this.seed);
	};
	T.activateChunk ::= fn(){
		//activate GeometryNode
		this.geometry.activate();
	};
	T.deactivateChunk ::= fn(){
		//deactivate GeometryNode
		this.geometry.deactivate();
	};
	T.addChildChunk ::= fn(Chunk c){
		this.children += c;
	};
	// @returns Chunk object, containing the given point
	//	or void if the point is outside of it
	T.getChunkForPoint ::= fn(Vec2 point) {
		if(this.border.containsPoint(point)){
			if(!this.children.empty()){
				//iterate over children and find the right chunk
				foreach(this.children as var chunk){
					var enclosingChunk = chunk.getChunkForPoint(point);
					if(enclosingChunk !== void){
						return enclosingChunk;
					}
				}
			}
			return this;
		}
		return void;
	};
}

//3D points are used as mesh does not take 2d points

//sample points for pentagon
/*var pointB= new Geometry.Vec3(1, 0, 2);
var pointA= new Geometry.Vec3(3, 0, 4);
var pointC= new Geometry.Vec3(5, 0, 1);
var pointD= new Geometry.Vec3(4, 0, 0);
var pointE= new Geometry.Vec3(2, 0, 0);

var verticesPoints = [pointA,pointB,pointC,pointD,pointE]; */

//sample points for hexagon
var pointB= new Geometry.Vec3(7, 0, 0);
var pointA= new Geometry.Vec3(7, 0, 8);
var pointC= new Geometry.Vec3(4, 0, 5);
var pointD= new Geometry.Vec3(11, 0, 6);
var pointE= new Geometry.Vec3(11, 0, 2);
var pointF= new Geometry.Vec3(4, 0, 2);

var verticesPoints = [pointA,pointB,pointC,pointD,pointE,pointF]; 

//creating polygon object
var polygonObject = new Polygon(verticesPoints);
var verticesListSorted = polygonObject.getVertices();
/*foreach(verticesListSorted as var v){
	outln(v.x());
	outln(v.y());
	outln(v.z());
	outln("==========================");
} */

//draw polygon object
var drawPol = new Draw(verticesListSorted);