package com.cosmindolha.particledesigner 
{

	import com.cosmindolha.particledesigner.events.CurrentValEvent;
	import com.cosmindolha.particledesigner.events.CurrentButtonEvent;
	import com.cosmindolha.particledesigner.events.SetKnobEvent;
	import com.cosmindolha.particledesigner.events.SetDataEvent;
	import com.cosmindolha.particledesigner.events.ColorPickerEvent;
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
		private var setKnobEvent:SetKnobEvent;
		private var setDataEvent:SetDataEvent;
		private var setColorEvent:ColorPickerEvent;
		
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
		
		public function setData(data:Array):void
		{
			setDataEvent = new SetDataEvent(SetDataEvent.DATA_SET, data);
			dispatchEvent(setDataEvent);
		}		
		
		public function buttonClicked(data:Object):void
		{
			selectedButtonEvent = new CurrentButtonEvent(CurrentButtonEvent.SELECTED_BUTTON, data);
			dispatchEvent(selectedButtonEvent);
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