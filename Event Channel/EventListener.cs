using System;
using UnityEngine;
using UnityEngine.Events;

namespace TreasureIsle.EventSystem
{
    // Event listener is a MonoBehaviour that can be used to subscribe to an event channel.
    // Place this script on a GameObject and add an EventChannel to it.
    // The event channel can be any type of EventChannel, but it must be a generic type.
    // The EventListener can be any type of MonoBehaviour, but it must be a generic type.
    // The EventListener must have a UnityEvent<T> field named unityEvent, where T is the type of the event channel.
    public abstract class EventListener<T> :MonoBehaviour {
        [SerializeField] EventChannel<T> eventChannel;
        [SerializeField] UnityEvent<T> unityEvent;
        protected void Awake() {
            eventChannel.Register(this);
        }
        protected void OnDestroy() {
            eventChannel.Deregister(this);
        }
        public void Raise(T value) => unityEvent.Invoke(value);
    }
    
    public class EventListener : EventListener<Empty> { }
}