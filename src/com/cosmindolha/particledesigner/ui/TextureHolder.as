package com.cosmindolha.particledesigner.ui 
{
	/**
	 * ...
	 * @author cosmin dolha
	 */
	import starling.display.Sprite;
	import flash.display.BitmapData;
	import com.cosmindolha.particledesigner.DataDispatcher;
	import com.cosmindolha.particledesigner.Resource;
	import starling.display.Sprite;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class TextureHolder extends Sprite
	{
		private var dispatcher:DataDispatcher;
		private var resources:Resource;
		private var layerID:int;
		private var texture:String;
		private var sendObject:Object;
		private var bgImage:Image;
		
		public function TextureHolder(dd:DataDispatcher, rs:Resource, id:int, tx:String) 
		{
			
			dispatcher = dd;
			resources = rs;
			layerID = id;
			texture = tx;
			
			sendObject = new Object();
			
			sendObject.layerID = id;
			sendObject.texture = tx;
			
			
			bgImage = new Image(buttonBitmap());
			var textureImage:Image = new Image(resources.assets.getTexture(tx));
			
			textureImage.pivotX = textureImage.width / 2;
			textureImage.pivotY = textureImage.height / 2;
			
			bgImage.pivotX = bgImage.width / 2;
			bgImage.pivotY = bgImage.height / 2;
			bgImage.alpha = 0.2;
			
			if (textureImage.width > textureImage.height)
			{
			textureImage.width = 50;
			textureImage.scaleY = textureImage.scaleX;
			}else {
				 textureImage.height = 50;
				 textureImage.scaleX = textureImage.scaleY;
			}
			
			addChild(bgImage);
			addChild(textureImage);
			addEventListener(TouchEvent.TOUCH, onTouch);
			
			
		}
		private function onTouch(e:TouchEvent):void
		{
			var upTouch:Touch = e.getTouch(stage, TouchPhase.ENDED);
			if (upTouch != null)
			{
				bgImage.alpha = .2;
				
				dispatcher.texturePicked(sendObject);
			}
			var downTouch:Touch = e.getTouch(stage, TouchPhase.BEGAN);
			
			if (downTouch != null)
			{
				bgImage.alpha = 1;
			}
		}
		
		private function buttonBitmap():Texture
		{
			var sp:flash.display.Sprite = new flash.display.Sprite();
			sp.graphics.beginFill(0x8081ff, .8);
			sp.graphics.drawRoundRect(0, 0,  70, 70, 5, 5);
			sp.graphics.endFill();
			
			var bmpData:BitmapData = new BitmapData(sp.width, sp.height, true, 0x00000000);
			bmpData.draw(sp); 
			sp.graphics.clear();
			sp = null;
			var texture:Texture = Texture.fromBitmapData(bmpData, false, false);
			return texture;
		
		}
	}

}