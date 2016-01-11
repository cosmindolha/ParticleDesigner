package com.cosmindolha.particledesigner.ui 
{
	import com.cosmindolha.particledesigner.DataDispatcher;
	import com.cosmindolha.particledesigner.Resource;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author cosmin dolha
	 */
	public class PicturePicker extends Sprite
	{
		private var dispatcher:DataDispatcher;
		private var resources:Resource;
		private var textureArray:Array;
		
		public function PicturePicker(dd:DataDispatcher, rs:Resource) 
		{
			dispatcher = dd;
			resources = rs;
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			textureArray = new Array();
			textureArray.push("parrot");
			textureArray.push("bomb");
			textureArray.push("pic");
			textureArray.push("angulex");

			
			
		}
		private function onAdded(e:Event):void
		{
			var bg:Quad = new Quad(stage.stageWidth, stage.stageHeight, 0x000000);
			bg.alpha = 0.9;
			addChild(bg);
			
			buildGallery();
		}
		private function buildGallery():void
		{
			
			var spacerX:int = 80;
			var spacerY:int = 80;
			var margin:int = 100;
			
			var toX:int = margin+spacerX;
			var toY:int = 150+spacerY;

			
			for (var i:int = 0; i < textureArray.length; i++) 
			{
				var texture:String = textureArray[i];
				
				var textureHolder:PictureHolder = new PictureHolder(dispatcher, resources, i, texture);
				addChild(textureHolder);
				textureHolder.x = toX;
				textureHolder.y = toY;
				if (toX > stage.stageWidth-margin-spacerX*2)
				{
					toX = margin+spacerX;
					toY += spacerY;
				}else {
					toX += spacerX;	
				}
			}
		}
		
	}

}