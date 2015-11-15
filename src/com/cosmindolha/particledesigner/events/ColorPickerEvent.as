package com.cosmindolha.particledesigner.events 
{
	/**
	 * ...
	 * @author cosmin dolha
	 */
	import flash.events.Event;
		
	public class ColorPickerEvent extends Event
	{
		public var customData:Object;
		public static const SET_COLOR:String = "setcolor";
	
		
		public function ColorPickerEvent(type:String, customData:Object, bubbles:Boolean = false, cancelable:Boolean = false):void
		{
			this.customData = customData;
			super(type, bubbles, cancelable);
		}	
		override public function clone():Event 
		{
			return new ColorPickerEvent(type, customData, bubbles, cancelable);
		}
	}

}