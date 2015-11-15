package com.cosmindolha.particledesigner 
{

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.TimerEvent;
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
	
	import flash.events.Event;
	import flash.geom.Point;

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
		private var setColor:uint;
		private var img:Image;
		private var bmpData:BitmapData;
		private var canvas:Canvas;
		private var colorpointer:Image;
		
		public function ColorPicker(dd:DataDispatcher, rs:Resource) 
		{
			dispatcher = dd;
			resources = rs;
			setColor = 0x000000;
			
			canvas = new Canvas();
			
			colorpointer = new Image(resources.assets.getTexture("colorpointer"));
			spColorPointer = new Sprite();
			
			spColorPointer.addChild(colorpointer);
			
			
			colorpointer.x = -colorpointer.width/2;
			colorpointer.y = -colorpointer.height/2;
			
			colorWheel = new Image(resources.assets.getTexture("colorpicker"));
			var sp:Sprite = new Sprite();
			
			
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
			colorize(setColor);
			addChild(spColorPointer);
			spColorPointer.x = 120;
			spColorPointer.y = 120;
			
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		private function onTouch(e:TouchEvent):void
		{
			var localPos:flash.geom.Point;
			var pixelValue:uint;
			var downTouch:Touch = e.getTouch(stage, TouchPhase.BEGAN);
			if (downTouch != null)
			{
				localPos = downTouch.getLocation(this);
				spColorPointer.x = localPos.x;
				spColorPointer.y = localPos.y;
				pixelValue = bitmapData.getPixel(localPos.x, localPos.y);
				colorize(pixelValue);
			}		
			
			var moveTouch:Touch = e.getTouch(stage, TouchPhase.MOVED);
			if (moveTouch != null)
			{
				localPos = moveTouch.getLocation(this);
				spColorPointer.x = localPos.x;
				spColorPointer.y = localPos.y;
				pixelValue = bitmapData.getPixel(localPos.x, localPos.y);
				colorize(pixelValue);	
				
				
			}
			
		}
		private function colorize(col:uint):void
		{
			canvas.clear();
			canvas.beginFill(col);
			canvas.drawCircle(130, 130, 125);
			canvas.endFill();
			
			var obj:Object = new Object();
			obj.rgb = col;
			obj.x = spColorPointer.x;
			obj.y = spColorPointer.y;
			
			obj.r = (col >> 16) & 0xFF;
			obj.g = (col >> 8) & 0xFF;
			obj.b = col & 0xFF;
			
			dispatcher.setColor(obj);
		}
		private function onLoaded(e:flash.events.Event):void
		{
			bitmapData = Bitmap(LoaderInfo(e.target).content).bitmapData;
		}
	}

}