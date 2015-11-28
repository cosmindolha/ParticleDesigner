package com.cosmindolha.particledesigner.events 
{
	/**
	 * ...
	 * @author cosmin dolha
	 */
	import flash.events.Event;
	import flash.geom.Point;
	
	public class MoveParticleEvent extends Event
	{
		
		public var customData:Point;
		public static const ON_PARTICLE_MOVE:String = "onParticleMove";
		
		public function MoveParticleEvent(type:String, customData:Point, bubbles:Boolean = false, cancelable:Boolean = false):void
		{
			this.customData = customData;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event 
		{
			return new MoveParticleEvent(type, customData, bubbles, cancelable);
		}
		
		
	}

}