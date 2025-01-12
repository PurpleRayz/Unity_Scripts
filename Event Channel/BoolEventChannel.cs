using UnityEngine;

namespace TreasureIsle.EventSystem
{
    [CreateAssetMenu(menuName = "Create BoolEventChannel", fileName = "BoolEventChannel", order = 0)]
    public class BoolEventChannel : EventChannel<bool> { }
}