using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DragDropManager : MonoBehaviour
{
    public float dragHeight = 5f;
    public LayerMask CargaisonLayer;
    public LayerMask BoatLayer;

    bool gotCreate = false;
    GameObject grabbed = null;

    private void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            RaycastHit hit;
            Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
            if (Physics.Raycast(ray, out hit, 100, CargaisonLayer))
            {
                gotCreate = true;
                grabbed = hit.transform.gameObject;
                grabbed.GetComponent<Rigidbody>().useGravity = false;
            }
        }

        if (Input.GetMouseButton(0))
        {
            if (gotCreate)
            {
                RaycastHit hit;
                Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
                if (Physics.Raycast(ray, out hit, 100, BoatLayer))
                {
                    Vector3 pos = hit.point;
                    pos.y += dragHeight;
                    grabbed.transform.position = pos;
                }
            }
        }

        if (Input.GetMouseButtonUp(0))
        {
            if (gotCreate)
            {
                    grabbed.GetComponent<Rigidbody>().useGravity = true;
                    grabbed = null;
                    gotCreate = false;
            }
        }
    }

}
