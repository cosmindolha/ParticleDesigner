package com.cosmindolha.particledesigner.events 
{
	/**
	 * ...
	 * @author cosmin dolha
	 */
	import flash.events.Event;
		
	public class UpdateLayerPreviewEvent extends Event
	{
		public var customData:Object;
		public static const UPDATE_LAYER_PREVIEW:String = "updatelayerpreview";

	
		
		public function UpdateLayerPreviewEvent(type:String, customData:Object, bubbles:Boolean = false, cancelable:Boolean = false):void
		{
			this.customData = customData;
			super(type, bubbles, cancelable);
		}	
		override public function clone():Event 
		{
			return new UpdateLayerPreviewEvent(type, customData, bubbles, cancelable);
		}
	}

}