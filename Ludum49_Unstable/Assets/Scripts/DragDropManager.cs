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
    Vector3 lastPos = Vector3.zero;

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
                lastPos = grabbed.transform.position;
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
                RaycastHit hit;
                Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
                if (!Physics.Raycast(ray, out hit, 100, BoatLayer))
                {
                    grabbed.transform.position = lastPos;
                    grabbed.GetComponent<Rigidbody>().useGravity = true;
                    grabbed = null;
                    lastPos = Vector3.zero;
                    gotCreate = false;
                }
                else
                {
                    lastPos = Vector3.zero;
                    grabbed.GetComponent<Rigidbody>().useGravity = true;
                    grabbed = null;
                    gotCreate = false;
                }
            }
        }
    }

}
