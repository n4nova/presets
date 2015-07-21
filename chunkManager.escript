// "imports"
static Vec2 = Geometry.Vec2;
static Vec3 = Geometry.Vec3;

var module = load ("../PADrend/modules/EScript/Std/module.escript");
var chunkManagerObject = module("Car");
var chunkManagerObject = module("Chunk");


static T = new Type;
{
	//object variables declarations
	T._printableName @(override) ::= $ChunkManager;
	T.MIN_RADIUS @(const) ::= 50; //example value
	T.MAX_RADIUS @(const) ::= 5000; //example value
	T.car @(private) ::= Car;
	T.generationRadius ::= T.MIN_RADIUS;
	T.renderingRadius ::= T.MIN_RADIUS;
	T.seed ::= 0;
	T.random ::= new Math.RandomNumberGenerator();
	T.children @(private) ::= []; //array, containing all top level chunks
	
	//!constructor is disabled - singleton class
	T._constructor ::= void;
	
	//!start the manager and register for events from the car
	T.start ::= fn(Car car) {
		//TODO - read/set seed
		this.random.setSeed(this.seed);
		this.car = car;
		this.car.addMoveHandler(this->this.onMove);
	};
	
	//!this function gets called every frame while the car is moving
	T.onMove ::= fn() {
		//calculate radius based on car's velocity
		var radius = this.car.velocity * 1000;
		this.generationRadius = (radius < this.MIN_RADIUS) ? this.MIN_RADIUS : radius;
	};
	
	//!calculate seed based on given point
	//!given in the x-z plane
	T.getSeedFor ::= fn(Vec3 point) {
		//calc seed
		var prime = 937;
		return seed * prime * prime + point.x() * prime + point.z();
	};
	
	//!add a top level chunk to the manager
	T.addChunk ::= fn(Chunk c){
		this.children += c;
	};
	
	//!returns Chunk object, containing the given point
	//!or void if no such chunk exists
	T.getChunkForPoint ::= fn(Vec3 point) {
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
	
	//TODO
	T.checkRadius ::= fn(){
		//check if the circle has reached a missing chunk
		//get chunks at the border of the circle, which need to be generated
	};
	
}

return T;