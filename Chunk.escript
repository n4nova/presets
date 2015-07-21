// "imports"
static Vec2 = Geometry.Vec2;
static Vec3 = Geometry.Vec3;
static GeoNode = MinSG.GeometryNode;
static Polygon = load('presets/Polygon.escript');
static ChunkManager = load('presets/ChunkManager.escript');

static T = new Type;
{
	//object variables declarations
	T._printableName @(override) ::= $Chunk;
	T.border @(private) := Polygon;
	T.center := Vec3; //init in constructor
	T.seed := 0;
	T.geometry @(private, init) := GeoNode;
	T.children @(private, init) := Array; //array, containing all child chunks
	T.random := void; //init in constructor
	
	//!create a chunk with the dimensions of the given polygon
	T._constructor ::= fn(Polygon p) {
		this.border = p; //set border of chunk
		this.center = this.border.getCenterPoint(); //central point of the chunk
		this.seed = ChunkManager.getSeedFor(this.center); //get seed for chunk
		this.random = new Math.RandomNumberGenerator(); //get pseudo random generator
		this.random.setSeed(this.seed); //set the seed of the generator
	};
	
	//!activate GeometryNode for rendering
	T.activateChunk ::= fn(){
		this.geometry.activate();
	};
	
	//!deactivate GeometryNode for rendering
	T.deactivateChunk ::= fn(){
		this.geometry.deactivate();
	};
	
	//!add subchunk
	T.addChildChunk ::= fn(T c){
		this.children += c;
	};
	//!returns Chunk object, containing the given point
	//!or void if the point is outside of it
	T.getChunkForPoint ::= fn(Vec3 point) {
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

return T;