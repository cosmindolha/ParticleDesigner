package com.cosmindolha.particledesigner.ui 
{

	import com.cosmindolha.particledesigner.DataDispatcher;
	import com.cosmindolha.particledesigner.Resource;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.display.LoaderInfo;
	import flash.utils.Timer;
	import starling.display.Canvas;

	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.utils.deg2rad;;
	
	import flash.events.Event;
	import flash.geom.Point;
		
	import com.cosmindolha.particledesigner.events.SetColorPickerEvent;
	/**
	 * ...
	 * @author cosmin dolha
	 */
	public class ColorPicker extends Sprite
	{
		private var dispatcher:DataDispatcher;
		private var resources:Resource;
		private var colorWheel:Image;
		
		private var bitmapData:BitmapData;
		private var loader:Loader;
		private var colorPreview:starling.display.Sprite;
		private var spColorPointer:starling.display.Sprite;
		private var spc:flash.display.Sprite;
		private var setColorTimer:Timer;
		private var isMoving:Boolean;
		
		private var img:Image;
		private var bmpData:BitmapData;
		private var canvas:Canvas;
		private var colorpointer:Image;
		private var sp:Sprite;
		private var bounds1:Rectangle;
		private var bounds2:Rectangle;
		private var opacitySprite:Sprite;
		
		private var setColorValue:uint = 0x65496a;
		private var colorAlpha:Number = 1;
		private var enableColor:Boolean;
		
		public function ColorPicker(dd:DataDispatcher, rs:Resource) 
		{
			dispatcher = dd;
			resources = rs;

			
			var opacityImage:Image = new Image(resources.assets.getTexture("opacitycircle"));
			var smallCircle:Image = new Image(resources.assets.getTexture("smallcircle"));
			addChild(smallCircle);
			smallCircle.x = 95;
			smallCircle.y = -59;
			
			opacitySprite = new Sprite();
			opacitySprite.rotation = 0;
			opacitySprite.addChild(opacityImage);
			addChild(opacitySprite);

			opacitySprite.pivotX = opacityImage.width / 2;
			opacitySprite.pivotY = opacityImage.height / 2;
			
			opacitySprite.x = 120;		
			
			opacitySprite.y = 120;
			
			canvas = new Canvas();
			
			colorpointer = new Image(resources.assets.getTexture("colorpointer"));
			spColorPointer = new Sprite();
			
			spColorPointer.addChild(colorpointer);
			
			
			colorpointer.x = -colorpointer.width/2;
			colorpointer.y = -colorpointer.height/2;
			
			colorWheel = new Image(resources.assets.getTexture("colorpicker"));
			sp = new Sprite();
			
			
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, onLoaded);
			loader.load(new URLRequest("../assets/colorpicker.png"));
			
			colorPreview = new Sprite();
			colorPreview.addChild(canvas);
			addChild(colorPreview);
			colorPreview.x = - 10;
			colorPreview.y = - 10;
			sp.addChild(colorWheel);
			addChild(sp);
			
			addChild(spColorPointer);
			spColorPointer.x = 120;
			spColorPointer.y = 120;
			
	
			addEventListener(TouchEvent.TOUCH, onTouch);
			
			dispatcher.addEventListener(SetColorPickerEvent.SET_COLOR_PICKER, onSetColorPicker);
			
			setInitColor();
		}
		private function setInitColor():void
		{
			canvas.clear();
			canvas.beginFill(setColorValue);
			canvas.drawCircle(130, 130, 125);
			canvas.endFill();
			
			canvas.alpha = colorAlpha;
		}
		private function onSetColorPicker(e:SetColorPickerEvent):void
		{
			var obj:Object = e.customData;
			
			spColorPointer.x = obj.x;
			spColorPointer.y = obj.y;
			setColorValue = obj.color;
			colorAlpha = obj.a;
			opacitySprite.rotation = obj.rot;
			
			setInitColor();
		}
		private function onTouch(e:TouchEvent):void
		{
			var localPos:flash.geom.Point;
			var pixelValue:uint;
			var mouseOver:Boolean;
			var distance:Number;
			var initialTouch:Number;
			
			
			var centerPoint:Point = new Point(120, 120);	
			
			var touchEnd:Touch = e.getTouch(stage, TouchPhase.ENDED);
			if (touchEnd != null)
			{
				enableColor = false;
			}
			
			
			var downTouch:Touch = e.getTouch(stage, TouchPhase.BEGAN);
			if (downTouch != null)
			{
				//disable overlaping controlls when finger moves to opacity controll and vice versa
				
				initialTouch = Point.distance(centerPoint, downTouch.getLocation(this) );
				if (initialTouch < 120)
				{
					enableColor = true;
				}
			}
			

			var moveTouch:Touch = e.getTouch(stage, TouchPhase.MOVED);
			if (downTouch != null || moveTouch != null)
			{
				localPos = (downTouch != null) ? downTouch.getLocation(this) : moveTouch.getLocation(this);
				distance = Point.distance(centerPoint, localPos);	
				
				if (distance < 120 && enableColor == true)
				{
					
					doColor();
				}
				if (distance > 120 && distance < 250 && enableColor == false)
				{
					doOpacity();
				}
			}		
			
	
			function doColor():void
			{
					
				
					spColorPointer.x = localPos.x;
					spColorPointer.y = localPos.y;
					setColorValue = bitmapData.getPixel(localPos.x, localPos.y);
					colorize();
					
			}
			function doOpacity():void
			{
				var position:Number = Math.atan2( localPos.y-opacitySprite.y, localPos.x-opacitySprite.x);
				var angle:Number = ((position + 1.57) / Math.PI) * 180;
				angle %=  360;
				
				if (angle < 0)
				{
					angle = 360 + angle;
				}
				
				colorAlpha = (angle / 360);
				opacitySprite.rotation = position + 1.57;
				
				colorize();
			}
		}
		private function colorize():void
		{
			//trace(setColorValue)
			canvas.clear();
			canvas.beginFill(setColorValue);
			canvas.drawCircle(130, 130, 125);
			canvas.endFill();
			
			canvas.alpha = colorAlpha;
			
			var obj:Object = new Object();
			obj.color = setColorValue;
			obj.rot = opacitySprite.rotation;
			obj.x = spColorPointer.x;
			obj.y = spColorPointer.y;
			
			obj.r = (setColorValue >> 16) & 0xFF;
			obj.g = (setColorValue >> 8) & 0xFF;
			obj.b = setColorValue & 0xFF;
			obj.a = colorAlpha;
			dispatcher.setColor(obj);
		}
		private function onLoaded(e:flash.events.Event):void
		{
			bitmapData = Bitmap(LoaderInfo(e.target).content).bitmapData;
		}
	}

}