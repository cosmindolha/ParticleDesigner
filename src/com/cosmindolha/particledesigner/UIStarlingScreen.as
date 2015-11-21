package com.cosmindolha.particledesigner
{
	import com.cosmindolha.particledesigner.ui.Button;
	import com.cosmindolha.particledesigner.ui.ColorButton;
	import com.cosmindolha.particledesigner.ui.ColorPicker;
	import com.cosmindolha.particledesigner.ui.RightMenuButton;
	import com.cosmindolha.particledesigner.ui.KnobBlendColorStarling;
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
	import starling.events.Event;
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
		
		public function UIStarlingScreen(rs:Resource, dd:DataDispatcher)
		{
			resources = rs;
			dispatcher = dd;
			
			rightMenuArray = new Array();
			
			rightMenuArray.push("Particle \nConfig");
			rightMenuArray.push("Em. Type\nGravity");
			rightMenuArray.push("Em. Type\nRadial");
			rightMenuArray.push("Color \nConfig");
			rightMenuArray.push("Hide All");
			
			//controllers
			knobBlendColorController = new KnobBlendColorStarling(dispatcher, resources);
			
			knobBlendColorController.x = 850;
			knobBlendColorController.y = 600;	
			
			//addChild(knobBlendColorController);
			
			knobController = new KnobButtonStarling(dispatcher, resources);
			
			knobController.x = 850;
			knobController.y = 600;
			
			colorPicker = new ColorPicker(dispatcher, resources);
			
			
			colorPicker.x = 700;
			colorPicker.y = 450;
			
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
			
			
			dispatcher.addEventListener(CurrentButtonEvent.SELECTED_BUTTON, onButtonPressed);
			
			dispatcher.addEventListener(CurrentColorButtonEvent.SELECTED_COLOR_BUTTON, onColorButtonPressed);
			
			dispatcher.addEventListener(SetDataEvent.DATA_SET, setData);
			
			dispatcher.addEventListener(CurrentValEvent.UI_VALUE, setVal);
			
			dispatcher.addEventListener(ColorPickerEvent.SET_COLOR, onSetColor);
			
			dispatcher.addEventListener(CurrentMenuButtonEvent.SELECTED_MENU_BUTTON, onRightMenuClicked);
			
			dispatcher.addEventListener(ChangeBlendEvent.SET_BLEND_COLOR, onChangeBlendEvent);
			
			
			buildRightMenu();
				
			
			addToUI();
			
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
			
			
			if (buttonColorID >= 5)
			{
				colorPicker.visible = false;
				knobBlendColorController.visible = true;
			}else{
				
				colorPicker.visible = true;
				knobBlendColorController.visible = false;
			}
		}
		
		private function showRadialEmiterConfig():void
		{
			buttonHolderEmitterRadial.visible = true;
			knobController.visible = true;
		}
		private function showGravityEmiterConfig():void
		{
			buttonHolderEmitterGravity.visible = true;
			knobController.visible = true;
		}
		
		private function showParticleConfig():void
		{
			buttonHolderConfig.visible = true;
			knobController.visible = true;
		}
		
		private function hideUI():void
		{
			for (var i:int = 0; i < uiSpriteArray.length; i++)
			{
				uiSpriteArray[i].visible = false;
			}
		}
		
		private function showSelectedUI():void
		{
			
			hideUI();
			switch (currentRightMenuButtonID)
			{
			
			case 0:
				
				showParticleConfig();
				break;
			case 1: 
				showGravityEmiterConfig();
				break;
			case 2: 
				showRadialEmiterConfig();
				break;	
			case 3: 
				showColorConfig();
				break;
			case 4: 
				break;
				
			}
		}
		
		private function onRightMenuClicked(e:CurrentMenuButtonEvent):void
		{
			var obj:Object = e.customData;
			
			if (rightMenuButtonSelected != null)
			{
				rightMenuButtonSelected.deselect();
			}
			currentRightMenuButtonID = obj.id;
			
			obj.bt.select();
			rightMenuButtonSelected = obj.bt;
			
			showSelectedUI();
		
		}
		
		private function buildRightMenu():void
		{
			hideUI();
						
			var toX:int = 960;
			var toY:int = 50;
			
			for (var i:int = 0; i < rightMenuArray.length; i++)
			{
				var rightMenuButton:RightMenuButton = new RightMenuButton(dispatcher, i, rightMenuArray[i]);
				rightMenuButton.x = toX;
				rightMenuButton.y = toY;
				toY += 50;
				addChild(rightMenuButton);
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
			
			buildButtons();
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