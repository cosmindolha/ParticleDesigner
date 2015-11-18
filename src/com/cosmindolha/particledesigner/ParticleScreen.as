package com.cosmindolha.particledesigner 
{
	import com.cosmindolha.particledesigner.events.CurrentValEvent;
	import de.flintfabrik.starling.utils.ColorArgb;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import starling.display.Canvas;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;

	import starling.textures.Texture;
	import starling.core.Starling;
	import starling.textures.TextureAtlas;
		
	import de.flintfabrik.starling.display.FFParticleSystem;
	import de.flintfabrik.starling.display.FFParticleSystem.SystemOptions;
	
	import com.cosmindolha.particledesigner.events.CurrentButtonEvent;
	import com.cosmindolha.particledesigner.events.ColorPickerEvent;
	import com.cosmindolha.particledesigner.events.CurrentColorButtonEvent;

		
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
		private var particleDataArray:Array;
		private var colorDataArray:Array;
		private var selecedColorButtonID:int = 0 ;
		private var bgQuad:Quad;
	
		
		
		public function ParticleScreen() 
		{
			
			bgQuad = new Quad(1024, 768, 0x65496a);
			addChild(bgQuad);
			
			particleDataArray = new Array();
			colorDataArray = new Array();
			
			dispatcher = new DataDispatcher();
			
			resources = new Resource(dispatcher);
			
			resources.assets.verbose = false;
			
			dispatcher.addEventListener("ASSETS_LOADED", onAssetsReady);
			dispatcher.addEventListener(CurrentButtonEvent.SELECTED_BUTTON, onButtonPressed);
			dispatcher.addEventListener(CurrentColorButtonEvent.SELECTED_COLOR_BUTTON, onColorButtonPressed);
			

			
			
			dispatcher.addEventListener(ColorPickerEvent.SET_COLOR, onSetColor);
			
		}
		private function onSetColor(e:ColorPickerEvent):void
		{
			
			var rgbObj:Object = e.customData;
			var colorArgb:ColorArgb = new ColorArgb(rgbObj.r, rgbObj.g, rgbObj.b, rgbObj.a);
			
			if (selecedColorButtonID > 0)
			{
			ps[colorDataArray[selecedColorButtonID].props] = colorArgb;
			}else{
				
				bgQuad.setVertexColor(0, rgbObj.color);
				bgQuad.setVertexColor(1, rgbObj.color);
				bgQuad.setVertexColor(2, rgbObj.color);
				bgQuad.setVertexColor(3, rgbObj.color);
				bgQuad.alpha =  rgbObj.a;
			}

		}
		
		private function onColorButtonPressed(e:CurrentColorButtonEvent):void
		{
			selecedColorButtonID = e.customData.id;
			
			
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
			
			
			//var bg:Image = new Image(resources.assets.getTexture("bg"));
			//addChild(bg);
			
			
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
			
			
			setInitData();
			
			
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
		private function setInitData():void
		{
			
			colorDataArray = new Array();
			colorDataArray.push( { label:"BG Color", props:"none", r:0, b:0, g:0, a:0, rot:0, x:0, y:0 } );
			
			colorDataArray.push({label:"Start Color", props:"startColor", r:0,b:0,g:0,a:0,rot:0, x:0, y:0});
			colorDataArray.push( { label:"Start Color  \n" + "Variance", props:"startColorVariance", r:0,b:0,g:0,a:0,rot:0, val:0, x:0, y:0 } );		
			
			colorDataArray.push({label:"End Color", props:"startColor", r:0,b:0,g:0,a:0,rot:0, x:0, y:0});
			colorDataArray.push({label:"End Color  \n"+"Variance", props:"startColorVariance", r:0,b:0,g:0,a:0,rot:0, x:0, y:0});
			
			
			particleDataArray = new Array();
			
			particleDataArray.push({label:"Max \n"+"Particles", props:"maxNumParticles", val:0, rot:0});
			particleDataArray.push({label:"Lifespan", props:"lifespan", val:0, rot:0});
			particleDataArray.push({label:"Lifespan \n" + "Var", props:"lifespanVariance", val:0, rot:0});
			particleDataArray.push({label:"Start \nSize", props:"startSize", val:0, rot:0});
			particleDataArray.push({label:"Start Size \n" + "Var", props:"startSizeVariance", val:0, rot:0});
			particleDataArray.push({label:"Finish \nSize", props:"endSize", val:0, rot:0});
			particleDataArray.push({label:"Finish \nSize Var", props:"endSizeVariance", val:0, rot:0});
			particleDataArray.push({label:"Emiter \nAngle", props:"emitAngle", val:0, rot:0});
			particleDataArray.push({label:"Emiter \nAngle Var", props:"emitAngleVariance", val:0, rot:0});
			particleDataArray.push({label:"Rot Start", props:"startRotation", val:0, rot:0});
			particleDataArray.push({label:"Rot Start \n" + "Var", props:"startRotationVariance", val:0, rot:0});
			particleDataArray.push({label:"Rot End", props:"endRotation", val:0, rot:0});
			particleDataArray.push({label:"Rot End \n" + "Var", props:"endRotationVariance", val:0, rot:0});
			particleDataArray.push({label:"X Var", props:"emitterXVariance", val:0, rot:0});
			particleDataArray.push({label:"Y Var", props:"emitterYVariance", val:0, rot:0});
			particleDataArray.push({label:"Speed", props:"speed", val:0, rot:0});
			particleDataArray.push({label:"Speed Var", props:"speedVariance", val:0, rot:0});
			particleDataArray.push({label:"Gravity X", props:"gravityX", val:0, rot:0});
			particleDataArray.push({label:"Gravity Y", props:"gravityY", val:0, rot:0});
			particleDataArray.push({label:"Rad. Acc.", props:"radialAcceleration", val:0, rot:0});
			particleDataArray.push({label:"Rad. Acc. \n" + "Variance", props:"radialAccelerationVariance", val:0, rot:0});
			particleDataArray.push({label:"Tan. Acc.", props:"tangentialAcceleration", val:0, rot:0});
			particleDataArray.push({label:"Tan. Acc. \n" + "Variance", props:"tangentialAccelerationVariance", val:0, rot:0});
			

			var i:int = 0;
			
			for (i = 0; i < particleDataArray.length; i++)
			{
				particleDataArray[i].val = ps[particleDataArray[i].props];				
			}
			
			for (i = 0; i < colorDataArray.length; i++)
			{
				colorDataArray[i].x = 120;				
				colorDataArray[i].y = 120;				
				colorDataArray[i].a = 1;				
			}
			
			var objectDataHolder:Object = new Object();
			objectDataHolder.particleDataArray = particleDataArray;
			objectDataHolder.colorDataArray = colorDataArray;
			
			
			
			dispatcher.setData(objectDataHolder);
		}
		private function setParam():void
		{
			
			ps[particleDataArray[selectedProp].props] = uiValue;
		}
	}

}