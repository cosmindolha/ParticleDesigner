package com.cosmindolha.particledesigner 
{
	import com.cosmindolha.particledesigner.ui.Button;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import com.cosmindolha.particledesigner.ui.KnobButtonStarling;
	import com.cosmindolha.particledesigner.events.CurrentButtonEvent;
	import com.cosmindolha.particledesigner.events.CurrentValEvent;
	import com.cosmindolha.particledesigner.events.SetDataEvent;
	import starling.events.Event;

	/**
	 * ...
	 * @author cosmin dolha
	 */
	public class UIStarlingScreen extends Sprite
	{
		
		private var resources:Resource;
		private var dispatcher:DataDispatcher;
		private var particleConfigurationArray:Array;
		private var totalButtons:int;
		private var buttonHolder:Sprite;
		private var buttonSelected:Button;
		private var particleDataArray:Array;
		private var buttonID:int;
		
		public function UIStarlingScreen(rs:Resource, dd:DataDispatcher) 
		{
			
			
			resources = rs;
			dispatcher = dd;
			
			var knob:KnobButtonStarling = new KnobButtonStarling(dispatcher);
			
			
			
			addChild(knob);
			
			knob.x = 850;
			knob.y = 600;
			
			particleConfigurationArray = new Array();
			particleConfigurationArray.push("Max \n"+"Particles");
			particleConfigurationArray.push("Lifespan");
			particleConfigurationArray.push("Lifespan \n" + "Variance");
			particleConfigurationArray.push("Start Size");
			particleConfigurationArray.push("Start Size \n" + "Variance");
			
			particleConfigurationArray.push("Finish Size");
			particleConfigurationArray.push("Finish Size \n" + "Variance");
			particleConfigurationArray.push("Emiter Angle");
			particleConfigurationArray.push("Emiter Angle \n" + "Variance");
			
			particleConfigurationArray.push("Rotation Start");
			particleConfigurationArray.push("Rotation Start \n" + "Variance");
			particleConfigurationArray.push("Rotation End ");
			particleConfigurationArray.push("Rotation End \n" + "Variance");

			
			particleConfigurationArray.push("X Variance");
			particleConfigurationArray.push("Y Variance");
			particleConfigurationArray.push("Speed");
			particleConfigurationArray.push("Speed Variance");
			
			particleConfigurationArray.push("Gravity X");
			particleConfigurationArray.push("Gravity Y");
			
			particleConfigurationArray.push("Rad. Acc.");
			particleConfigurationArray.push("Rad. Acc. \n" + "Variance");		
			
			particleConfigurationArray.push("Tan. Acc.");
			particleConfigurationArray.push("Tan. Acc. \n" + "Variance");

		
			
			
			buttonHolder = new Sprite();
			addChild(buttonHolder);
			buildButtons();
			
			particleDataArray = new Array();
			
			dispatcher.addEventListener(CurrentButtonEvent.SELECTED_BUTTON, onButtonPressed);

			
			dispatcher.addEventListener(CurrentValEvent.UI_VALUE, setVal);
			dispatcher.addEventListener(SetDataEvent.DATA_SET, setData);
			
		}
		private function setData(e:SetDataEvent):void
		{
			particleDataArray = e.customData;
		}
		private function setVal(e:CurrentValEvent):void
		{
			var obj:Object = e.customData;
			
			//var id:int = obj.id;
			//trace(buttonID, " - ", obj.rot, " ", obj.val)
			
			particleDataArray[buttonID] = obj;
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
			
			var sendObj:Object = particleDataArray[buttonID];
			
			//trace("button id ", buttonID)
			sendObj.label = particleConfigurationArray[buttonID];
			dispatcher.setKnob(sendObj);
		}
		private function buildButtons():void
		{
			totalButtons = 0;
			for (var i:int = 0; i < particleConfigurationArray.length; i++)
			{
				var button:Button = new Button(dispatcher, i);
				button.text = particleConfigurationArray[i];
				buttonHolder.addChild(button);
				button.addEventListener(Event.ADDED_TO_STAGE, onAdded);		
			}
			
			
		}
		private function onAdded(e:Event):void
		{
			totalButtons++;
			e.currentTarget.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			if (totalButtons == particleConfigurationArray.length)
			{
				rearrangeButton();
			}
		}
		private function rearrangeButton():void
		{
			var toX:int = 0;
			var toY:int = 0;
			
			for (var i:int = 0; i < buttonHolder.numChildren; i++)
			{
				var sp:DisplayObject = buttonHolder.getChildAt(i);
				sp.x = toX;
				sp.y = toY;
				
				toX += sp.width+10;
				if (toX > 1024- sp.width)
				{
					toY += 45;
					toX = 0;
				}
				
			}
		}
	}

}