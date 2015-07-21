// created by Srijani and Neel
var module = load ("../PADrend/modules/EScript/Std/module.escript");
//var chunkManagerObject = module("ChunkManager");
var polygon = module("Polygon");


//take all points for creating polygon

var pointB= new Geometry.Vec3(7, 0, 0);
var pointA= new Geometry.Vec3(7, 0, 8);
var pointC= new Geometry.Vec3(4, 0, 5);
var pointD= new Geometry.Vec3(11, 0, 6);
var pointE= new Geometry.Vec3(11, 0, 2);
var pointF= new Geometry.Vec3(4, 0, 2);


var verticesPoints = [pointA,pointB,pointC,pointD,pointE,pointF];

var polygonObject = new polygon(verticesPoints) ;

//sort vertices
var verticesListSorted = polygonObject.getVertices();

//draw polygon object
polygonObject.draw();

//get input from user
// as of now taken 2 arbitrary points
var voronoiPoint = new Geometry.Vec3(5, 0, 3);
var userPoint = new Geometry.Vec3(8, 0, 4);

//calculate slope and intercept of the perpendicular bisect of the points
var mcPerpendicular = polygonObject.getSlopeAndInterceptOfPerpendicular(voronoiPoint, userPoint);


// calculate slope and intercept for all the edges of the polygon and storing them in array 'slopeInterceptArray'
var slopeInterceptArray = [];
var i = 0;
var noOfVertices = verticesListSorted.count();
for(var count =0; count<noOfVertices;count++){
	if(count<noOfVertices-1)
	{
		//find the slope of the lines using points
		slopeInterceptArray[i++] = polygonObject.getSlopeAndIntercept(verticesPoints[count], verticesPoints[count+1]);
	}
	else
	{
		if(count===(noOfVertices-1))
		{
			//find the slope of the lines using points
			slopeInterceptArray[i++] = polygonObject.getSlopeAndIntercept(verticesPoints[count], verticesPoints[0]);
		}
	}
}


//calculate the intersection points between the edges 
//and the perpendicular bisect and storing points in 'intersectionPointArray'
var intersectionPointArray = [];
i=0; //resetting the counter i to ZERO
for(var j=0; j<slopeInterceptArray.count(); j++)
{	
		var point = polygonObject.getIntersectionPoint(slopeInterceptArray[j], mcPerpendicular);
		//outln("POINT IS AGAIN:: "+ point.x() + "," + point.z());
		intersectionPointArray[i++] = point;	
}

//check which intersection points are on(edges) of the polygon and 
//store the points in 'intersectOnPolygon'
var intersectOnPolygon = polygonObject.getCuttingPoints(intersectionPointArray);

polygonObject.printArray("New Points :: ", intersectOnPolygon);
 
//add the newly obtained intersection points with the old vertices
var length = verticesListSorted.count();

verticesListSorted[length] =  intersectOnPolygon[0];
verticesListSorted[length+1] =  intersectOnPolygon[1];


//sort all the vertices along with the intercept in clockwise direction
verticesListSorted = polygonObject.sortVertices2(verticesListSorted);

//outln(verticesListSorted);

polygonObject.printArray("New sorted list of vertices ::" , verticesListSorted);

//divide the polygon in 2 parts
var indexFirst;
var indexSecond;
outln("I am Here 1");
outln();
for(var j =0; j<verticesListSorted.count(); j++){
	if(intersectOnPolygon[0]===verticesListSorted[j])
		indexFirst = j;
} 
outln("Indexfirst "+ indexFirst);
outln();
for(var j =0; j<verticesListSorted.count(); j++){
	if(indexFirst!==j){
		if(intersectOnPolygon[1]===verticesListSorted[j])
		indexSecond = j;
	}	
}
outln("IndexSecond "+ indexSecond);
outln();
//swap values if indexFirst>indexSecond
if(indexFirst>indexSecond){
	var swap = indexFirst;
	indexFirst = indexSecond;
	indexSecond = swap;
}

//creating polygon 1_1
var firstPolygonVertices = [];
var k =0;
for(var j =indexFirst; j<=indexSecond; j++){
	firstPolygonVertices[k++] = verticesListSorted[j];
}

polygonObject.printArray("firstPolygonVertices :: ",firstPolygonVertices);
outln();

//draw polygon object
//polygonObject = new polygon(firstPolygonVertices) ;
//polygonObject.draw(new Util.Color4f(1, 0, 0, 1));

//creating polygon 1_2
k = 0;
var secondPolygonVertices = [];
for(var j =indexSecond; j<verticesListSorted.count(); j++){
	secondPolygonVertices[k++] = verticesListSorted[j];
}


for(var j =0; j<=indexFirst; j++){
	secondPolygonVertices[k++] = verticesListSorted[j];
}

polygonObject.printArray("SecondPolygonVertices :: ", secondPolygonVertices);

//draw polygon object
//polygonObject = new polygon(secondPolygonVertices) ;
//polygonObject.draw(new Util.Color4f(0, 1, 0, 1));

