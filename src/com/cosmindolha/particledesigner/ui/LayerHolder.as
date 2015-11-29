package com.cosmindolha.particledesigner.ui 
{
	import com.cosmindolha.particledesigner.DataDispatcher;
	import com.cosmindolha.particledesigner.Resource;
	import flash.geom.Point;
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
		private var isThisSelected:Boolean;
		private var particleVisible:Boolean;
		private var eyeVisibleLayer:Image;

		
		public function LayerHolder(dd:DataDispatcher, rs:Resource, id:int) 
		{
			dispatcher = dd;
			resources = rs;
			layerID = id;
			particleVisible = true;
			sp = new Sprite();
			
			sp.alpha = 0.5;
			
			bgLayerImage = new Image(resources.assets.getTexture("layerbg"));
			sp.addChild(bgLayerImage);		
			
			var bgVisibleLayerImage:Image = new Image(resources.assets.getTexture("layervisible"));
			addChild(bgVisibleLayerImage);		
			
			bgVisibleLayerImage.x = -40;
			
			eyeVisibleLayer = new Image(resources.assets.getTexture("eyesmall"));
			addChild(eyeVisibleLayer);
			eyeVisibleLayer.x = -30;
			eyeVisibleLayer.y = 35;
			
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
			sendObject.particleVisible = particleVisible;
			
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		public function get id():int
		{
			return layerID;
		}
		private function onTouch(e:TouchEvent):void
		{
			
			var downTouch:Touch = e.getTouch(stage, TouchPhase.BEGAN);
			var localPos:Point;
				if (downTouch != null)
				{
					localPos = downTouch.getLocation(this);
					if (localPos.x > 0 )
					{
						sp.alpha = 1;
						if (isThisSelected == false)
						{
							dispatcher.changeLayer(sendObject);	
						}
					}
					if (localPos.x < 0)
					{
						visibilityToggle();
					}
				}		
			
		}
		
		private function visibilityToggle():void
		{
			particleVisible = !particleVisible;
			eyeVisibleLayer.visible = particleVisible;
			sendObject.particleVisible = particleVisible;
			dispatcher.visibilityLayer(sendObject);	
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
			isThisSelected = false;
		}
		public function select():void
		{
			sp.alpha = 1;
			isThisSelected = true;
		}
	}

}