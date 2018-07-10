using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public class FurRenderer : MonoBehaviour {

	public Shader furShader;
	private Material mat;
    private CommandBuffer cb;
    private Camera cam;

    public Mesh testmesh;
    public Material std;

	private void Start()
	{
		mat = new Material(furShader);
        cam = Camera.main;
        cb = new CommandBuffer();
        cb.name = "Z Fur";
        cam.AddCommandBuffer(CameraEvent.AfterGBuffer, cb);

        cb.DrawMesh(testmesh, Matrix4x4.identity, std);
	}

    private void OnPreRender()
    {
        
    }
}
