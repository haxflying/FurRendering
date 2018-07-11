v1.0
Initial release.

HOW TO USE PAINTER TOOL:
The tool is located under "Window->TOZ->Tools->Vertex Painter" menu.
When you click on the menu, you will see a small window open on top left corner of your
screen.
If you havent selected any objects in your scene, select one which you want to paint.
In order to paint an object, it must check the following criteria:
*Selection must be a GameObject
*Selection must have a collider (It must be a mesh collider in order to paint correctly)
*Selection must have a MeshFilter component
*Selection must have a Mesh defined in its MeshFilter component
NOTE: YOU CAN ONLY PAINT 1 MESH AT A TIME!!

After the selection passes the above criteria, you will see 2 buttons in the Vertex Paint window.
"Start/Stop Painting" and "Show/Hide Vertex Colors" buttons.

1- Start/Stop Painting:
If you press this button, you will go into painting mode, which you will see several other options.
Brush Size: Is the size of painting area which is shown with a circle on your scene view.
Brush Opacity: Is the strength of your brush pressure.
Brush Color: Is the color you want to paint.
Vertex Colors: buttons change all vertex colors at once to chosen color.
RGBA Buttons: These buttons represent color channels Red, Green, Blue and Alpha.
Save New Mesh: After you are satisfied with your painted vertices, clicking this button will save the painted mesh
as a new Mesh asset in your main project folder and it will be selected.

NOTE: If you want to use the supplied Splat shaders, you should only use the main channels to paint your vertices.
NOTE2: While painting, if you stop painting, you will lose all previous painted data.

2- Show/Hide Vertex Colors:
If you click on this button now, you will see the vertex colors of your mesh if there is any.
If the mesh has no vertex colors at all, you will see a white surface.
While in "painting mode", you can show vertex colors/original material anytime by pressing this button.

INCLUDED SHADERS:
There are 2 splat shaders and 1 debug shader included in the package.
VertexColors shader: This shader is used for showing the vertex colors of a mesh while in paint mode.
Unlit shader: This shader takes 4 textures and blends them with the painted vertex colors in an unlit fashion.
Standard: This is a standard shader that takes 4 diffuse and 4 normal textures and blends them with the vertex colors in standard fashion.
NOTE: If you want to see the textures being painted, it is better to change your objects material to Unlit and
then start painting, so when you show/hide vertex colors, you can actually see the texture being painted as well.

KNOWN ISSUES:
None.

Support:
For any questions, you can contact me from aubergine2010@gmail.com.

Thanks for buying the package.