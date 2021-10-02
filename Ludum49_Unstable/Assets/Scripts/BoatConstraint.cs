using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BoatConstraint : MonoBehaviour
{
    private float _zValue;
    private float _yRot;
    private void Awake()
    {
        _zValue = transform.position.z;
        _yRot = transform.rotation.y;
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        transform.position = new Vector3(transform.position.x, transform.position.y, _zValue);
        transform.rotation = new Quaternion(transform.rotation.x, _yRot, transform.rotation.z, transform.rotation.w);
    }
}
