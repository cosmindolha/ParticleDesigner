package com.cosmindolha.particledesigner.events 
{
	/**
	 * ...
	 * @author cosmin dolha
	 */
	import flash.events.Event;
	
	public class SetColorPickerEvent extends Event
	{
		
		public var customData:Object;
		public static const SET_COLOR_PICKER:String = "setcolorpicker";
		
		public function SetColorPickerEvent(type:String, customData:Object, bubbles:Boolean = false, cancelable:Boolean = false):void
		{
			this.customData = customData;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event 
		{
			return new SetColorPickerEvent(type, customData, bubbles, cancelable);
		}
		
		
	}

}