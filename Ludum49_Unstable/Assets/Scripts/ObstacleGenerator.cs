using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[Serializable]
public class Difficulty
{
    public float endOfDifficultyLevel = 2;
    public float transitionTimeToNextLevel = 2;
    [Header("Spawn Settings")]
    public float minimumSpawnRate = 1f;
    public float maximumSpawnRate = 3f;
    [Header("Obstacles Settings")]
    public float minSpeed = 1;
    public float maxSpeed = 5;
    public List<Waves.Octave> Octaves = new List<Waves.Octave>();
}

public class ObstacleGenerator : MonoBehaviour
{
    [HideInInspector]
    public static bool loop = true;
    public Waves waves;
    public float range = 20f;
    public List<GameObject> obstacles = new List<GameObject>();
    public List<Difficulty> Difficulties = new List<Difficulty>();

    private float _timeSinceStart = 0;
    private int _difficultyIndex = 0;

    private void Awake()
    {
        Waves.TransitionFinished += ChangeDifficulty;
    }

    private void OnDestroy()
    {
        Waves.TransitionFinished -= ChangeDifficulty;
        
    }

    private void Start()
    {
        StartCoroutine(Spawn());
    }

    public void ChangeDifficulty()
    {
        _difficultyIndex++;
    }

    private void Update()
    {
        _timeSinceStart += Time.deltaTime;
        if (_timeSinceStart > Difficulties[_difficultyIndex].endOfDifficultyLevel && Difficulties.Count > _difficultyIndex + 1)
        {
            StartCoroutine(waves.TransiOctaves(Difficulties[_difficultyIndex + 1]));
        }
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
            float time = UnityEngine.Random.Range(Difficulties[_difficultyIndex].minimumSpawnRate, Difficulties[_difficultyIndex].maximumSpawnRate);
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

        float oSpeed = UnityEngine.Random.Range(Difficulties[_difficultyIndex].minSpeed, Difficulties[_difficultyIndex].maxSpeed);

        Obstacles o = inst.AddComponent<Obstacles>();
        o.speed = oSpeed;
    }
}
