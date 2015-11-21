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
	import com.cosmindolha.particledesigner.events.ChangeBlendEvent;
	import com.cosmindolha.particledesigner.events.CurrentMenuButtonEvent;
	import flash.display3D.Context3DBlendFactor;
		
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
		private var blendValues:Array;
	
		
		
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
			
			dispatcher.addEventListener(ChangeBlendEvent.SET_BLEND_COLOR, onBlendColorChange);			
			
			dispatcher.addEventListener(ColorPickerEvent.SET_COLOR, onSetColor);
			
			dispatcher.addEventListener(CurrentMenuButtonEvent.SELECTED_MENU_BUTTON, onRightMenuClicked);
			
		}
		//fires when you chnage the blend color knob
		private function onRightMenuClicked(e:CurrentMenuButtonEvent):void
		{
			var obj:Object = e.customData;
			
			var id:int = obj.id;
			
			switch(id)
			{
			case 1:
				ps.emitterType = 0;
				break;
			case 2:
				ps.emitterType = 1;
				break;
			}	
		}
		private function onBlendColorChange(e:ChangeBlendEvent):void
		{
			var obj:Object = e.customData;
			var id:int = obj.blend;
			
			
			if (selecedColorButtonID == 5 || selecedColorButtonID == 6)
			{
				ps[colorDataArray[selecedColorButtonID].props] = returnBlendString(blendValues[id]);
			}
			
		}
		
		//given string input (Context3DBlendFactor.ZERO), returns in id with blend modes
		
		private function returnBlendInteger(str:String):int
		{
		
		switch (str)
			{
				
				case Context3DBlendFactor.ZERO:
					return 0;
					break;
				case Context3DBlendFactor.ONE: 
					return 1;
					break;
				case Context3DBlendFactor.SOURCE_COLOR: 
					return 2;
					break;
				case Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR: 
					return 3;
					break;
				case Context3DBlendFactor.SOURCE_ALPHA: 
					return 4;
					break;
				case Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA: 
					return 5;
					break;
				case Context3DBlendFactor.DESTINATION_ALPHA: 
					return 6;
					break;
				case Context3DBlendFactor.ONE_MINUS_DESTINATION_ALPHA: 
					return 7;
					break;
				case Context3DBlendFactor.DESTINATION_COLOR: 
					return 8;
					break;
				case Context3DBlendFactor.ONE_MINUS_DESTINATION_COLOR: 
					return 9;
					break;
				default: 
					throw new ArgumentError("unsupported blending function: " + str);
			}
		}
		
		//given dec input (771), returns string with blend modes
		private function returnBlendString(element:String):String
		{
		var value:int = Number(element);
		switch (value)
			{
				case 0: 
					return Context3DBlendFactor.ZERO;
					break;
				case 1: 
					return Context3DBlendFactor.ONE;
					break;
				case 0x300: 
					return Context3DBlendFactor.SOURCE_COLOR;
					break;
				case 0x301: 
					return Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR;
					break;
				case 0x302: 
					return Context3DBlendFactor.SOURCE_ALPHA;
					break;
				case 0x303: 
					return Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA;
					break;
				case 0x304: 
					return Context3DBlendFactor.DESTINATION_ALPHA;
					break;
				case 0x305: 
					return Context3DBlendFactor.ONE_MINUS_DESTINATION_ALPHA;
					break;
				case 0x306: 
					return Context3DBlendFactor.DESTINATION_COLOR;
					break;
				case 0x307: 
					return Context3DBlendFactor.ONE_MINUS_DESTINATION_COLOR;
					break;
				default: 
					throw new ArgumentError("unsupported blending function: " + value);
			}
		}
		private function onSetColor(e:ColorPickerEvent):void
		{
			
			var rgbObj:Object = e.customData;
			var colorArgb:ColorArgb = new ColorArgb(rgbObj.r, rgbObj.g, rgbObj.b, rgbObj.a);
			
			if (selecedColorButtonID > 0 && selecedColorButtonID < 4)
			{
				ps[colorDataArray[selecedColorButtonID].props] = colorArgb;
			}
			
			if(selecedColorButtonID == 0){
				
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
			ps.emitterX = stage.stageWidth/2;
			ps.emitterY =stage.stageHeight/2;
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
			//blendValues = new Array();
		
			blendValues = new Array("0", "1", "768", "769", "770", "771", "772", "773", "774", "775");
			
			colorDataArray = new Array();
			colorDataArray.push( { label:"BG Color", props:"none", r:0, b:0, g:0, a:0, rot:0, x:0, y:0 } );
			
			colorDataArray.push({label:"Start Color", props:"startColor", r:0,b:0,g:0,a:0,rot:0, x:0, y:0});
			colorDataArray.push( { label:"Start Color  \n" + "Variance", props:"startColorVariance", r:0,b:0,g:0,a:0,rot:0, val:0, x:0, y:0 } );		
			
			colorDataArray.push({label:"End Color", props:"startColor", r:0,b:0,g:0,a:0,rot:0, x:0, y:0});
			colorDataArray.push( { label:"End Color  \n" + "Variance", props:"startColorVariance", r:0, b:0, g:0, a:0, rot:0, x:0, y:0 } );
			
			colorDataArray.push({label:"Blending \n"+"Source", props:"blendFuncSource", blend:0, rot:0, id:0});
			colorDataArray.push({label:"Blending \n"+"Destination", props:"blendFuncDestination", blend:0, rot:0, id:0});
			
			
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
			particleDataArray.push( { label:"Rot End \n" + "Var", props:"endRotationVariance", val:0, rot:0 } );
			//emitter gravity
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
			//emitter radial
			particleDataArray.push({label:"Max. Rad", props:"maxRadius", val:0, rot:0});
			particleDataArray.push({label:"Max. Rad\nVariance", props:"maxRadiusVariance", val:0, rot:0});
			particleDataArray.push({label:"Min. Rad", props:"minRadius", val:0, rot:0});
			particleDataArray.push({label:"Min. Rad\nVariance", props:"minRadiusVariance", val:0, rot:0});
			particleDataArray.push({label:"Rot/Sec", props:"rotatePerSecond", val:0, rot:0});
			particleDataArray.push({label:"Rot/Sec\nVariance", props:"rotatePerSecondVariance", val:0, rot:0});
	
			

			var i:int = 0;
			
			for (i = 0; i < particleDataArray.length; i++)
			{
				particleDataArray[i].val = ps[particleDataArray[i].props];				
			}
			
			for (i = 0; i < 5; i++)
			{
				colorDataArray[i].x = 120;				
				colorDataArray[i].y = 120;				
				colorDataArray[i].a = 1;
			}
			
			colorDataArray[5].blend = returnBlendInteger(ps.blendFuncSource);
			colorDataArray[5].rot = 1.57;
			colorDataArray[6].blend = returnBlendInteger(ps.blendFuncDestination);
			colorDataArray[6].rot = 1.57;
			
			
			var objectDataHolder:Object = new Object();
			objectDataHolder.particleDataArray = particleDataArray;
			objectDataHolder.colorDataArray = colorDataArray;
			
			
			
			dispatcher.setData(objectDataHolder);
		}
		private function setParam():void
		{
			//trace(selectedProp)
			
			//emitterType
			ps[particleDataArray[selectedProp].props] = uiValue;
		}
	}

}