package com.cosmindolha.particledesigner
{
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
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
			stage.addEventListener(Event.DEACTIVATE, deactivate);
			
			stage.addEventListener(Event.RESIZE, resizeStage);
			// touch or gesture?
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			

			Starling.handleLostContext = true;
				
				
			starlingPartDesigner = new Starling(ParticleScreen, stage);
			starlingPartDesigner.start();
			
			
			starlingPartDesigner.showStatsAt( "left", "bottom", 2);
			
			
		}
		
		protected function resizeStage(event:Event):void
		{
			var viewPortRectangle:Rectangle = new Rectangle();
			viewPortRectangle.width = stage.stageWidth;
			viewPortRectangle.height = stage.stageHeight;
			Starling.current.viewPort = viewPortRectangle;
 
		}
		private function deactivate(e:Event):void 
		{
			// make sure the app behaves well (or exits) when in background
			NativeApplication.nativeApplication.exit();
		}
		
	}
	
}