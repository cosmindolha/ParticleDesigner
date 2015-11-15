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


		private var buttonHolder:Sprite;
		private var buttonSelected:Button;
		private var particleDataArray:Array;
		private var buttonID:int;
		
		public function UIStarlingScreen(rs:Resource, dd:DataDispatcher) 
		{
			resources = rs;
			dispatcher = dd;
			var knob:KnobButtonStarling = new KnobButtonStarling(dispatcher, resources);
			addChild(knob);
			knob.x = 850;
			knob.y = 600;
			
			var colorPicker:ColorPicker = new ColorPicker(dispatcher, resources);
			
			addChild(colorPicker);
			colorPicker.x = 750;
			colorPicker.y = 200;
			
			
			buttonHolder = new Sprite();
			addChild(buttonHolder);
			dispatcher.addEventListener(CurrentButtonEvent.SELECTED_BUTTON, onButtonPressed);
			dispatcher.addEventListener(SetDataEvent.DATA_SET, setData);
						
			dispatcher.addEventListener(CurrentValEvent.UI_VALUE, setVal);
			
		}
		private function setData(e:SetDataEvent):void
		{
			
			particleDataArray = new Array();
			particleDataArray = e.customData;			
			buildButtons();
		}

		private function setVal(e:CurrentValEvent):void
		{
			var obj:Object = e.customData;
			particleDataArray[buttonID].val =  obj.val
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
			var sendObj:Object =new Object();
			sendObj.label = particleDataArray[buttonID].label;
			sendObj.val = particleDataArray[buttonID].val;
			dispatcher.setKnob(sendObj);
		}
		private function buildButtons():void
		{
			for (var i:int = 0; i < particleDataArray.length; i++)
			{
				var button:Button = new Button(dispatcher, i);
				button.text = particleDataArray[i].label;
				buttonHolder.addChild(button);	
			}
			rearrangeButton();
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