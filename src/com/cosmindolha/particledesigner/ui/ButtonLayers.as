package com.cosmindolha.particledesigner.ui 
{
	import starling.display.Sprite;
	import starling.events.Event;

	import starling.utils.*;
	import flash.display.BitmapData;
	import starling.textures.Texture;
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import com.cosmindolha.particledesigner.DataDispatcher;
	
	
	
	/**
	 * ...
	 * @author cosmin dolha
	 */
	public class ButtonLayers extends Sprite
	{

		private var margin:int;
		private var sp:Sprite;
		private var dispatcher:DataDispatcher;
		private var sendObject:Object;
		private var id:int;
		public function ButtonLayers(dd:DataDispatcher, iD:int) 
		{
			dispatcher = dd;
			id = iD;
			sp = new Sprite();
			addChild(sp);
			sp.alpha = .3;
			
			addEventListener(TouchEvent.TOUCH, onTouch);
			
			var img:Image = new Image(buttonBitmap());
			
			
			sp.addChild(img);
			
		}
		public function deselect():void
		{
			sp.alpha = 0.3;
		}
		public function select():void
		{
			sp.alpha = 1;
		}
		private function onTouch(e:TouchEvent):void
		{
			
			var downTouch:Touch = e.getTouch(stage, TouchPhase.BEGAN);
			var upTouch:Touch = e.getTouch(stage, TouchPhase.ENDED);
			
			if (downTouch != null)
			{
					sp.alpha = 1;
					dispatchEvent(new Event("buttonLayerClicked"));
			}		
			if (upTouch != null)
			{
					sp.alpha = 0.3;
			}
	
		}


		private function buttonBitmap():Texture
		{
			var sp:flash.display.Sprite = new flash.display.Sprite();
			sp.graphics.beginFill(0x000000, .8);
			sp.graphics.drawRect(0, 0,  40, 40);
			sp.graphics.endFill();
			
			var bmpData:BitmapData = new BitmapData(sp.width, sp.height, true, 0x00000000);
			bmpData.draw(sp); 
			var texture:Texture = Texture.fromBitmapData(bmpData, false, false);
			return texture;
		
		}
	}

}