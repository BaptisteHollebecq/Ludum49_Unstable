using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Rigidbody))]
public class ShipMovement : MonoBehaviour
{
    public Transform Motor;
    //public float speed = 3f;
    public float minimalAngleToMove = 3f;
    public float MovementForce = 250f;

    Rigidbody _rb;
    //float _left = 0;

    bool leftPressed = false;
    bool rightPressed = false;

    private void Awake()
    {
        _rb = GetComponent<Rigidbody>();
    }

    private void Update()
    {
        rightPressed = false;
        leftPressed = false;
        //_left =  Vector3.SignedAngle(Vector3.up, transform.up, Vector3.forward);

        if (Input.GetKey(KeyCode.LeftArrow))
            leftPressed = true;
        if (Input.GetKey(KeyCode.RightArrow))
            rightPressed = true;

    }

    private void FixedUpdate()
    {
        /*if (_left > minimalAngleToMove || _left < -minimalAngleToMove)
        {
            ApplyForceToReachVelocity(transform.right * -_left * MovementForce, 1);
        }*/

        if (leftPressed)
        {
            Debug.Log("left");
            ApplyForceToReachVelocity(-transform.right * MovementForce, .5f);
        }

        else if (rightPressed)
        {
            Debug.Log("right");
            ApplyForceToReachVelocity(transform.right * MovementForce, .5f);
        }

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
