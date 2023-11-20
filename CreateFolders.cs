using UnityEditor;
using System.Collections.Generic;
using UnityEngine;
using System.IO;

public class CreateFolders : EditorWindow
{
    private static string projectName = "PROJECT_NAME";

    [MenuItem("Assets/Create Default Folders")]
    private static void SetUpFolders()
    {
        CreateFolders window = ScriptableObject.CreateInstance<CreateFolders>();
        window.position = new Rect(Screen.width / 2, Screen.height / 2, 400, 150);
        window.ShowPopup();
    }

    private static void CreateAllFolders()
    {
        List<string> mainFolders = new List<string>
        {
            "Art",
            "Art/Materials",
            "Art/Models",
            "Art/Textures",
            "Animations",
            "Audio",
            "Audio/Music",
            "Audio/SoundFX",
            "Code",
            "Code/Scripts",
            "Code/ScriptableObjects",
            "Code/Shaders",
            "Docs",
            "Editor",
            "Inputs",
            "Meshes",
            "Prefabs",
            "UI",
            "UI/Assets",
            "UI/Fonts",
            "UI/Icons"
        };
        foreach (string folder in mainFolders)
        {
            if (!Directory.Exists("Assets/" + projectName + "/" + folder))
            {
                Directory.CreateDirectory("Assets/" + projectName + "/" + folder);
            }
        }

        AssetDatabase.Refresh();
    }

    void OnGUI()
    {
        EditorGUILayout.LabelField("Insert the Project name used as the root folder");
        projectName = EditorGUILayout.TextField("Project Name", projectName);
        this.Repaint();
        GUILayout.Space(70);
        if (GUILayout.Button("Generate!"))
        {
            CreateAllFolders();
            this.Close();
        }
    }
}
