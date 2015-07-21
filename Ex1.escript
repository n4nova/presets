var rectangleMesh = Rendering.MeshBuilder.createRectangle(1.0 , 1.0);
var geoNode = new MinSG.GeometryNode();
geoNode.setMesh( rectangleMesh );

var sceneNode = new MinSG.ListNode();

PADrend.registerScene(sceneNode);
PADrend.selectScene(sceneNode);

//create a new node holding the slides of the cube
var cube = new MinSG.ListNode();

//front
var side1 = geoNode.clone();
side1.moveLocal(0.0, 0.0, 0.5);
side1.rotateLocal_deg(180.0, 0.0, 1.0, 0.0);
cube.addChild(side1);

//back
var side2 = geoNode.clone();
side2.moveLocal(0.0, 0.0, -0.5);
cube.addChild(side2);

//left
var side3 = geoNode.clone();
side3.moveLocal(-0.5, 0.0, 0.0);
side3.rotateLocal_deg(90.0, 0.0, 1.0, 0.0);
cube.addChild(side3);

//right
var side4 = geoNode.clone();
side4.moveLocal(0.5, 0.0, 0.0);
side4.rotateLocal_deg(-90.0, 0.0, 1.0, 0.0);
cube.addChild(side4);

//top
var side5 = geoNode.clone();
side5.moveLocal(0.0, 0.5, 0.0);
side5.rotateLocal_deg(90.0, 1.0, 0.0, 0.0);
cube.addChild(side5);

//bottom
var side6 = geoNode.clone();
side6.moveLocal(0.0, 0.5, 0.0);
side6.rotateLocal_deg(-90.0, 1.0, 0.0, 0.0);
cube.addChild(side6);


//add layers
var pyramid = new MinSG.ListNode();
var num = 10;
var squareClone;


var n = 0.0;
var n1 = 1.0;

while(num>0)
{
	var row = new MinSG.ListNode();
	for(var i = 0; i<num; i++)
	{
	var cloneCube = cube.clone();
	cloneCube.moveLocal(0.5*(i+1),0.0,0.0);
	row.addChild(cloneCube);
	}

	var square = new MinSG.ListNode();
	for(var i = 0; i<num; i++)
	{
	var cloneRow = row.clone();
	cloneRow.moveLocal(0.0,0.0,0.5*(i+1));
	square.addChild(cloneRow);
	}

	squareClone =  square.clone(); 
	
	squareClone.moveLocal(0.25*(10-num+1),0.5*(10-num+1),0.25*(10-num+1)); //????

	var color = new Util.Color4f(n , 0.00 , n1 , 0.5 );
	n = n+0.1; 
	n1 = n1- 0.1;
	
	var materialState = new MinSG.MaterialState();
	materialState.setAmbient( color );
	materialState.setDiffuse( color );
	squareClone.addState(materialState);
	outln("color "+materialState);

	

	num =num-1;

	pyramid.addChild(squareClone);
}
sceneNode.addChild(pyramid);