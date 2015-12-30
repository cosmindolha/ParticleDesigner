package com.cosmindolha.particledesigner.events 
{
	/**
	 * ...
	 * @author cosmin dolha
	 */
	import flash.events.Event;
	
	public class TextureEvent extends Event
	{
		public var customData:Object;
		
		public static const OPEN_GALLERY:String = "openGallery";
		public static const TEXTURE_PICKED:String = "texturePicked";
		public function TextureEvent(type:String, customData:Object, bubbles:Boolean = false, cancelable:Boolean = false):void
		{
			this.customData = customData;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event 
		{
			return new TextureEvent(type, customData, bubbles, cancelable);
		}
		
		
	}

}