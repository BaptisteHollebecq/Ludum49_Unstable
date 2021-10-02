using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraFollow : MonoBehaviour
{
    public Transform Ship;
    public bool Rigid = false;

    Vector3 _offeset = Vector3.zero;
    float _distance = 0;
    float _height = 0;

    private void Awake()
    {
        _offeset = (transform.position - Ship.position).normalized;
        _distance = (Ship.position - transform.position).magnitude;
        _height = transform.position.y;
    }

    private void LateUpdate()
    {
        if (Rigid)
            transform.position = Ship.position + (_offeset * _distance);
        else
        {
            Vector3 newPos = Ship.position + (_offeset * _distance);
            newPos.y = _height;
            transform.position = newPos;
        }
    }
}
