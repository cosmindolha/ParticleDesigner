package com.cosmindolha.particledesigner 
{
	import flash.events.TimerEvent;
	import flash.filesystem.File;

	import starling.events.Event;
	import starling.utils.AssetManager;
	import starling.core.Starling;

	/**
	 * ...
	 * @author ... Cosmin Dolha ~ contact@cosmindolha.com
	 */
	public class Resource 
	{
		public var assets:AssetManager;
		
		private var disp:DataDispatcher;
				
		public function Resource(dd:DataDispatcher) 
		{
			disp = dd;

			assets = new AssetManager();
			
			assets.keepAtlasXmls = true;
	
			var appDir:File = File.applicationDirectory;
			
			assets.enqueue(appDir.resolvePath("assets"));
			
			assets.addEventListener(Event.IO_ERROR, onError)

			assets.loadQueue(function(ratio:Number):void
			{
			if (ratio == 1.0)
			{
				//trace("asstes loaded");
				disp.assetsLoaded();
			}
			});
		}

		private function onError(e:Event):void
		{
				trace(e.data);
		}
		
	}

}