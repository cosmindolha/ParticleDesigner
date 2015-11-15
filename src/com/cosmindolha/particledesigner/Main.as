package com.cosmindolha.particledesigner
{
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
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
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.DEACTIVATE, deactivate);
			
			// touch or gesture?
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			Starling.handleLostContext = true;
			
			starlingPartDesigner = new Starling(ParticleScreen, stage);
			starlingPartDesigner.start();
			
			
		//	starlingPartDesigner.showStatsAt( "left", "top",  3);
			
			
			
			// Entry point
			// New to AIR? Please read *carefully* the readme.txt files!
			
			//var uiControlls:UIScreen = new UIScreen();
			
			//addChild(uiControlls);
			
		}
		
		private function deactivate(e:Event):void 
		{
			// make sure the app behaves well (or exits) when in background
			//NativeApplication.nativeApplication.exit();
		}
		
	}
	
}