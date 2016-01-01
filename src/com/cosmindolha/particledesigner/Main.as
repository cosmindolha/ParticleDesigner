package com.cosmindolha.particledesigner
{
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import starling.core.Starling;

	
	
		
	/**
	 * ...
	 * @author cosmin dolha
	 */
	public class Main extends Sprite 
	{
		private var starlingPartDesigner:Starling;
		
		public function Main() 
		{
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			//stage.addEventListener(Event.DEACTIVATE, deactivate);
			
			stage.addEventListener(Event.RESIZE, resizeStage);
			// touch or gesture?
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			

			Starling.handleLostContext = true;
				
				
			starlingPartDesigner = new Starling(ParticleScreen, stage);
			starlingPartDesigner.start();
			
			
			starlingPartDesigner.showStatsAt( "left", "bottom", 1);
			
			
		}
		
		protected function resizeStage(event:Event):void
		{
			fit();
		}
		protected function fit():void
		{
	
			var viewPortRectangle:Rectangle = RectangleUtil.fit(
			new Rectangle(0, 0, stage.stageWidth, stage.stageHeight), 
			new Rectangle(0, 0, stage.stageWidth, stage.stageHeight), 
			ScaleMode.SHOW_ALL);
			
			Starling.current.viewPort = viewPortRectangle;
			
			Starling.current.stage.stageWidth = stage.stageWidth;
			Starling.current.stage.stageHeight = stage.stageHeight;
		}
		private function deactivate(e:Event):void 
		{
			// make sure the app behaves well (or exits) when in background
			NativeApplication.nativeApplication.exit();
		}
		
	}
	
}