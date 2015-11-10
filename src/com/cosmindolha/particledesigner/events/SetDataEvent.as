package com.cosmindolha.particledesigner.events 
{
	/**
	 * ...
	 * @author cosmin dolha
	 */
	import flash.events.Event;
	
	public class SetDataEvent extends Event
	{
		
		public var customData:Array;
		public static const DATA_SET:String = "dataset";
		
		public function SetDataEvent(type:String, customData:Array, bubbles:Boolean = false, cancelable:Boolean = false):void
		{
			this.customData = customData;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event 
		{
			return new SetDataEvent(type, customData, bubbles, cancelable);
		}
		
		
	}

}