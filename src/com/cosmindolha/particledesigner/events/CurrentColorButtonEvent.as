package com.cosmindolha.particledesigner.events 
{
	/**
	 * ...
	 * @author cosmin dolha
	 */
	import flash.events.Event;
	
	public class CurrentColorButtonEvent extends Event
	{
		
		public var customData:Object;
		public static const SELECTED_COLOR_BUTTON:String = "selectedcolorbutton";
		
		public function CurrentColorButtonEvent(type:String, customData:Object, bubbles:Boolean = false, cancelable:Boolean = false):void
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