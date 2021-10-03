using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using DG.Tweening;

[System.Serializable]
public enum MenuType { Main, Credit, Options }
public enum MenuSide { Left, Right, Top, Bottom }

public class MainMenu : MonoBehaviour
{
    public MenuType menuType = MenuType.Main;
    public float transitionTime = .2f;

    private void Awake()
    {
        Actualize();
    }

    public void PlayGame()
    {
        SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex + 1);
    }

    public void OnButtonClick(string type)
    {
        switch (type)
        {
            case "Main":
                menuType = MenuType.Main;
                break;
            case "Credit":
                menuType = MenuType.Credit;
                break;
        }
        Actualize();
    }

    public void QuitGame()
    {
        Application.Quit();
    }

    void Actualize()
    {
        foreach (Transform t in transform)
        {
            MenuObject obj = t.GetComponent<MenuObject>();

            if (obj.types.Contains(menuType))
                Show(obj);
            else
                Hide(obj);
        }
    }

    void Show(MenuObject obj)
    {
        if (!obj.gameObject.activeSelf)
        {
            switch (obj.side)
            {
                case MenuSide.Left:
                    {
                        obj.gameObject.SetActive(true);
                        obj.transform.DOLocalMoveX(0, transitionTime/2);
                        break;
                    }
                case MenuSide.Right:
                    {
                        obj.gameObject.SetActive(true);
                        obj.transform.DOLocalMoveX(0, transitionTime/2);
                        break;
                    }
                case MenuSide.Top:
                    {
                        obj.gameObject.SetActive(true);
                        obj.transform.DOLocalMoveY(0, transitionTime/2);
                        break;
                    }
                case MenuSide.Bottom:
                    {
                        obj.gameObject.SetActive(true);
                        obj.transform.DOLocalMoveX(0, transitionTime/2);
                        break;
                    }
            }
        }
    }

    void Hide(MenuObject obj)
    {
        if (obj.gameObject.activeSelf)
        {
            switch (obj.side)
            {
                case MenuSide.Left:
                    {
                        obj.transform.DOLocalMoveX(-1920, transitionTime/2).OnComplete(()=>
                        {
                            obj.gameObject.SetActive(false);
                        });
                        break;
                    }
                case MenuSide.Right:
                    {
                        obj.transform.DOLocalMoveX(1920, transitionTime/2).OnComplete(() =>
                        {
                            obj.gameObject.SetActive(false);
                        });
                        break;
                    }
                case MenuSide.Top:
                    {
                        obj.transform.DOLocalMoveY(1080, transitionTime/2).OnComplete(() =>
                        {
                            obj.gameObject.SetActive(false);
                        });
                        break;
                    }
                case MenuSide.Bottom:
                    {
                        obj.transform.DOLocalMoveX(-1080, transitionTime/2).OnComplete(() =>
                        {
                            obj.gameObject.SetActive(false);
                        });
                        break;
                    }
            }
        }
    }
}
