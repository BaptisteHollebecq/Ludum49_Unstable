﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Rigidbody))]
public class Obstacles : MonoBehaviour
{
    public float speed = 1;

    private Rigidbody _rb;

    private void Awake()
    {
        _rb = GetComponent<Rigidbody>();

        _rb.angularDrag = .5f;
    }

    private void FixedUpdate()
    {
        ApplyForceToReachVelocity(-Vector3.forward * speed, 1);
    }

    public void ApplyForceToReachVelocity(Vector3 velocity, float force = 1, ForceMode mode = ForceMode.Force)
    {
        if (force == 0 || velocity.magnitude == 0)
            return;

        velocity = velocity + velocity.normalized * 0.2f * _rb.drag;

        //force = 1 => need 1 s to reach velocity (if mass is 1) => force can be max 1 / Time.fixedDeltaTime
        force = Mathf.Clamp(force, -_rb.mass / Time.fixedDeltaTime, _rb.mass / Time.fixedDeltaTime);

        //dot product is a projection from rhs to lhs with a length of result / lhs.magnitude https://www.youtube.com/watch?v=h0NJK4mEIJU
        if (_rb.velocity.magnitude == 0)
        {
            _rb.AddForce(velocity * force, mode);
        }
        else
        {
            var velocityProjectedToTarget = (velocity.normalized * Vector3.Dot(velocity, _rb.velocity) / velocity.magnitude);
            _rb.AddForce((velocity - velocityProjectedToTarget) * force, mode);
        }
    }
}