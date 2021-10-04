using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotateHelice : MonoBehaviour
{
    private Transform transform;
    public float speed;
    private float y;

    // Start is called before the first frame update
    void Start()
    {
        transform = GetComponent<Transform>();

    }

    // Update is called once per frame
    void Update()
    {
        y += Time.deltaTime * speed;
        transform.localRotation = Quaternion.Euler(0, y, 0);
    }
}
