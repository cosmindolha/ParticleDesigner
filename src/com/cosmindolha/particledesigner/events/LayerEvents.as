package com.cosmindolha.particledesigner.events 
{
	/**
	 * ...
	 * @author cosmin dolha
	 */
	import flash.events.Event;
	
	public class LayerEvents extends Event
	{
		
		public var customData:Object;
		public static const NEW_LAYER:String = "newLayer";
		public static const REMOVE_LAYER:String = "removeLayer";
		public static const CHANGE_LAYER:String = "changeLayer";
		
		public function LayerEvents(type:String, customData:Object, bubbles:Boolean = false, cancelable:Boolean = false):void
		{
			this.customData = customData;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event 
		{
			return new LayerEvents(type, customData, bubbles, cancelable);
		}
		
		
	}

}