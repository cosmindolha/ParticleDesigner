package com.cosmindolha.particledesigner 
{
	import com.cosmindolha.particledesigner.events.CurrentValEvent;
	import com.utils.Delay;
	import de.flintfabrik.starling.utils.ColorArgb;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import starling.display.Canvas;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.filters.AnselFilter;
	import starling.filters.BlurFilter;
	import starling.filters.GlassFilter;
	import starling.filters.GodRaysFilter;
	import starling.filters.NewsprintFilter;
	import starling.filters.ToyBlockFilter;
	import starling.textures.RenderTexture;

	import starling.textures.Texture;
	import starling.core.Starling;
	import starling.textures.TextureAtlas;
	import starling.events.ResizeEvent;
		
	import de.flintfabrik.starling.display.FFParticleSystem;
	import de.flintfabrik.starling.display.FFParticleSystem.SystemOptions;
	
	import com.cosmindolha.particledesigner.events.CurrentButtonEvent;
	import com.cosmindolha.particledesigner.events.ColorPickerEvent;
	import com.cosmindolha.particledesigner.events.CurrentColorButtonEvent;
	import com.cosmindolha.particledesigner.events.ChangeBlendEvent;
	import com.cosmindolha.particledesigner.events.CurrentMenuButtonEvent;
	import com.cosmindolha.particledesigner.events.LayerEvents;
	import com.cosmindolha.particledesigner.events.MoveParticleEvent;
	import com.cosmindolha.particledesigner.events.TextureEvent;
	import com.cosmindolha.particledesigner.events.PictureEvent;
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

		private var allDataArray:Array;
		private var currentLayerID:int;
		private var layersHolder:Sprite;
		private var updateLayerPreviewTimer:Timer;
		
		private var layersSpriteDictionary:Dictionary;
		
		private var particleDictionary:Dictionary;
		private var ui:UIStarlingScreen;
		private var disableScreenSprite:Sprite;
		private var bubbleConfig:XML;
		private var textureArray:Array;
		private var hp:Image;
		private var bf:BlurFilter;
		private var isParticleType:Boolean;

	
		
		public function ParticleScreen() 
		{
			
			bgQuad = new Quad(768, 1024, 0x65496a);
			addChild(bgQuad);
			
			disableScreenSprite = new Sprite();
			
			
			
			layersHolder = new Sprite();
			addChild(layersHolder);
			
			particleDataArray = new Array();
			colorDataArray = new Array();
			allDataArray = new Array();
			
			
			layersSpriteDictionary = new Dictionary();
			particleDictionary = new Dictionary();
			
			dispatcher = new DataDispatcher();
			
			resources = new Resource(dispatcher);
			
			resources.assets.verbose = false;
			
	
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			dispatcher.addEventListener("ASSETS_LOADED", onAssetsReady);
			dispatcher.addEventListener(CurrentButtonEvent.SELECTED_BUTTON, onButtonPressed);
			dispatcher.addEventListener(CurrentColorButtonEvent.SELECTED_COLOR_BUTTON, onColorButtonPressed);
			
			dispatcher.addEventListener(ChangeBlendEvent.SET_BLEND_COLOR, onBlendColorChange);			
			
			dispatcher.addEventListener(ColorPickerEvent.SET_COLOR, onSetColor);
			
			dispatcher.addEventListener(CurrentMenuButtonEvent.SELECTED_MENU_BUTTON, onRightMenuClicked);
			
			dispatcher.addEventListener(MoveParticleEvent.ON_PARTICLE_MOVE, moveParticleAround);
			
			//layers
			dispatcher.addEventListener(LayerEvents.NEW_LAYER, onNewLayer);
			dispatcher.addEventListener(LayerEvents.CHANGE_LAYER, onLayerChange);
			dispatcher.addEventListener(LayerEvents.REMOVE_LAYER, onRemoveLayer);
			dispatcher.addEventListener(LayerEvents.CHANGE_LAYER_VISIBILITY, onLayerVisibility);
			dispatcher.addEventListener(LayerEvents.CHANGE_INDEX, onLayerIndexChange);
			
			dispatcher.addEventListener(TextureEvent.OPEN_GALLERY, onOpenTextureGallery);
			dispatcher.addEventListener(TextureEvent.TEXTURE_PICKED, obChangePartTexture);
			
			dispatcher.addEventListener(PictureEvent.OPEN_PICTURE_GALLERY, onOpenPictureGallery);
			dispatcher.addEventListener(PictureEvent.PICTURE_PICKED, onPicturePicked);
			
			dispatcher.addEventListener("exportData", onExportData);
			
			updateLayerPreviewTimer = new Timer(500, 1);
			
			updateLayerPreviewTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onUpdateTimer);
			updateLayerPreviewTimer.start();
			
			textureArray = new Array();
			textureArray.push("txt1");
			textureArray.push("txt2");
			textureArray.push("txt3");
			textureArray.push("txt4");
			textureArray.push("txt5");
			textureArray.push("txt6");
			
			

	
		}

		private function onExportData(e:String):void
		{
			trace("______________________________ begin export data ______________________________");
			
			var ps:FFParticleSystem = particleDictionary[currentLayerID];
			
			var sysOption:SystemOptions = ps.exportSystemOptions(sysOption);
			
			var varList:XMLList = flash.utils.describeType(sysOption)..variable;

			for(var i:int; i < varList.length(); i++){
				trace(varList[i].@name+':'+ sysOption[varList[i].@name]);
			}
	

			trace("______________________________ end export data ______________________________");
			
		}
		private function onPicturePicked(e:PictureEvent):void
		{
			
			var obj:Object = e.customData;
			
			var spriteLayer:Sprite = layersSpriteDictionary[currentLayerID];
			
			var img:Image = new Image(resources.assets.getTexture(obj.texture));
			img.x = -img.width / 2;
			img.y = -img.height / 2;
			spriteLayer.addChild(img);
			
			spriteLayer.x = stage.stageWidth / 2;
			spriteLayer.y = stage.stageHeight / 2 ;
			
			
			disableScreenSprite.visible = false;
			
			resumeParticles();
		}
		private function onOpenPictureGallery(e:PictureEvent):void
		{
			disableScreen();
		}
		private function obChangePartTexture(e:TextureEvent):void
		{
			var obj:Object = e.customData;
			
			var ps:FFParticleSystem = particleDictionary[currentLayerID];
			
			//var sysOption:SystemOptions = ps.exportSystemOptions(sysOption);
			var newTexture:Texture = resources.assets.getTexture(obj.texture);
			
			var tempSysOpt:SystemOptions = ps.exportSystemOptions();
			var xmlOptions:XML = tempSysOpt.exportConfig();
			
			var sysOption:SystemOptions = SystemOptions.fromXML(xmlOptions, newTexture);

			
			var spriteHolder:Sprite = layersSpriteDictionary[currentLayerID];
			
			
			ps.reset();
			ps.dispose();
			
			
			var newPs:FFParticleSystem = new FFParticleSystem(sysOption);
			newPs.emitterX = 0;
			newPs.emitterY = 0;
			
			particleDictionary[currentLayerID] = newPs;
			
			newPs.x = ps.x ;
			newPs.y = ps.y ;
			
			spriteHolder.removeChild(ps);
			
			spriteHolder.addChild(newPs);
			
			newPs.start();
			
			disableScreenSprite.visible = false;
			
			resumeParticles();
			
		}
		private function onOpenTextureGallery(e:TextureEvent):void
		{
			disableScreen();
		}
		private function disableScreen():void
		{
			
		//starling 1.7
		//var texture:RenderTexture = new RenderTexture(stage.stageWidth, stage.stageHeight, false, .5, "bgra", false);
		if (stage.stageWidth < 1100)
		{
		//start starling 2
		var texture:RenderTexture = new RenderTexture(stage.stageWidth, stage.stageHeight, false, .5, "bgra");
		//end starling 2
		
			var drawSprite:DisplayObject = root;
			
			bf = new BlurFilter(4, 4, 1);
			drawSprite.filter = bf;
			
			texture.draw(drawSprite);
			
			disableScreenSprite.visible = true;
			disableScreenSprite.removeChildren();
			
			
			var screenImage:Image = new Image(texture);
			disableScreenSprite.addChild(screenImage);
			
			setChildIndex(disableScreenSprite, numChildren - 1);
			setChildIndex(ui, numChildren - 1);
			var delay:Delay = new Delay(removeFilters, 5);
		}
			pauseParticles();
			
			
		}

		private function removeFilters():void
		{
			var drawSprite:DisplayObject = root;
			drawSprite.filter.dispose();
			drawSprite.filter = null;
		}
		private function resumeParticles():void
		{
			for each (var ps:FFParticleSystem in particleDictionary)
			{
				ps.resume();
			}
		}	
		
		private function pauseParticles():void
		{
			for each (var ps:FFParticleSystem in particleDictionary)
			{
				ps.pause();
			}
		}
		private function onAddedToStage(e:Event):void
		{

				bgQuad.width = stage.stageWidth;
				bgQuad.height = stage.stageHeight;
				
				disableScreenSprite.visible = false;
		}
		private function moveParticleAround(e:MoveParticleEvent):void
		{
			var point:Point = e.customData;
			var spriteToMove:Sprite = layersSpriteDictionary[currentLayerID];
			
			if (spriteToMove != null)
			{
				//if (isParticleType == true)
				//{
					spriteToMove.x = point.x;
					spriteToMove.y = point.y;
				//}
			}
		}
		private function onLayerIndexChange(e:LayerEvents):void
		{
			var obj:Object = e.customData;
			
			var spriteToAffect:Sprite = layersSpriteDictionary[obj.id];
			var spriteMoved:Sprite = layersSpriteDictionary[obj.movedLayerID];
			var spriteMovedIndex:int = layersHolder.getChildIndex(spriteMoved);
			
			layersHolder.setChildIndex(spriteToAffect, spriteMovedIndex);
			
			
		}
		private function onLayerVisibility(e:LayerEvents):void
		{
			var obj:Object = e.customData;
			
	
			var spriteToAffect:Sprite = layersSpriteDictionary[obj.id];
			spriteToAffect.visible = obj.particleVisible;
			
			
		}
		private function onRemoveLayer(e:LayerEvents):void
		{
			//trace("deleting")
			var obj:Object = e.customData;
			var spriteToDelete:Sprite = layersSpriteDictionary[currentLayerID];
			
			if (obj.isParticleType)
			{
			var currentParticleSystem:FFParticleSystem = particleDictionary[currentLayerID];
			
			currentParticleSystem.dispose();
			delete particleDictionary[currentLayerID];
			}
			spriteToDelete.removeChildren();
			layersHolder.removeChild(spriteToDelete);
			
			delete layersSpriteDictionary[currentLayerID];
			
			
		}
		private function onUpdateTimer(e:TimerEvent):void
		{
			updateLayerPreview(currentLayerID);
			updateLayerPreviewTimer.start();
		}
		private function updateLayerPreview(id:int):void
		{
			
			var spriteToCapture:Sprite = layersSpriteDictionary[currentLayerID];
		
			if (spriteToCapture != null)
			{
			
			try{
				
			//var renderTexture:RenderTexture = new RenderTexture(stage.stageWidth, stage.stageHeight, false, .05, "bgra");
			
			var myMatrix:Matrix = new Matrix();
			myMatrix.createBox(.05, .05, 0, 45, 40);
			
				
			var renderTexture:RenderTexture = new RenderTexture(122, 92, false, 1, "bgra");				
			
	
				
			renderTexture.draw(spriteToCapture, myMatrix);
			var img:Image = new Image(renderTexture);
			
			//img.pivotX = img.width / 2;
			//img.pivotY = img.height / 2;
			
			//img.scaleX = 0.12;		
			//img.scaleY = 0.12;		
			
			var obj:Object = new Object();
			
			obj.id = currentLayerID;
			obj.img = img;
			
			dispatcher.updateLayer(obj);
				}catch (err:Error){
					trace("resource limit");
				}
			}
			
		}

		private function onLayerChange(e:LayerEvents):void
		{
			
			var obj:Object = e.customData;
			currentLayerID = obj.id;
			
			if (obj.isParticleType)
			{
				var objectDataHolder:Object = populateDataWithCurrentSet();
				dispatcher.setData(objectDataHolder);
			}
		}
		private function onNewLayer(e:LayerEvents):void
		{	
			var obj:Object = e.customData;
			isParticleType = obj.isParticleType;
			if (obj.isParticleType)
			{
			
				newParticleSystem(obj.id);	
			
			}else {
				newImageLayer(obj.id);
			}
		}
		//fires when you change the blend color knob
		private function onRightMenuClicked(e:CurrentMenuButtonEvent):void
		{
			var obj:Object = e.customData;
			isParticleType = obj.isParticleType;
			var id:int = obj.id;
			var currentParticleSystem:FFParticleSystem = particleDictionary[currentLayerID];
			trace(id)
			switch(id)
			{
			case 3:
				currentParticleSystem.emitterType = 0;
				break;
			case 4:
				currentParticleSystem.emitterType = 1;
				break;
			}	
		}
		private function onBlendColorChange(e:ChangeBlendEvent):void
		{
			var obj:Object = e.customData;
			var id:int = obj.blend;
			
			if (selecedColorButtonID == 5 || selecedColorButtonID == 6)
			{
				var currentParticleSystem:FFParticleSystem = particleDictionary[currentLayerID];
				if (currentParticleSystem != null)
				{
					currentParticleSystem[colorDataArray[selecedColorButtonID].props] = returnBlendString(blendValues[id]);
				}	
			}
		}
		
		//give string input (Context3DBlendFactor.ZERO), returns in id with blend modes
		
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
		
			var currentParticleSystem:FFParticleSystem = particleDictionary[currentLayerID];

			
				if (currentParticleSystem != null)
				{
					currentParticleSystem[colorDataArray[selecedColorButtonID].props] = colorArgb;
					
				}	
				
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
		private function newImageLayer(uniqueID:int):void
		{
			currentLayerID = uniqueID;
			
			var layerSprite:Sprite = new Sprite();
			layersHolder.addChild(layerSprite);
				
			layersSpriteDictionary[currentLayerID] = layerSprite;
			

		}
		private function newParticleSystem(uniqueID:int):void
		{
			
			currentLayerID = uniqueID;

			
			var newParticleSprite:Sprite = new Sprite();
			layersHolder.addChild(newParticleSprite);
			
			layersSpriteDictionary[currentLayerID] = newParticleSprite;
			
			
			var rndTexture:Texture = resources.assets.getTexture(textureArray[rnd(0, textureArray.length-1)]);
			
			
			var xmlOptions:XML = sysOpt.exportConfig();
			
			sysOpt = SystemOptions.fromXML(xmlOptions, rndTexture);

			
			
			var newParticleSys:FFParticleSystem = new FFParticleSystem(sysOpt);
			

			newParticleSys.emitterX = 0;
			newParticleSys.emitterY = 0;
					
			newParticleSprite.x = stage.stageWidth/2;
			newParticleSprite.y = stage.stageHeight/2;
			
			newParticleSprite.addChild(newParticleSys);
			
			newParticleSys.start();
			
			particleDictionary[currentLayerID] = newParticleSys;
			
			//var gfilter:AnselFilter = new AnselFilter(0.8,0.5,0.5,0);
			//var gfilter:AnselFilter = new AnselFilter(0.8,0.5,0.5,0);

			//newParticleSprite.filter = gfilter;
		}
		private function init():void
		{

			bubbleConfig =  new XML(resources.assets.getXml("story"));
			var bubbleTexture:Texture = resources.assets.getTexture("txt6");
			
			//var rndTexture:Texture = resources.assets.getTexture(textureArray[rnd(0, textureArray.length-1)]);
		
			sysOpt = SystemOptions.fromXML(bubbleConfig, bubbleTexture);
			
			FFParticleSystem.init(1024, false, 512, 4);
			
			newParticleSystem(0);
			
			ui = new UIStarlingScreen(resources, dispatcher);
				
				
			
			dispatcher.addEventListener(CurrentValEvent.UI_VALUE, setVal);
			
			delaySetValueTimer = new Timer(200, 1);
			delaySetValueTimer.addEventListener(TimerEvent.TIMER_COMPLETE, setValueTimer);
			delaySetValueTimer.start();
				
			setInitData();

			addChild(disableScreenSprite);
			addChild(ui);

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
			
			particleDataArray.push({label:"Max \n"+"Particles", props:"maxNumParticles", val:0, rot:0, m:1});
			particleDataArray.push({label:"Lifespan", props:"lifespan", val:0, rot:0, m:.01});
			particleDataArray.push({label:"Lifespan \n" + "Var", props:"lifespanVariance", val:0, rot:0, m:.01});
			particleDataArray.push({label:"Start \nSize", props:"startSize", val:0, rot:0, m:1});
			particleDataArray.push({label:"Start Size \n" + "Var", props:"startSizeVariance", val:0, rot:0, m:1});
			particleDataArray.push({label:"Finish \nSize", props:"endSize", val:0, rot:0, m:1});
			particleDataArray.push({label:"Finish \nSize Var", props:"endSizeVariance", val:0, rot:0, m:1});
			particleDataArray.push({label:"Emiter \nAngle", props:"emitAngle", val:0, rot:0, m:.1});
			particleDataArray.push({label:"Emiter \nAngle Var", props:"emitAngleVariance", val:0, rot:0, m:.1});
			particleDataArray.push({label:"Rot Start", props:"startRotation", val:0, rot:0, m:.1});
			particleDataArray.push({label:"Rot Start \n" + "Var", props:"startRotationVariance", val:0, rot:0, m:.1});
			particleDataArray.push({label:"Rot End", props:"endRotation", val:0, rot:0, m:.1});
			particleDataArray.push( { label:"Rot End \n" + "Var", props:"endRotationVariance", val:0, rot:0, m:.1 } );
			//emitter gravity
			particleDataArray.push({label:"X Var", props:"emitterXVariance", val:0, rot:0, m:1});
			particleDataArray.push({label:"Y Var", props:"emitterYVariance", val:0, rot:0, m:1});
			particleDataArray.push({label:"Speed", props:"speed", val:0, rot:0, m:.1});
			particleDataArray.push({label:"Speed Var", props:"speedVariance", val:0, rot:0, m:.1});
			particleDataArray.push({label:"Gravity X", props:"gravityX", val:0, rot:0, m:1});
			particleDataArray.push({label:"Gravity Y", props:"gravityY", val:0, rot:0, m:1});
			particleDataArray.push({label:"Rad. Acc.", props:"radialAcceleration", val:0, rot:0, m:1});
			particleDataArray.push({label:"Rad. Acc. \n" + "Variance", props:"radialAccelerationVariance", val:0, rot:0, m:1});
			particleDataArray.push({label:"Tan. Acc.", props:"tangentialAcceleration", val:0, rot:0, m:1});
			particleDataArray.push({label:"Tan. Acc. \n" + "Variance", props:"tangentialAccelerationVariance", val:0, rot:0, m:1});
			//emitter radial
			particleDataArray.push({label:"Max. Rad", props:"maxRadius", val:0, rot:0, m:1});
			particleDataArray.push({label:"Max. Rad\nVariance", props:"maxRadiusVariance", val:0, rot:0, m:1});
			particleDataArray.push({label:"Min. Rad", props:"minRadius", val:0, rot:0, m:1});
			particleDataArray.push({label:"Min. Rad\nVariance", props:"minRadiusVariance", val:0, rot:0, m:1});
			particleDataArray.push({label:"Rot/Sec", props:"rotatePerSecond", val:0, rot:0, m:.05});
			particleDataArray.push({label:"Rot/Sec\nVariance", props:"rotatePerSecondVariance", val:0, rot:0, m:.1});
	

			
			var objectDataHolder:Object = populateDataWithCurrentSet();
			
			dispatcher.setData(objectDataHolder);
		}
		private function clone(source:Object):* 
		{ 
				var myBA:ByteArray = new ByteArray(); 
				myBA.writeObject(source); 
				myBA.position = 0; 
				return(myBA.readObject()); 
		}
		private function populateDataWithCurrentSet():Object
		{
			var obj:Object = new Object();
			
			var cloned_ParticleDataArray:Array = new Array();
			var cloned_ColorDataArray:Array = new Array();
			
			cloned_ParticleDataArray = clone(particleDataArray);
			cloned_ColorDataArray = clone(colorDataArray);
			
			var currentParticleSystem:FFParticleSystem = particleDictionary[currentLayerID];
			
			
			var i:int = 0;
			
			for (i = 0; i < cloned_ParticleDataArray.length; i++)
			{
				cloned_ParticleDataArray[i].val = currentParticleSystem[particleDataArray[i].props];				
			}
			
			for (i = 0; i < 5; i++)
			{
				cloned_ColorDataArray[i].x = 120;				
				cloned_ColorDataArray[i].y = 120;				
				cloned_ColorDataArray[i].a = 1;
			}
			
			cloned_ColorDataArray[5].blend = returnBlendInteger(currentParticleSystem.blendFuncSource);
			cloned_ColorDataArray[5].rot = 1.57;
			cloned_ColorDataArray[6].blend = returnBlendInteger(currentParticleSystem.blendFuncDestination);
			cloned_ColorDataArray[6].rot = 1.57;
			
			
			
			obj.particleDataArray = cloned_ParticleDataArray;
			obj.colorDataArray = cloned_ColorDataArray;
			
			
			return obj;
		}
		private function setParam():void
		{
			
			var currentParticleSystem:FFParticleSystem = particleDictionary[currentLayerID];
			if (currentParticleSystem != null)
			{
				currentParticleSystem[particleDataArray[selectedProp].props] = uiValue;
			}
		}
		private function rnd(min:Number, max:Number):Number
		{
			//creates a random number between a range of numbers (ex, 0,9)
			var randomNum:Number = Math.floor(Math.random()*(max-min+1))+min;
			return randomNum;
		}
	}

}