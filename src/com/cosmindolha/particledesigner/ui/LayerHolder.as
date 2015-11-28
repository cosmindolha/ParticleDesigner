package com.cosmindolha.particledesigner.ui 
{
	import com.cosmindolha.particledesigner.DataDispatcher;
	import com.cosmindolha.particledesigner.Resource;
	import starling.display.Canvas;
	import starling.display.Sprite;
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.RenderTexture;
	/**
	 * ...
	 * @author cosmin dolha
	 */
	public class LayerHolder extends Sprite
	{
		private var dispatcher:DataDispatcher;
		private var resources:Resource;
		private var bgLayerImage:Image;
		private var layerID:int;
		private var sp:Sprite;
		private var sendObject:Object;
		private var layerBg:Sprite;

		
		public function LayerHolder(dd:DataDispatcher, rs:Resource, id:int) 
		{
			dispatcher = dd;
			resources = rs;
			layerID = id;
			
			sp = new Sprite();
			
			sp.alpha = 0.5;
			
			bgLayerImage = new Image(resources.assets.getTexture("layerbg"));
			sp.addChild(bgLayerImage);

			addChild(sp);
			
			layerBg = new Sprite();
			addChild(layerBg);
			
			var layerMaskCanvas:Canvas = new Canvas();
			layerMaskCanvas.beginFill(0x000000, 1);
			layerMaskCanvas.drawRectangle(2, 2, 80, 70);
			layerMaskCanvas.endFill();
			
			layerBg.mask = layerMaskCanvas;
			//var particlePreview:Image = new Image();

			sendObject = new Object();
			sendObject.bt = this;
			sendObject.id = id;
			
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		public function get id():int
		{
			return layerID;
		}
		private function onTouch(e:TouchEvent):void
		{
			
			var downTouch:Touch = e.getTouch(stage, TouchPhase.BEGAN);
			var upTouch:Touch = e.getTouch(stage, TouchPhase.ENDED);
			
			if (downTouch != null)
			{
					sp.alpha = 1;
					
			}		
			if (upTouch != null)
			{
					sp.alpha = 0.5;
					dispatcher.changeLayer(sendObject);	
			}
		}
		
		
		public function updatePreview(img:Image):void
		{
			layerBg.removeChildren();
			
			layerBg.addChild(img);
			layerBg.touchable = false;
			img.x = 45;
			img.y = 45;
		}
		public function deselect():void
		
		{
			sp.alpha = 0.5;
		}
		public function select():void
		{
			sp.alpha = 1;
			
		}
	}

}