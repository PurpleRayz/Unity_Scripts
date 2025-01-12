using UnityEngine;

namespace TreasureIsle.EventSystem
{
    [CreateAssetMenu(menuName = "Create IntEventChannel", fileName = "IntEventChannel", order = 0)]
    public class IntEventChannel : EventChannel<int> { }
}