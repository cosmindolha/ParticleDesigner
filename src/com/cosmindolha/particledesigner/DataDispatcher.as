package com.cosmindolha.particledesigner 
{

	import com.cosmindolha.particledesigner.events.CurrentValEvent;
	import com.cosmindolha.particledesigner.events.CurrentButtonEvent;
	import com.cosmindolha.particledesigner.events.SetKnobEvent;
	import com.cosmindolha.particledesigner.events.SetDataEvent;
	import com.cosmindolha.particledesigner.events.ColorPickerEvent;
	import com.cosmindolha.particledesigner.events.CurrentColorButtonEvent;
	import com.cosmindolha.particledesigner.events.SetColorPickerEvent;
	import com.cosmindolha.particledesigner.events.CurrentMenuButtonEvent;
	import com.cosmindolha.particledesigner.events.ChangeBlendEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author ...
	 */
	public class DataDispatcher extends EventDispatcher
	{
	
		private var setValueEvent:CurrentValEvent;
		private var selectedButtonEvent:CurrentButtonEvent;
		private var selectedColorButtonEvent:CurrentColorButtonEvent;
		private var setKnobEvent:SetKnobEvent;
		private var setDataEvent:SetDataEvent;
		private var setColorEvent:ColorPickerEvent;
		private var setColorPickerEvent:SetColorPickerEvent;
		private var setMenuButtonEvent:CurrentMenuButtonEvent;
		private var changeBlendColorEvent:ChangeBlendEvent;
		private var setBlendKnobEvent:ChangeBlendEvent;
		
		public function setBlendKnob(data:Object):void
		{
			setBlendKnobEvent = new ChangeBlendEvent(ChangeBlendEvent.SET_BLEND_KNOB, data);
			dispatchEvent(setBlendKnobEvent);
		}
		public function setBlendColor(data:Object):void
		{
			changeBlendColorEvent = new ChangeBlendEvent(ChangeBlendEvent.SET_BLEND_COLOR, data);
			dispatchEvent(changeBlendColorEvent);
		}
		public function menuClicked(data:Object):void
		{
			setMenuButtonEvent = new CurrentMenuButtonEvent(CurrentMenuButtonEvent.SELECTED_MENU_BUTTON, data);
			dispatchEvent(setMenuButtonEvent);
		}
		public function setColor(data:Object):void
		{
			setColorEvent = new ColorPickerEvent(ColorPickerEvent.SET_COLOR, data);
			dispatchEvent(setColorEvent);
		}
		public function setKnob(data:Object):void
		{
			setKnobEvent = new SetKnobEvent(SetKnobEvent.SET_KNOB, data);
			dispatchEvent(setKnobEvent);
		}		
		
		public function setColorPicker(data:Object):void
		{
			setColorPickerEvent = new SetColorPickerEvent(SetColorPickerEvent.SET_COLOR_PICKER, data);
			dispatchEvent(setColorPickerEvent);
		}	
		
		public function setData(data:Object):void
		{
			setDataEvent = new SetDataEvent(SetDataEvent.DATA_SET, data);
			dispatchEvent(setDataEvent);
		}		
		
		public function buttonClicked(data:Object):void
		{
			selectedButtonEvent = new CurrentButtonEvent(CurrentButtonEvent.SELECTED_BUTTON, data);
			dispatchEvent(selectedButtonEvent);
		}		
		
		public function buttonColorClicked(data:Object):void
		{
			selectedColorButtonEvent = new CurrentColorButtonEvent(CurrentColorButtonEvent.SELECTED_COLOR_BUTTON, data);
			dispatchEvent(selectedColorButtonEvent);
		}
		
		
		public function setValue(data:Object):void
		{
			setValueEvent = new CurrentValEvent(CurrentValEvent.UI_VALUE, data);
			dispatchEvent(setValueEvent);
		}
		
		public function assetsLoaded():void
		{
			dispatchEvent(new Event("ASSETS_LOADED"));
		}

	}

}