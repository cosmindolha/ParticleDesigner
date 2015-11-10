package com.cosmindolha.particledesigner.events 
{
	/**
	 * ...
	 * @author cosmin dolha
	 */
	import flash.events.Event;
	
	public class CurrentButtonEvent extends Event
	{
		
		public var customData:Object;
		public static const SELECTED_BUTTON:String = "selectedbutton";
		
		public function CurrentButtonEvent(type:String, customData:Object, bubbles:Boolean = false, cancelable:Boolean = false):void
		{
			this.customData = customData;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event 
		{
			return new CurrentButtonEvent(type, customData, bubbles, cancelable);
		}
		
		
	}

}