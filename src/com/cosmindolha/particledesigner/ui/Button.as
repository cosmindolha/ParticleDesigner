package com.cosmindolha.particledesigner.ui 
{
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.*;
	import flash.display.BitmapData;
	import starling.textures.Texture;
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import com.cosmindolha.particledesigner.DataDispatcher;
		
	/**
	 * ...
	 * @author cosmin dolha
	 */
	public class Button extends Sprite
	{
		private var labelField:TextField;
		private var margin:int;
		private var sp:Sprite;
		private var dispatcher:DataDispatcher;
		private var sendObject:Object;
		private var id:int;
		public function Button(dd:DataDispatcher, iD:int) 
		{
			dispatcher = dd;
			id = iD;
			sp = new Sprite();
			addChild(sp);
			sp.alpha = .3;
			labelField = new TextField(100, 40, "", "abel", 14, Color.WHITE, true);
			labelField.hAlign = HAlign.LEFT;
			labelField.autoSize = TextFieldAutoSize.HORIZONTAL;
			addChild(labelField);			
			
			addEventListener(Event.ADDED_TO_STAGE, added);
			margin = 5;
			labelField.x = margin;
			labelField.y = 3;
			
			addEventListener(TouchEvent.TOUCH, onTouch);
			
			
		}
		public function deselect():void
		{
			sp.alpha = 0.3;
		}
		public function select():void
		{
			sp.alpha = 1;
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
					sp.alpha = 0.3;
					sendObject = new Object();
					sendObject.bt = this;
					sendObject.id = id;
					dispatcher.buttonClicked(sendObject)
			}
	
		}
		private function added(e:Event):void
		{	
			var img:Image = new Image(buttonBitmap());
			
			
			sp.addChild(img);
		
		}
		public function set text(txt:String):void
		{
			labelField.text = txt;
		}
		private function buttonBitmap():Texture
		{
			var sp:flash.display.Sprite = new flash.display.Sprite();
			sp.graphics.beginFill(0x8081ff, .4);
			sp.graphics.drawRoundRect(0, 0,  60, 45, 5, 5);
			sp.graphics.endFill();
			
			var bmpData:BitmapData = new BitmapData(sp.width, sp.height, true, 0x00000000);
			bmpData.draw(sp); 
			var texture:Texture = Texture.fromBitmapData(bmpData, false, false);
			return texture;
		
		}
	}

}