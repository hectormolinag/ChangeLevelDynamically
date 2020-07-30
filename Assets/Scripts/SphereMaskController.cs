using UnityEngine;
[ExecuteInEditMode]
public class SphereMaskController : MonoBehaviour {
 
	public float radius = 0.5f;

	public float adjusmentRadius = 0.5f;
	
	private static readonly int GlobalMaskPosition = Shader.PropertyToID("_GLOBALMaskPosition");
	private static readonly int GlobalMaskRadius = Shader.PropertyToID("_GLOBALMaskRadius");
	private static readonly int GlobalRadius = Shader.PropertyToID("_GLOBALRadius");
	private static readonly int Position = Shader.PropertyToID("_Position");


	private void Start()
	{
		radius = adjusmentRadius;
	}

	void Update ()
	{
		Vector3 position = transform.position;
		
		Shader.SetGlobalVector(Position, position);
		Shader.SetGlobalVector (GlobalMaskPosition, position);
		
		radius = Mathf.PingPong(Time.time * 20f, 84f);
		radius += 0.5f;
		
		Shader.SetGlobalFloat (GlobalMaskRadius, radius);
		Shader.SetGlobalFloat(GlobalRadius, radius - adjusmentRadius);
		
	}
	
}