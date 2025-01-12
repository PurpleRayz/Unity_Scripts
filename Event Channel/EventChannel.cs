using System.Collections.Generic;
using UnityEngine;

namespace TreasureIsle.EventSystem
{
    /// <summary>
    /// Event channel is a ScriptableObject that can be used to publish an event.
    /// </summary>
    public abstract class EventChannel<T> : ScriptableObject
    {
        readonly HashSet<EventListener<T>> observers = new(); // hashset is used to avoid duplicates and qucikly iterates over the list

        public void Invoke(T value) {
            foreach (var observer in observers)
            {
                observer.Raise(value);
            }
        }
        
        public void Register(EventListener<T> observer) => observers.Add(observer);
        public void Deregister(EventListener<T> observer) => observers.Remove(observer);
    }

    // Empty event channel is used to create an event channel without any observers
    public readonly struct Empty { }
    
    [CreateAssetMenu(menuName = "Create EmptyEventChannel", fileName = "EmptyEventChannel", order = 0)]
    public class EmptyEventChannel : EventChannel<Empty> { }
}
