package com.cosmindolha.particledesigner.events 
{
	/**
	 * ...
	 * @author cosmin dolha
	 */
	import flash.events.Event;
	
	public class CurrentMenuButtonEvent extends Event
	{
		
		public var customData:Object;
		public static const SELECTED_MENU_BUTTON:String = "selectedmenubutton";
		
		public function CurrentMenuButtonEvent(type:String, customData:Object, bubbles:Boolean = false, cancelable:Boolean = false):void
		{
			this.customData = customData;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event 
		{
			return new CurrentMenuButtonEvent(type, customData, bubbles, cancelable);
		}
		
		
	}

}