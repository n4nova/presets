static Vec3 = Geometry.Vec3;

static T = new Type;
{
	//object variables declarations
	T._printableName @(override) ::= $Polygon;
	T.vertices @(private, init) := Array; //array of Vec3 objects,
												//representing the vertices
	T.color @(private) := new Util.Color4f(1, 0, 0, 1); //default color is red
	
	//!construct the polygon by passing it an array of Vec3
	//!objects, representing the vertices
	T._constructor ::= fn(vert){
		this.vertices = vert;
		//sort vertices of polygon clockwise
		this.sortVertices();
	};
	
	//!sorts the vertices of the polygon clockwise
	//!works for convex polygons only
	T.sortVertices @(private) ::= fn(){
		//get center point of polygon
		static innerPoint = this.getCenterPoint();
		//sort clockwise according to angle towards the inner point
		this.vertices.sort(fn(a,b){
			//calculate a vector from every vertex in direction of the inner point
			var aVec = innerPoint - a;
			var bVec = innerPoint - b;
			//compare the angles of the computed vectors
			return Math.atan2(aVec.x(), aVec.z()) <= Math.atan2(bVec.x(), bVec.z());
		});
		
	};
	
	//!returns the central point of the polygon
	//!point is inside if polygon is convex
	T.getCenterPoint ::= fn(){
		var x = 0;
		var y = 0;
		var z = 0;
		//sum the coordinates of all vetices
		foreach(this.vertices as var v){
			x += v.x();
			y += v.y();
			z += v.z();
		}
		
		//compute and return a central point for the polygon
		return new Vec3(x / this.vertices.count(), y / this.vertices.count(), z / this.vertices.count());
	};
	
	//!returns true if point is inside of polygon, false otherwise
	//!both point and polygon are projected on the x-z plane
	//!does not necessarily mean that point is in the same plane
	T.containsPoint ::= fn(Vec3 point){
		var result = false;
		var nvert = this.vertices.count();
		var j = nvert - 1;
		var i;
		for (i = 0; i < nvert; i++)
		{
			var vert_i = this.vertices[i];
			var vert_j = this.vertices[j];
			//cast a semiinfinite horizontal ray through the point
			if (((vert_i.z() > point.z()) != (vert_j.z() > point.z())) &&
				(point.x() < (vert_j.x() - vert_i.x()) * (point.z() - vert_i.z()) / (vert_j.z() - vert_i.z()) + vert_i.x() ))
			{
				//if the ray goes through an edge, negate current result
				result = !result;
			}
			j = i;
		}
		return result;
	};
	
	//!draw polygon
	T.draw ::= fn(){
		// create a MeshBuilder instance
		var mb = new Rendering.MeshBuilder();
		// set the color of the vertices
		mb.color(this.color);
		// set position of next vertex and add it to the MeshBuilder
		foreach(this.vertices as var v){
			mb.position(v);
			mb.addVertex();
		}
		// add triangles always starting from the first vertex
		for(var i=0; i<this.vertices.count()-2; i++){
			mb.addTriangle(0, i+1, i+2);
		}
		// build the mesh
		var mesh= mb.buildMesh();
		// create a geo node
		var geoNode = new MinSG.GeometryNode();
		// calculate the normals
		Rendering.calculateNormals(mesh);
		// add the mesh to the geo node
		geoNode.setMesh(mesh);
		// create a scene node
		var sceneNode = new MinSG.ListNode();
		// register scene node to PADrend
		PADrend.registerScene(sceneNode);
		// select scene in PADrend
		PADrend.selectScene(sceneNode);
		// add geo node to scene node
		sceneNode += geoNode;
	};
	
	//!returns the number of polygon vertices
	T.getNumVertices ::= fn(){
		return this.vertices.count();
	};
	
	//!returns the vertices of the polygon
	T.getVertices ::= fn(){
		return this.vertices;
	};
	
	//!set color of the polygon
	T.setColor ::= fn(Util.Color4f color){
		this.color = color;
	};
	
	//added by Srijani/Neel
	// Calculates the slope and z-intercept for two points
	T.getSlopeAndIntercept ::= fn(Vec3 pointA, Vec3 pointB){
		var slope;
		var intercept;
		var undefinedSlope = 60;
		if(pointB.x()===pointA.x())
		{
			//parallel to z axis, thus slope undefined
			slope = undefinedSlope;
			intercept = pointA.x();
		}
		else{
			slope = (pointB.z()-pointA.z())/(pointB.x()-pointA.x());
			intercept = pointA.z()-(slope*pointA.x());
		}
		var arrayOfData = [];
		arrayOfData[0] = slope;
		arrayOfData[1] = intercept;
		return arrayOfData;
	};
	
	//added by Srijani/Neel
	// Calculates the slope and z-intercept for the perpendicular bisect
	T.getSlopeAndInterceptOfPerpendicular ::= fn(Vec3 pointA, Vec3 pointB){
		var midX = (pointA.x() + pointB.x())/2;
		var midZ = (pointA.z() + pointB.z())/2;
		var slope = (pointB.z() - pointA.z()) / (pointB.x() - pointA.x());
		var slopeOfPerpendicular = -(1/slope);
		var interceptOfPerpendicular = midZ - slopeOfPerpendicular * midX;
		
		var arrayOfData = [];
		arrayOfData[0] = slopeOfPerpendicular;
		arrayOfData[1] = interceptOfPerpendicular;
		return arrayOfData;

	};
	
	//added by Srijani/Neel
	// Calculates the intersection point for two lines
	T.getIntersectionPoint ::= fn(var slopeInterceptLine1, var slopeInterceptLine2){
		var a = slopeInterceptLine1[0];
		var c = slopeInterceptLine1[1];
		var b = slopeInterceptLine2[0];
		var d = slopeInterceptLine2[1];
		var intersectX;
		var intersectZ;
		var undefinedSlope = 60;
		if(a===b) //line1 and line2 are parallel
		{
			//intersectX = -0;
			//intersectZ = -0;
		}
		else
		{
			if(a===undefined){
				intersectX = c;
				intersectZ = (b * c) + d;
			}
			else
			{
				if(b===undefined)
				{
					intersectX = d;
					intersectZ = (a * d) + c;
				}
				else{
					intersectX = (d-c)/(a-b);
					intersectZ = ((a * d)-(b * c))/(a - b);
				}
			}
		}
		
		var intersectionPoint = new Vec3(intersectX, 0, intersectZ);
		return intersectionPoint;
	};
	
	//!sorts the vertices of the polygon clockwise
	//!works for convex polygons only
	T.sortVertices2 ::= fn(var vertices){
	
		//get center point of polygon
		static innerPoint = this.getCenterPoint();
	
		//sort clockwise according to angle towards the inner point
		vertices.sort(fn(a,b){
			//calculate a vector from every vertex in direction of the inner point
			var aVec = innerPoint - a;
			var bVec = innerPoint - b;
			//compare the angles of the computed vectors
			return Math.atan2(aVec.x(), aVec.z()) <= Math.atan2(bVec.x(), bVec.z());
		});
		
	};
	
}

return T;