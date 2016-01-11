package com.cosmindolha.particledesigner.ui 
{
	import com.cosmindolha.particledesigner.Resource;
	import flash.geom.Rectangle;
	import com.cosmindolha.particledesigner.DataDispatcher;
	import com.cosmindolha.particledesigner.events.SetKnobEvent;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import flash.events.Event;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import starling.textures.Texture;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.*;
	import starling.text.TextField;
//	import starling.text.TextFormat;
		
	/**
	 * ...
	 * @author cosmin dolha
	 */
	public class KnobButtonStarling extends starling.display.Sprite
	{

		private var dispatcher:DataDispatcher;
		private var resources:Resource;
		private var knobSprite:starling.display.Sprite;
		private var labelField:TextField;
		private var numberField:TextField;
		private var knobValue:Number;
		private var prevVal:Number;
		private var paramID:int;
		private var multiplier:Number;
		
		
		public function KnobButtonStarling(dd:DataDispatcher, rr:Resource) 
		{
			dispatcher = dd;
			resources = rr;
			dispatcher.addEventListener(SetKnobEvent.SET_KNOB, onSetKnob);
			
			var hcolorcircle:Image = new Image(resources.assets.getTexture("holecolorcircle"));
			hcolorcircle.x = -100;
			hcolorcircle.y = -100;
			addChild(hcolorcircle);
			hcolorcircle.alpha = 0.5;
			var img:Image = new Image(knobGraphics());
			
			knobValue = 0;
			
			
			knobSprite = new starling.display.Sprite();
			knobSprite.addChild(img);
			img.x = -120
			img.y = -120;
			
			addChild(knobSprite);
			
			
			
			knobSprite.alpha = 0.5;
			
			
			//numberField = new TextField(180, 80, "", "fatcow", 60, Color.WHITE, true);
			numberField = new TextField(180, 80, "", "fatcow", 60, Color.WHITE, true);
			numberField.hAlign = HAlign.CENTER;
			
			//starling 2
		//	var format:TextFormat = new TextFormat("fatcow", 60, Color.WHITE, "left");
			
		//	numberField = new TextField(100, 80, "", format);
				//starling 2
			
			//
			addChild(numberField);
			
			numberField.y = -10;
			numberField.text = "000";
			numberField.x = -90 ;	
			
			addChild(numberField);
			
			
			labelField = new TextField(240, 80, "", "fatcow", 30, Color.WHITE, true);
			labelField.hAlign = HAlign.CENTER;
			
			
			//starling 2
			//var format2:TextFormat = new TextFormat("fatcow", 30, Color.WHITE, "left");
			
			//labelField = new TextField(240, 80, "", format2);
				//starling 2
			
			//
			
			addChild(labelField);
			
			labelField.y = -80;
			labelField.text = "Particles";
			labelField.x = -120 ;
			
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		private function onSetKnob(e:SetKnobEvent):void
		{
			var obj:Object = e.customData;			
			//trace("knob values ", obj.val);
			//trace(obj.m)
			multiplier = obj.m;
			
			if (obj != null)
			{
				knobValue =  (obj.val != null) ? obj.val : 0;
				knobSprite.rotation =  (obj.rot != null) ? obj.rot : 0;
				numberField.text = String(knobValue);
				labelField.text = obj.label;
				//paramID = obj.id;
			}else{
				
				knobSprite.rotation = 0;
				numberField.text = "0";
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
				var localPos:flash.geom.Point = moveTouch.getLocation(this);
				var position:Number = Math.atan2(localPos.y - knobSprite.y, localPos.x - knobSprite.x);
				var angle:Number=(position/Math.PI) * 180;
				
				knobSprite.rotation = position;
				
				 angle %=  360;
				 if (angle < 0)
				{
					angle = 360 + angle;
				}
				
				knobValue += (angle > prevVal) ? (angle/200)*multiplier : (-angle/200)*multiplier
				
				prevVal = angle;
				
				numberField.text = String(knobValue);
				
				var obj:Object = new Object();
				obj.val = knobValue;
				obj.rot = position;
				
				dispatcher.setValue(obj);
				
			}
			
		}
		private function percentage( X:Number, minValue:Number, maxValue:Number ):Number
		{
			return (X - minValue)/(maxValue - minValue) * 100;
		}
		private function knobGraphics():Texture
		{
			var sp:flash.display.Sprite = new flash.display.Sprite();
			
			
			sp.graphics.beginFill(0x8081ff, .4);
			sp.graphics.drawCircle(120, 120, 120);
			sp.graphics.drawCircle(120, 120, 100);
			sp.graphics.endFill();
			
			sp.graphics.beginFill(0x8081ff, .8);
			sp.graphics.drawCircle(230, 120, 10);
			sp.graphics.endFill();	
			
			sp.graphics.beginFill(0x8081ff, .2);
			sp.graphics.drawCircle(230, 120, 50);
			sp.graphics.endFill();
			
			
			var bmpData:BitmapData = new BitmapData(sp.width, sp.height, true, 0x00000000);
			bmpData.draw(sp); 
			
			var knobTexture:Texture = Texture.fromBitmapData(bmpData, false, false);
			
			return knobTexture;
			
		}

	}

}