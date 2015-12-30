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
	public class TexturePicker extends Sprite
	{
		private var dispatcher:DataDispatcher;
		private var resources:Resource;
		private var textureArray:Array;
		
		public function TexturePicker(dd:DataDispatcher, rs:Resource) 
		{
			dispatcher = dd;
			resources = rs;
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			textureArray = new Array();
			textureArray.push("txt1");
			textureArray.push("txt2");
			textureArray.push("txt3");
			textureArray.push("txt4");
			textureArray.push("txt5");
			textureArray.push("txt6");
			textureArray.push("blurb");
			textureArray.push("mathsumrunicon");
			textureArray.push("logo");
			textureArray.push("coin");
			textureArray.push("potion");
			textureArray.push("mathsumrunwriting");
			textureArray.push("f1");
			textureArray.push("f2");
			textureArray.push("f3");
			textureArray.push("f4");
			textureArray.push("f5");
			textureArray.push("f6");
		}
		private function onAdded(e:Event):void
		{
			var bg:Quad = new Quad(stage.stageWidth, stage.stageHeight, 0x000000);
			bg.alpha = 0.7;
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
				
				var textureHolder:TextureHolder = new TextureHolder(dispatcher, resources, i, texture);
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