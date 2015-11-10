package com.cosmindolha.particledesigner.events 
{
	/**
	 * ...
	 * @author cosmin dolha
	 */
	import flash.events.Event;
	
	public class CurrentValEvent extends Event
	{
		
		public var customData:Object;
		public static const UI_VALUE:String = "uivalue";
		
		public function CurrentValEvent(type:String, customData:Object, bubbles:Boolean = false, cancelable:Boolean = false):void
		{
			this.customData = customData;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event 
		{
			return new CurrentValEvent(type, customData, bubbles, cancelable);
		}
		
		
	}

}