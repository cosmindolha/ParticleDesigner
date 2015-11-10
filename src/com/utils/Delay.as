package com.utils
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	public class Delay
	{
		private var timer:Timer;	
		private var delayedFunction:Function;
		public function Delay(functionToDelay:Function, delayMilisec:Number)
		{
			this.delayedFunction = functionToDelay;
			timer = new Timer(delayMilisec, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, callDelayedFunction);
			timer.start();
		}	
		private function callDelayedFunction(event:TimerEvent):void
		{
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, callDelayedFunction);
			delayedFunction();
		}
	}
}