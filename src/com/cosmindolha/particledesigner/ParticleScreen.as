package com.cosmindolha.particledesigner 
{
	import com.cosmindolha.particledesigner.events.CurrentValEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import starling.display.Sprite;
	import starling.events.Event;

	import starling.textures.Texture;
	import starling.core.Starling;
	import starling.textures.TextureAtlas;
		
	import de.flintfabrik.starling.display.FFParticleSystem;
	import de.flintfabrik.starling.display.FFParticleSystem.SystemOptions;
	
	import com.cosmindolha.particledesigner.events.CurrentButtonEvent;

		
	/**
	 * ...
	 * @author cosmin dolha
	 */
	public class ParticleScreen extends Sprite
	{
		private var resources:Resource;
		private var dispatcher:DataDispatcher;
		
		//particle settings
		private var layerArray:Array;
		private var propsArray:Array;
		//current UI value
		private var uiValue:Number=0; 
		private var prevValue:Number=0; 

		private var delaySetValueTimer:Timer;
		private var ps:FFParticleSystem;
		private var selectedProp:int;
		private var sysOpt:SystemOptions;
		private var propsNameArray:Array;
		private var particleDataArray:Array;
		
		
		public function ParticleScreen() 
		{
			
			dispatcher = new DataDispatcher();
			
			resources = new Resource(dispatcher);
			
			resources.assets.verbose = false;
			
			dispatcher.addEventListener("ASSETS_LOADED", onAssetsReady);
			dispatcher.addEventListener(CurrentButtonEvent.SELECTED_BUTTON, onButtonPressed);
			
			particleDataArray = new Array();
			
			
		}
		private function onButtonPressed(e:CurrentButtonEvent):void
		{
			var obj:Object = e.customData;
			
			selectedProp = obj.id;
			
		}
		private function onAssetsReady(e:String):void
		{
			init();
		}
		private function init():void
		{
			
			
			var bubbleConfig:XML =  new XML(resources.assets.getXml("story"));
			var bubbleTexture:Texture = resources.assets.getTexture("blurb");
			
			sysOpt = SystemOptions.fromXML(bubbleConfig, bubbleTexture);
			
			FFParticleSystem.init(1024, false, 512, 4);
			ps = new FFParticleSystem(sysOpt);
			ps.x = 160;
			ps.y = 100;
			addChild(ps);
			
			ps.start();
			
			
			var ui:UIStarlingScreen = new UIStarlingScreen(resources, dispatcher);
			addChild(ui);
			
			
			dispatcher.addEventListener(CurrentValEvent.UI_VALUE, setVal);

			
			delaySetValueTimer = new Timer(200, 1);
			delaySetValueTimer.addEventListener(TimerEvent.TIMER_COMPLETE, setValueTimer);
			delaySetValueTimer.start();
			
			
			setPropsNames();
			
		}
		
		private function setValueTimer(e:TimerEvent):void
		{
			if (uiValue != prevValue)
			{
				 setParam();
			}
			prevValue = uiValue;
			delaySetValueTimer.start();
		}

		private function setVal(e:CurrentValEvent):void
		{
			var obj:Object = e.customData;
			uiValue = obj.val;
			
		}
		private function setPropsNames():void
		{
			propsNameArray = new Array();
			
			propsNameArray.push("maxNumParticles");
			propsNameArray.push("lifespan");
			propsNameArray.push("lifespanVariance");
			propsNameArray.push("startSize");
			propsNameArray.push("startSizeVariance");
			propsNameArray.push("endSize");
			propsNameArray.push("endSizeVariance");
			propsNameArray.push("emitAngle");
			propsNameArray.push("emitAngleVariance");
			propsNameArray.push("startRotation");
			propsNameArray.push("startRotationVariance");
			propsNameArray.push("endRotation");
			propsNameArray.push("endRotationVariance");
			//
			propsNameArray.push("emitterXVariance");
			propsNameArray.push("emitterYVariance");
			propsNameArray.push("speed");
			propsNameArray.push("speedVariance");
			propsNameArray.push("gravityX");
			propsNameArray.push("gravityY");
			
			propsNameArray.push("radialAcceleration");
			propsNameArray.push("radialAccelerationVariance");
			propsNameArray.push("tangentialAcceleration");
			propsNameArray.push("tangentialAccelerationVariance");
			
			
			for (var i:int = 0; i < propsNameArray.length; i++)
			{
				var obj:Object = new Object();
				
				obj.val = ps[propsNameArray[i]];
				obj.rot = 0;
				particleDataArray[i] = obj;
			}
			dispatcher.setData(particleDataArray);
			
		}
		private function setParam():void
		{
			ps[propsNameArray[selectedProp]] = uiValue;
		}
	}

}