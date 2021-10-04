using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class Bidet : MonoBehaviour
{
    public List<GameObject> cargo = new List<GameObject>();

    public LayerMask Obstacle;
    public LayerMask Cargaison;

    private void Update()
    {
        if (cargo.Count == 0)
        {
            SceneManager.LoadScene(0);
        }
    }

    private void OnCollisionEnter(Collision collision)
    {

        if (collision.gameObject.tag == "obstacle")
            Destroy(collision.gameObject);

        if (collision.gameObject.tag == "cargo")
        {

            cargo.Remove(collision.gameObject);
            Destroy(collision.gameObject);
        }
    }
}
