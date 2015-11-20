package com.cosmindolha.particledesigner.ui 
{
	import com.cosmindolha.particledesigner.DataDispatcher;
	import com.cosmindolha.particledesigner.Resource;
	import com.cosmindolha.particledesigner.events.ChangeBlendEvent;
	import flash.geom.Point;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.*;
	import flash.display3D.Context3DBlendFactor;
		
	/**
	 * ...
	 * @author cosmin dolha
	 */
	public class KnobBlendColorStarling extends Sprite
	{

		private var dispatcher:DataDispatcher;
		private var resources:Resource;
		private var knobSprite:Sprite;
		private var labelField:TextField;

		private var knobValue:Number;
		private var prevVal:Number;
		private var blendValue:int;
		private var prevValue:int;
		private var circlesArray:Array;
		
		
		public function KnobBlendColorStarling(dd:DataDispatcher, rr:Resource) 
		{
			dispatcher = dd;
			resources = rr;
			
			dispatcher.addEventListener(ChangeBlendEvent.SET_BLEND_KNOB, onSetKnob);
			
			var hcolorcircle:Image = new Image(resources.assets.getTexture("blendcircle"));
			
			knobSprite = new Sprite();
			knobSprite.pivotX = hcolorcircle.width / 2;
			knobSprite.pivotY = hcolorcircle.height / 2;
			
			addChild(knobSprite);
			
			knobSprite.addChild(hcolorcircle);
			
			labelField = new TextField(240, 80, "", "fatcow", 25, Color.WHITE, true);
			labelField.hAlign = HAlign.CENTER;
			addChild(labelField);
			
			labelField.y = -45;
			labelField.text = "Blend Functioon";
			labelField.x = -120 ;
			
			addEventListener(TouchEvent.TOUCH, onTouch);
			
			buildCircles();
		}
		private function deselctAllSmallCircles():void
		{
			for (var i:int = 0; i < circlesArray.length; i++) 
			{
				var circle:Image = circlesArray[i];
				circle.alpha = 0.2;	
			}
		}
		private function onSetKnob(e:ChangeBlendEvent):void
		{
			var obj:Object = e.customData;
			
			if (obj != null)
			{
			knobSprite.rotation = obj.rot;
			
			labelField.text = "Blend Function \n" + returnBlendString(obj.blend);
			deselctAllSmallCircles();
			
			for (var i:int = 0; i < circlesArray.length; i++) 
			{
				if (i == Number(obj.blend))
				{
					var circle:Image = circlesArray[i];
					circle.alpha = 1;	
					setRotation(circle);
					break;
				}

			}
			}
		}
		private function setRotation(img:Image):void
		{
			var position:Number = Math.atan2(img.y - knobSprite.y, img.x - knobSprite.x);
			
			knobSprite.rotation = position+1.57;
		}
		private function buildCircles():void
		{
			circlesArray = new Array();
			
			for (var i:int = 0; i < 10; i++) 
			{
				
				var circle:Image = new Image(resources.assets.getTexture("circle"));
				circle.pivotX = circle.width / 2;
				circle.pivotY = circle.height / 2;
				addChild(circle);
				var pos:Point = Point.polar(100, (i / 10) * Math.PI * 2);
				circle.x = pos.x;
				circle.y = pos.y;
				circle.scaleX = 0.5;
				circle.scaleY = 0.5;
				circle.alpha = 0.2;
				circlesArray.push(circle);
			}
			
			
		}
		private function onTouch(e:TouchEvent):void
		{
			var moveTouch:Touch = e.getTouch(stage, TouchPhase.MOVED);
			var downTouch:Touch = e.getTouch(stage, TouchPhase.BEGAN);
			var upTouch:Touch = e.getTouch(stage, TouchPhase.ENDED);
			
			
			if (downTouch != null)
			{
					knobSprite.alpha = 1;
					
			}		
			if (upTouch != null)
			{
					knobSprite.alpha = 0.5;
			}
			if (moveTouch != null)
			{
				var localPos:Point = moveTouch.getLocation(this);
				var position:Number = Math.atan2(localPos.y - knobSprite.y, localPos.x - knobSprite.x);
				var angle:Number=(position/Math.PI) * 180;
				
				knobSprite.rotation = position+1.57;
				
				 angle %=  360;
				 if (angle < 0)
				{
					angle = 360 + angle;
				}
				
				knobValue += (angle > prevVal) ? angle/200 : -angle/200
				
				prevVal = angle;
					
				var obj:Object = new Object();
				obj.val = knobValue;
				obj.rot = position;
				
				smallCircleEffects(position);
			}
			
		}
		private function smallCircleEffects(pos:Number):void
		{
			for (var i:int = 0; i < circlesArray.length; i++) 
			{
				var circle:Image = circlesArray[i];
				circle.alpha = 0.2;	
				var dist:Number =  Math.atan2(circle.y - knobSprite.y, circle.x - knobSprite.x);
				var dif:Number = pos - dist;
				if(dif > -0.3 && dif < 0.3)
				{
					circle.alpha = 1;
					
					sendData(i);
					//break;
				}
				
			}
		}
		private function sendData(id:int):void
		{
			if (prevVal != id)
			{
				blendValue = id;
				prevVal = blendValue;
				
				var obj:Object = new Object();
				
				obj.blend = blendValue;
				obj.rot = knobSprite.rotation;
				
				dispatcher.setBlendColor(obj);
				
				labelField.text = "Blend Function \n" + returnBlendString(id);
			}
			
		}
		private function returnBlendString(value:int):String
		{

		switch (value)
			{
				case 0: 
					return Context3DBlendFactor.ZERO;
					break;
				case 1: 
					return Context3DBlendFactor.ONE;
					break;
				case 2: 
					return Context3DBlendFactor.SOURCE_COLOR;
					break;
				case 3: 
					return Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR;
					break;
				case 4: 
					return Context3DBlendFactor.SOURCE_ALPHA;
					break;
				case 5: 
					return Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA;
					break;
				case 6: 
					return Context3DBlendFactor.DESTINATION_ALPHA;
					break;
				case 7: 
					return Context3DBlendFactor.ONE_MINUS_DESTINATION_ALPHA;
					break;
				case 8: 
					return Context3DBlendFactor.DESTINATION_COLOR;
					break;
				case 9: 
					return Context3DBlendFactor.ONE_MINUS_DESTINATION_COLOR;
					break;
				default: 
					throw new ArgumentError("unsupported blending function: " + value);
			}
		}

	}

}