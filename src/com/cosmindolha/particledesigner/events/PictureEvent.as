package com.cosmindolha.particledesigner.events 
{
	/**
	 * ...
	 * @author cosmin dolha
	 */
	import flash.events.Event;
	
	public class PictureEvent extends Event
	{
		public var customData:Object;
		
		public static const OPEN_PICTURE_GALLERY:String = "openPictureGallery";
		public static const PICTURE_PICKED:String = "picturePicked";
		public function PictureEvent(type:String, customData:Object, bubbles:Boolean = false, cancelable:Boolean = false):void
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