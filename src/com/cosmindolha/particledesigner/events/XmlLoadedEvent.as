package com.cosmindolha.particledesigner.events 
{
	/**
	 * ...
	 * @author cosmin dolha
	 */
	import flash.events.Event;
		
	public class XmlLoadedEvent extends Event
	{
		public var customData:Object;
		public static const XML_LOADED:String = "xmlLoaded";
	
		
		public function XmlLoadedEvent(type:String, customData:Object, bubbles:Boolean = false, cancelable:Boolean = false):void
		{
			this.customData = customData;
			super(type, bubbles, cancelable);
		}	
		override public function clone():Event 
		{
			return new XmlLoadedEvent(type, customData, bubbles, cancelable);
		}
	}

}