package com.cosmindolha.particledesigner.events 
{
	/**
	 * ...
	 * @author cosmin dolha
	 */
	import flash.events.Event;
		
	public class ChangeBlendEvent extends Event
	{
		public var customData:Object;
		public static const SET_BLEND_COLOR:String = "setblendcolor";
		public static const SET_BLEND_KNOB:String = "setblendknob";
	
		
		public function ChangeBlendEvent(type:String, customData:Object, bubbles:Boolean = false, cancelable:Boolean = false):void
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