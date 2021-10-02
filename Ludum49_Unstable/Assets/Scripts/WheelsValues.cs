using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WheelsValues : MonoBehaviour
{
    public float mass = .5f;
    public float radius = .25f;
    public float wheelDampingRate = 10f;
    public float suspensionDistance = .5f;
    public float forceApplicationDistance = 0;
    public Vector3 center = Vector3.zero;
    [Header("Spring")]
    public float spring = 100f;
    public float damper = 20f;
    public float targetPosition = 0;
    [Header("Forward Friction")]
    public float extremumSlipF = 1;
    public float extremumValueF = 1;
    public float asymptoteSlipF = 1;
    public float asymptoteValueF = 1;
    public float StiffnessF = 1;
    [Header("Sideway Friction")]
    public float extremumSlipS = 1;
    public float extremumValueS = 1;
    public float asymptoteSlipS = 1;
    public float asymptoteValueS = 1;
    public float StiffnessS = 1;

    [ContextMenu("Setup Values")]
    public void SetupValues()
    {
        foreach (Transform t in transform)
        {
            WheelCollider w = t.GetComponent<WheelCollider>();

            w.mass = mass;
            w.radius = radius;
            w.wheelDampingRate = wheelDampingRate;
            w.suspensionDistance = suspensionDistance;
            w.forceAppPointDistance = forceApplicationDistance;
            w.center = center;
            JointSpring s = new JointSpring
            {
                spring = spring,
                damper = damper,
                targetPosition = targetPosition
            };
            w.suspensionSpring = s;
            WheelFrictionCurve forward = new WheelFrictionCurve
            {
                extremumSlip = extremumSlipF,
                extremumValue = extremumValueF,
                asymptoteSlip = asymptoteSlipF,
                asymptoteValue = asymptoteValueF,
                stiffness = StiffnessF
            };
            w.forwardFriction = forward;
            WheelFrictionCurve side = new WheelFrictionCurve
            {
                extremumSlip = extremumSlipS,
                extremumValue = extremumValueS,
                asymptoteSlip = asymptoteSlipS,
                asymptoteValue = asymptoteValueS,
                stiffness = StiffnessS
            };
            w.forwardFriction = side;
        }
    }


}
