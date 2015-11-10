package com.cosmindolha.particledesigner.events 
{
	/**
	 * ...
	 * @author cosmin dolha
	 */
	import flash.events.Event;
	
	public class SetKnobEvent extends Event
	{
		
		public var customData:Object;
		public static const SET_KNOB:String = "setknob";
		
		public function SetKnobEvent(type:String, customData:Object, bubbles:Boolean = false, cancelable:Boolean = false):void
		{
			this.customData = customData;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event 
		{
			return new SetKnobEvent(type, customData, bubbles, cancelable);
		}
		
		
	}

}