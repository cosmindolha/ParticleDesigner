package com.cosmindolha.particledesigner
{
	import com.cosmindolha.particledesigner.ui.Button;
	import com.cosmindolha.particledesigner.ui.ColorButton;
	import com.cosmindolha.particledesigner.ui.ColorPicker;
	import com.cosmindolha.particledesigner.ui.Layers;
	import com.cosmindolha.particledesigner.ui.RightMenuButton;
	import com.cosmindolha.particledesigner.ui.KnobBlendColorStarling;
	import com.cosmindolha.particledesigner.ui.TexturePicker;
	import com.utils.Delay;
	import flash.geom.Point;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import com.cosmindolha.particledesigner.ui.KnobButtonStarling;
	import com.cosmindolha.particledesigner.events.CurrentButtonEvent;
	import com.cosmindolha.particledesigner.events.CurrentValEvent;
	import com.cosmindolha.particledesigner.events.SetDataEvent;
	import com.cosmindolha.particledesigner.events.CurrentColorButtonEvent;
	import com.cosmindolha.particledesigner.events.ColorPickerEvent;
	import com.cosmindolha.particledesigner.events.CurrentMenuButtonEvent;
	import com.cosmindolha.particledesigner.events.ChangeBlendEvent;
	import com.cosmindolha.particledesigner.events.LayerEvents;
	import com.cosmindolha.particledesigner.events.TextureEvent;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchPhase;
	import starling.events.TouchEvent;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author cosmin dolha
	 */
	public class UIStarlingScreen extends Sprite
	{
		
		private var resources:Resource;
		private var dispatcher:DataDispatcher;
		

		
		private var buttonSelected:Button;
		private var buttonColorSelected:ColorButton;
		private var particleDataArray:Array;
		private var colorDataArray:Array;
		private var buttonID:int;
		private var buttonColorID:int = 0;
		private var rightMenuArray:Array;
		private var currentRightMenuButtonID:int;
		private var rightMenuButtonSelected:RightMenuButton;
		private var uiSpriteArray:Array;
		
		
		private var knobController:KnobButtonStarling;
		private var colorPicker:ColorPicker;
		private var knobBlendColorController:KnobBlendColorStarling;
		
		private var buttonHolderConfig:Sprite;
		private var buttonHolderEmitterGravity:Sprite;
		private var buttonHolderEmitterRadial:Sprite;
		private var buttonColorHolder:Sprite;
		
		private var uiLayers:Layers;
		private var buttonsBuilt:Boolean;
		private var texturePicker:TexturePicker;
		private var showUI:Boolean = true;
		private var rightButtonsArray:Array;
		
		//private var selectedSettingsArray:Array;
		//private var currentParticleSettingsArray:Array;
		
		public function UIStarlingScreen(rs:Resource, dd:DataDispatcher)
		{
			resources = rs;
			dispatcher = dd;
			
			rightMenuArray = new Array();
			//selectedSettingsArray = new Array();
			//selectedSettingsArray[0] = [];
			
			//currentParticleSettingsArray = new Array();
			
			rightMenuArray.push("Particle \nTexture");
			rightMenuArray.push("Particle \nConfig");
			rightMenuArray.push("Em. Type\nGravity");
			rightMenuArray.push("Em. Type\nRadial");
			rightMenuArray.push("Color \nConfig");
			rightMenuArray.push("Layers");
			rightMenuArray.push("Move \nParticle");
			
			//layers
			
			uiLayers = new Layers(dispatcher, resources);
			
			
			//texture gallery
			
			texturePicker = new TexturePicker(dispatcher, resources);
			
			
			//controllers
			knobBlendColorController = new KnobBlendColorStarling(dispatcher, resources);
			

			
			//addChild(knobBlendColorController);
			
			knobController = new KnobButtonStarling(dispatcher, resources);
			

			
			colorPicker = new ColorPicker(dispatcher, resources);
			
			

			
			//sprites
			
			buttonHolderConfig = new Sprite();	
			buttonColorHolder = new Sprite();	
			buttonHolderEmitterGravity = new Sprite();
			buttonHolderEmitterRadial = new Sprite();

			
			uiSpriteArray = new Array();
			uiSpriteArray.push(buttonHolderConfig);
			uiSpriteArray.push(buttonColorHolder);
			uiSpriteArray.push(buttonHolderEmitterGravity);
			uiSpriteArray.push(buttonHolderEmitterRadial);
			//controllers
			uiSpriteArray.push(colorPicker);
			uiSpriteArray.push(knobController);
			uiSpriteArray.push(knobBlendColorController);
			//other ui elements
			uiSpriteArray.push(uiLayers);
			uiSpriteArray.push(texturePicker);
			
			
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			dispatcher.addEventListener(CurrentButtonEvent.SELECTED_BUTTON, onButtonPressed);
			
			dispatcher.addEventListener(CurrentColorButtonEvent.SELECTED_COLOR_BUTTON, onColorButtonPressed);
			
			dispatcher.addEventListener(SetDataEvent.DATA_SET, setData);
			
			dispatcher.addEventListener(CurrentValEvent.UI_VALUE, setVal);
			
			dispatcher.addEventListener(ColorPickerEvent.SET_COLOR, onSetColor);
			
			dispatcher.addEventListener(CurrentMenuButtonEvent.SELECTED_MENU_BUTTON, onRightMenuClicked);
			
			dispatcher.addEventListener(ChangeBlendEvent.SET_BLEND_COLOR, onChangeBlendEvent);
			
			dispatcher.addEventListener(LayerEvents.NEW_LAYER, onNewLayer);
			dispatcher.addEventListener(LayerEvents.CHANGE_LAYER, onLayerChange);
			
			dispatcher.addEventListener(TextureEvent.TEXTURE_PICKED, onChangePartTexture);
			
			
				
			
			
			
			uiLayers.visible = true;
			
		}
		private function onChangePartTexture(e:TextureEvent):void
		{
			texturePicker.visible = false;
		}
		private function onAddedToStage(e:Event):void
		{
			var scaleF:Number = 1;
			

			
			uiLayers.x = stage.stageWidth - 174;
			
			knobBlendColorController.x = stage.stageWidth - 174;
			knobBlendColorController.y = stage.stageHeight - 168;	
			
			knobController.x = stage.stageWidth - 174;
			knobController.y = stage.stageHeight - 168;
			
			colorPicker.x = stage.stageWidth - 320;
			colorPicker.y = stage.stageHeight - 320;
			
			colorPicker.scaleX = scaleF;
			colorPicker.scaleY = scaleF;		
			
			knobController.scaleX = scaleF;
			knobController.scaleY = scaleF;	
			
			knobBlendColorController.scaleX = scaleF;
			knobBlendColorController.scaleY = scaleF;
			
			if (stage.stageWidth <= 480);
			{
				scaleF = 0.6;
				
				//buttonHolderConfig.scaleX = 0.6;
				//buttonHolderConfig.scaleY = 0.6;
			}
			
			buildRightMenu();
			
			addToUI();
		}
		private function onNewLayer(e:LayerEvents):void
		{
			
		}
		private function onLayerChange(e:LayerEvents):void
		{
			
		}
		private function onChangeBlendEvent(e:ChangeBlendEvent):void
		{
			var obj:Object = e.customData;
			
			colorDataArray[buttonColorID].blend = obj.blend;
			colorDataArray[buttonColorID].rot = obj.rot;
			
			
		}
		private function addToUI():void
		{
			for (var i:int = 0; i < uiSpriteArray.length; i++)
			{
				addChild(uiSpriteArray[i]);
			}
		}
		private function showColorConfig():void
		{
			buttonColorHolder.visible = true;
		}
		
		private function showLayers():void
		{
			uiLayers.visible = true;
		}
		private function showRadialEmiterConfig():void
		{
			buttonHolderEmitterRadial.visible = true;
		}
		private function showGravityEmiterConfig():void
		{
			buttonHolderEmitterGravity.visible = true;
		}
		
		private function showParticleConfig():void
		{
			buttonHolderConfig.visible = true;
		}
		
		private function onTouch(e:TouchEvent):void
		{
			var moveTouch:Touch = e.getTouch(stage, TouchPhase.MOVED);
			//var downTouch:Touch = e.getTouch(stage, TouchPhase.BEGAN);
			//var upTouch:Touch = e.getTouch(stage, TouchPhase.ENDED);
			if (moveTouch != null)
			{
				
				var localPos:Point = moveTouch.getLocation(this);
				if (localPos.x < 940)
				{
					dispatcher.moveParticle(localPos);
				}
			}
		}
		private function moveParticleAround():void
		{
			stage.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		private function hideUI():void
		{
			for (var i:int = 0; i < uiSpriteArray.length; i++)
			{
				uiSpriteArray[i].visible = false;
			}
			if (buttonColorSelected != null)
			{
				buttonColorSelected.deselect()
			}
			if (buttonSelected != null)
			{
				buttonSelected.deselect()
			}
			try{
			if (stage.hasEventListener(TouchEvent.TOUCH))
			{
				stage.removeEventListener(TouchEvent.TOUCH, onTouch);
			}
			}catch (er:Error)
			{
				trace("is stage null?", stage)
			}
		}

		private function showTexturePicker():void
		{
			
			dispatcher.openTexturePicker();
			texturePicker.visible = true;
		}
		private function showSelectedUI():void
		{
			hideUI();
			switch (currentRightMenuButtonID)
			{
			
			case 0:
				showTexturePicker();
				break;
			case 1:
				
				showParticleConfig();
				break;
			case 2: 
				showGravityEmiterConfig();
				break;
			case 3: 
				showRadialEmiterConfig();
				break;	
			case 4: 
				showColorConfig();
				break;
			case 5: 
				showLayers();
				break;						
			case 6: 
				moveParticleAround();
				showLayers();
			break;
				
			}
		}
		
		private function onRightMenuClicked(e:CurrentMenuButtonEvent):void
		{
			var obj:Object = e.customData;
			
			if (obj.id == 99)
			{
				showUI = ! showUI;
				showRightButtons(showUI);
			
			}
			if (rightMenuButtonSelected != null)
			{
				rightMenuButtonSelected.deselect();
			}
			currentRightMenuButtonID = obj.id;
			
			obj.bt.select();
			rightMenuButtonSelected = obj.bt;
			
			showSelectedUI();
		
		}
		
		private function showRightButtons(v:Boolean):void
		{
			for each(var bt:RightMenuButton in rightButtonsArray)
			{
				bt.visible = v;
			}
		}
		private function buildRightMenu():void
		{
			hideUI();
						
			var toX:int = stage.stageWidth - 72;
			var toY:int = 50;
			var spacerY:int = 50;
			if (stage.stageWidth <= 480)
			{
				spacerY = 35;
			}
			
			var upButton:RightMenuButton  = new RightMenuButton(dispatcher, 99, "UI");
			addChild(upButton);
			upButton.x = toX;
			
			rightButtonsArray = new Array();
			
			for (var i:int = 0; i < rightMenuArray.length; i++)
			{
				var rightMenuButton:RightMenuButton = new RightMenuButton(dispatcher, i, rightMenuArray[i]);
				rightMenuButton.x = toX;
				rightMenuButton.y = toY;
				toY += spacerY;
				addChild(rightMenuButton);
				
				rightButtonsArray.push(rightMenuButton);
			}
		}
		
		private function onSetColor(e:ColorPickerEvent):void
		{
			
			var rgbObj:Object = e.customData;
			
			colorDataArray[buttonColorID].a = rgbObj.a;
			colorDataArray[buttonColorID].color = rgbObj.color;
			colorDataArray[buttonColorID].x = rgbObj.x;
			colorDataArray[buttonColorID].y = rgbObj.y;
			colorDataArray[buttonColorID].rot = rgbObj.rot;
			
			
		}
		
		private function setData(e:SetDataEvent):void
		{
			
			var objectDataHolder:Object = e.customData;
			
			particleDataArray = objectDataHolder.particleDataArray;
			colorDataArray = objectDataHolder.colorDataArray;
			
			if (buttonsBuilt == false)
			{
				buildButtons();
			}
		}
		
		private function setVal(e:CurrentValEvent):void
		{
			var obj:Object = e.customData;
			particleDataArray[buttonID].val = obj.val
			particleDataArray[buttonID].rot = obj.rot
		}
		
		private function onColorButtonPressed(e:CurrentColorButtonEvent):void
		{

			
			var obj:Object = e.customData;
			
			if (buttonColorSelected != null)
			{
				buttonColorSelected.deselect()
			}
			var selectedButton:ColorButton = obj.bt;
			selectedButton.select();
			buttonColorSelected = obj.bt;
			buttonColorID = obj.id;
			
			var colorObject:Object = new Object();
			
			colorObject.a = colorDataArray[buttonColorID].a;
			colorObject.color = colorDataArray[buttonColorID].color;
			colorObject.x = colorDataArray[buttonColorID].x;
			colorObject.y = colorDataArray[buttonColorID].y;
			
			colorObject.rot = colorDataArray[buttonColorID].rot;
			
			dispatcher.setColorPicker(colorObject);
			

			if (buttonColorID == 5 || buttonColorID == 6)
			{
				knobBlendColorController.visible = true;
				colorPicker.visible = false;
				var blendKnobObject:Object = new Object();
				
				blendKnobObject.blend =  colorDataArray[buttonColorID].blend;
				blendKnobObject.rot =  colorDataArray[buttonColorID].rot;
				
				dispatcher.setBlendKnob(blendKnobObject);
			}else{
				
				knobBlendColorController.visible = false;
				colorPicker.visible = true;
			}
		
		}
		
		private function onButtonPressed(e:CurrentButtonEvent):void
		{
			if (knobController.visible == false)
			{
				knobController.visible = true;
			}
			var obj:Object = e.customData;
			if (buttonSelected != null)
			{
				buttonSelected.deselect()
			}
			var selectedButton:Button = obj.bt;
			selectedButton.select();
			buttonSelected = obj.bt;
			buttonID = obj.id;
			var sendObj:Object = new Object();
			
			sendObj.label = particleDataArray[buttonID].label;
			sendObj.val = particleDataArray[buttonID].val;
			sendObj.rot = particleDataArray[buttonID].rot;
			dispatcher.setKnob(sendObj);
		}
		
		private function buildButtons():void
		{
			
			buttonsBuilt = true;
			var i:int;
			//from 0-15 particle config
			//from 15-23 emitter type gravity
			
			//particle config
			for (i = 0; i < 15; i++)
			{
				var button:Button = new Button(dispatcher, i);
				button.text = particleDataArray[i].label;
				buttonHolderConfig.addChild(button);
			}
			//emitter type gravity
			
			for (i = 15; i < 23; i++)
			{
				var buttonE:Button = new Button(dispatcher, i);
				buttonE.text = particleDataArray[i].label;
				buttonHolderEmitterGravity.addChild(buttonE);
			}		
			//emitter type radial
			for (i = 23; i < 29; i++)
			{
				var buttonR:Button = new Button(dispatcher, i);
				buttonR.text = particleDataArray[i].label;
				buttonHolderEmitterRadial.addChild(buttonR);
			}
			
			
			
			
			for (i = 0; i < colorDataArray.length; i++)
			{
				var colorButton:ColorButton = new ColorButton(dispatcher, i);
				colorButton.text = colorDataArray[i].label;
				buttonColorHolder.addChild(colorButton);
			}
			
			arrangeButton(buttonHolderConfig);
			arrangeButton(buttonHolderEmitterGravity);
			arrangeButton(buttonHolderEmitterRadial);
			arrangeButton(buttonColorHolder);
		
		}
		
		private function arrangeButton(holder:Sprite):void
		{
			var toX:int = 5;
			var toY:int = 0;
			
			for (var i:int = 0; i < holder.numChildren; i++)
			{
				var sp:DisplayObject = holder.getChildAt(i);
				sp.x = toX;
				sp.y = toY;
				toY += sp.height + 5;
				
			}
		}
		

	}

}