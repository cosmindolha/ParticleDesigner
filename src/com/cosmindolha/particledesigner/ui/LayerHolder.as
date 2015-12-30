package com.cosmindolha.particledesigner.ui 
{
	/**
	 * ...
	 * @author cosmin dolha
	 */
	import com.cosmindolha.particledesigner.DataDispatcher;
	import com.cosmindolha.particledesigner.Resource;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import starling.display.Canvas;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
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
		private var dragTimer:Timer;
		private var movingLayer:Boolean;
		private var prevYpoz:Number;
		private var localYpoz:Number;
		public var locked:Boolean;
		public var pozy:Number;

		
		public function LayerHolder(dd:DataDispatcher, rs:Resource, id:int) 
		{
			dispatcher = dd;
			resources = rs;
			layerID = id;
			particleVisible = true;
			movingLayer = false;
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

			sendObject = new Object();
			sendObject.bt = this;
			sendObject.id = id;
			sendObject.localYpoz = 0;
			sendObject.particleVisible = particleVisible;
			
			addEventListener(TouchEvent.TOUCH, onTouch);
			
			dragTimer = new Timer(800, 1);
			dragTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onDragTimerComplete);
			
		}
		public function onDragTimerComplete(e:TimerEvent):void
		{
			
			
			movingLayer = true;
			this.scaleX = 1.2;
			this.scaleY = 1.2;
			dispatcher.dragLayer(sendObject);
		}
	
		public function get obj():Object
		{
			return sendObject;
		}
		public function get id():int
		{
			return layerID;
		}
		private function onTouch(e:TouchEvent):void
		{
			var localPos:Point;
			var parentThisPos:Point;

							
			var upTouch:Touch = e.getTouch(stage, TouchPhase.ENDED);
			if (upTouch != null)
			{
				dragTimer.reset();
				dragTimer.stop();
				movingLayer = false;
				parentThisPos = upTouch.getLocation(this.parent);
				
				if (prevYpoz != parentThisPos.y)
				{
					
					this.scaleX = 1;
					this.scaleY = 1;
				}
				
			}
			var downTouch:Touch = e.getTouch(stage, TouchPhase.BEGAN);
			
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
									
						localYpoz = downTouch.getLocation(this).y;
						sendObject.localYpoz = localYpoz; 
						dragTimer.start();	
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
			if (movingLayer == false)
			{
			layerBg.removeChildren();
			
			layerBg.addChild(img);
			layerBg.touchable = false;
			img.x = 45;
			img.y = 45;
			}
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