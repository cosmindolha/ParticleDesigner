package com.cosmindolha.particledesigner 
{

	import com.cosmindolha.particledesigner.events.CurrentValEvent;
	import com.cosmindolha.particledesigner.events.CurrentButtonEvent;
	import com.cosmindolha.particledesigner.events.PictureEvent;
	import com.cosmindolha.particledesigner.events.SetKnobEvent;
	import com.cosmindolha.particledesigner.events.SetDataEvent;
	import com.cosmindolha.particledesigner.events.ColorPickerEvent;
	import com.cosmindolha.particledesigner.events.CurrentColorButtonEvent;
	import com.cosmindolha.particledesigner.events.SetColorPickerEvent;
	import com.cosmindolha.particledesigner.events.CurrentMenuButtonEvent;
	import com.cosmindolha.particledesigner.events.ChangeBlendEvent;
	import com.cosmindolha.particledesigner.events.LayerEvents;
	import com.cosmindolha.particledesigner.events.UpdateLayerPreviewEvent;
	import com.cosmindolha.particledesigner.events.MoveParticleEvent;
	import com.cosmindolha.particledesigner.events.TextureEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
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
		private var newLayerEvent:LayerEvents;
		private var changeLayerEvent:LayerEvents;
		private var removeLayerEvent:LayerEvents;
		private var visibilityLayerEvent:LayerEvents;

		private var startDragLayerEvent:LayerEvents;
		private var changeLayerIndexEvent:LayerEvents;
		
		private var updateLayerPreviewEvent:UpdateLayerPreviewEvent;
		private var moveParticleEvent:MoveParticleEvent;
		private var openTextureGallerEvent:TextureEvent;
		private var texturePickedEvent:TextureEvent;
		
		private var picturePickedEvent:PictureEvent;
		private var openPictureEvent:PictureEvent;
		
		public function exportData():void
		{
			dispatchEvent(new Event("exportData"));
		}
		public function openPicturePicker():void
		{
			openPictureEvent = new PictureEvent(PictureEvent.OPEN_PICTURE_GALLERY, null);
			dispatchEvent(openPictureEvent);
		}
		public function picturePicked(data:Object):void
		{
			picturePickedEvent = new PictureEvent(PictureEvent.PICTURE_PICKED, data);
			dispatchEvent(picturePickedEvent);
		}
		public function texturePicked(data:Object):void
		{
			texturePickedEvent = new TextureEvent(TextureEvent.TEXTURE_PICKED, data);
			dispatchEvent(texturePickedEvent);
			
		}	
		
		public function openTexturePicker():void
		{
			openTextureGallerEvent = new TextureEvent(TextureEvent.OPEN_GALLERY, null);
			dispatchEvent(openTextureGallerEvent);
			
		}
		
		public function moveParticle(data:Point):void
		{
			moveParticleEvent = new MoveParticleEvent(MoveParticleEvent.ON_PARTICLE_MOVE, data);
			dispatchEvent(moveParticleEvent);
		}

		
		public function setLayerIndex(data:Object):void
		{
			changeLayerIndexEvent = new LayerEvents(LayerEvents.CHANGE_INDEX, data);
			dispatchEvent(changeLayerIndexEvent);
		}		
		
		public function dragLayer(data:Object):void
		{
			startDragLayerEvent = new LayerEvents(LayerEvents.START_DRAG_LAYER, data);
			dispatchEvent(startDragLayerEvent);
		}
		public function visibilityLayer(data:Object):void
		{
			visibilityLayerEvent = new LayerEvents(LayerEvents.CHANGE_LAYER_VISIBILITY, data);
			dispatchEvent(visibilityLayerEvent);
		}	
		public function updateLayer(data:Object):void
		{
			updateLayerPreviewEvent = new UpdateLayerPreviewEvent(UpdateLayerPreviewEvent.UPDATE_LAYER_PREVIEW, data);
			dispatchEvent(updateLayerPreviewEvent);
		}
		public function addLayer(data:Object):void
		{
			newLayerEvent = new LayerEvents(LayerEvents.NEW_LAYER, data);
			dispatchEvent(newLayerEvent);
		}
		public function removeLayer(data:Object):void
		{
			removeLayerEvent = new LayerEvents(LayerEvents.REMOVE_LAYER, data);
			dispatchEvent(removeLayerEvent);
		}	
		public function changeLayer(data:Object):void
		{
			changeLayerEvent = new LayerEvents(LayerEvents.CHANGE_LAYER, data);
			dispatchEvent(changeLayerEvent);
		}
		
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