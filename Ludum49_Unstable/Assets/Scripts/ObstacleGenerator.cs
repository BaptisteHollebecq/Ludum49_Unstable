using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ObstacleGenerator : MonoBehaviour
{ 
    [HideInInspector]
    public static bool loop = true;
    public float range = 20f;
    public List<GameObject> obstacles = new List<GameObject>();

    [Header("Spawn Settings")]
    public float minimumSpawnRate = 1f;
    public float maximumSpawnRate = 3f;

    [Header("Obstacles Settings")]
    public float minSpeed = 1;
    public float maxSpeed = 5;

    private void Start()
    {
        StartCoroutine(Spawn());
    }

    private void RestartSpawn()
    {
        loop = true;
        StartCoroutine(Spawn());
    }

    private IEnumerator Spawn()
    {
        while (loop)
        {
            float time = UnityEngine.Random.Range(minimumSpawnRate, maximumSpawnRate);
            yield return new WaitForSeconds(time);

            InstantiateObstacle();
        }
        yield return null;
    }

    private void InstantiateObstacle()
    {
        GameObject obj = obstacles[UnityEngine.Random.Range(0, obstacles.Count)];
        float posX = UnityEngine.Random.Range(transform.position.x - range, transform.position.x + range);

        var inst = Instantiate(obj, new Vector3(posX, transform.position.y, transform.position.z), Quaternion.identity);

        float oSpeed = UnityEngine.Random.Range(minSpeed, maxSpeed);

        Obstacles o = inst.AddComponent<Obstacles>();
        o.speed = oSpeed;
    }
}
