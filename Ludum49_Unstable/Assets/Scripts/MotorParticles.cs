using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[RequireComponent(typeof(Collider))]
public class MotorParticles : MonoBehaviour
{
    public LayerMask waterMask;
    public ParticleSystem system;

    private Collider _collider;

    private void Awake()
    {
        _collider = GetComponent<Collider>();
        _collider.isTrigger = true;
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.layer == waterMask)
        {
            system.gameObject.SetActive(true);
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.gameObject.layer == waterMask)
        {
            system.gameObject.SetActive(false);
        }
    }
}
