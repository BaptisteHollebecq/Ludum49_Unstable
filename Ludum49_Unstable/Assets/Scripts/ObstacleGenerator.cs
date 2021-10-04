using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

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

    [Header("Waves heights")]
    public float heightWave1;
    public float heightWave2;
}

public class ObstacleGenerator : MonoBehaviour
{
    [HideInInspector]
    public static bool loop = true;
    public Waves waves;
    public float range = 20f;

    public Text text;

    public List<GameObject> obstacles = new List<GameObject>();
    public List<Difficulty> Difficulties = new List<Difficulty>();

    private float _timeSinceStart = 0;
    private int _difficultyIndex = 0;

    private void Start()
    {
        StartCoroutine(Spawn());
    }


    private void Update()
    {
        _timeSinceStart += Time.deltaTime;
        if (_timeSinceStart > Difficulties[_difficultyIndex].endOfDifficultyLevel && Difficulties.Count > _difficultyIndex + 1)
        {
            _difficultyIndex++;
            StartCoroutine(TransiOctaves(Difficulties[_difficultyIndex]));
        }


        text.text = Mathf.Floor(_timeSinceStart).ToString();
    }

    public IEnumerator TransiOctaves(Difficulty difficulty)
    {
        float elapsed = 0;


        //var startingPos : Vector3 = transform.position;
        float baseHeight1 = waves.Octaves[0].height;
        float baseHeight2 = waves.Octaves[1].height;

        while (elapsed < difficulty.transitionTimeToNextLevel)
        {
            waves.Octaves[0].height = Mathf.Lerp(baseHeight1, difficulty.heightWave1, (elapsed / difficulty.transitionTimeToNextLevel));
            waves.Octaves[1].height = Mathf.Lerp(baseHeight2, difficulty.heightWave2, (elapsed / difficulty.transitionTimeToNextLevel));

            elapsed += Time.deltaTime;
            yield return new WaitForEndOfFrame();
        }
        waves.Octaves[0].height = difficulty.heightWave1;
        waves.Octaves[1].height = difficulty.heightWave2;



        yield return null;
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
