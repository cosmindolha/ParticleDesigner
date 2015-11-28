package com.cosmindolha.particledesigner.ui 
{
	import com.gskinner.motion.GTween;
	import com.utils.Delay;
	import starling.display.Image;
	import starling.display.Sprite;
	import com.cosmindolha.particledesigner.DataDispatcher;
	import com.cosmindolha.particledesigner.Resource;
	import com.cosmindolha.particledesigner.events.LayerEvents;
	import com.cosmindolha.particledesigner.events.UpdateLayerPreviewEvent;
	import starling.textures.Texture;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * ...
	 * @author cosmin dolha
	 */
	public class Layers extends Sprite
	{
		private var dispatcher:DataDispatcher;
		private var resources:Resource;
		private var addLayerButton:ButtonLayers;
		private var removeLayerButton:ButtonLayers;
		private var layersArray:Array;
		private var layerPosX:int;
		private var layerPosY:int;

		private var layerArray:Array;
		private var currentLayerID:int;
		private var uniqueLayerID:int;
		private var currentLayer:LayerHolder;
		private var spacerY:Number=-1;
		private var upperLimitY:int;
		private var selectY:Number;
		
		public function Layers(dd:DataDispatcher, rs:Resource) 
		{
			dispatcher = dd;
			resources = rs;
			uniqueLayerID = 0;
			
			var topImage:Image = new Image(resources.assets.getTexture("layertopgraphic"));
			
			addChild(topImage);
			
			addLayerButton = new ButtonLayers(dispatcher, 0);
			removeLayerButton = new ButtonLayers(dispatcher, 1);
			addChild(addLayerButton);
			addChild(removeLayerButton);
			addLayerButton.x = 3;
			addLayerButton.y = 6;
			removeLayerButton.x = 48;
			removeLayerButton.y = 6;
			
			addLayerButton.addEventListener("buttonLayerClicked", addLayer);
			removeLayerButton.addEventListener("buttonLayerClicked", removeLayer);
			
			layersArray = new Array();
			
			
			upperLimitY = 50;
			layerPosX = 0;
			layerPosY = upperLimitY;

			
			buildLayer(uniqueLayerID);
			
			dispatcher.addEventListener(LayerEvents.CHANGE_LAYER, onLayerChange);
			dispatcher.addEventListener(UpdateLayerPreviewEvent.UPDATE_LAYER_PREVIEW, onLayerUpdate);
			
		}
		private function onLayerUpdate(e:UpdateLayerPreviewEvent):void
		{
			var obj:Object = e.customData;
			if (currentLayer != null)
			{
				currentLayer.updatePreview(obj.img);
			}	
		}
		private function onLayerChange(e:LayerEvents):void
		{
			selectLayer(e.customData.bt);
		}
		private function selectLayer(layerHolder:LayerHolder):void
		{
			if (currentLayer != null)
			{
				currentLayer.deselect();
				
			}
			layerHolder.select();
			currentLayerID = layerHolder.id;
			currentLayer = layerHolder;	
			
			selectY = layerHolder.y;
			
		}
		private function buildLayer(id:int):void
		{
			//id should be unique so we can track the different particles systems
			
			var newLayer:LayerHolder = new LayerHolder(dispatcher, resources, id);
			
			addChild(newLayer);	
			layersArray.push(newLayer);
			
			if (spacerY == -1)
			{
				spacerY = newLayer.height + 2;
			}
			if (currentLayer != null)
			{
				pushLayersDownFrom(currentLayer);			
				newLayer.y = selectY;
				
			}else{
				newLayer.y = 50;
			}		
			selectLayer(newLayer);		
		}
		private function pushLayersDownFrom(lh:LayerHolder):void
		{
			var posY:Number = lh.y;
			
			for each (var layerHD:LayerHolder in layersArray)
			{
				if (layerHD.y >= posY)
				{
					//layerHD.y += spacerY;
					var toY:Number = layerHD.y + spacerY;
					var down:GTween = new GTween(layerHD, .1, {y: toY});
			
				}
			}	
		}		
		private function pushLayersUpFrom(lh:LayerHolder):void
		{
			var posY:Number = lh.y;
			for each (var layerHD:LayerHolder in layersArray)
			{
				if (layerHD.y > posY)
				{
					//layerHD.y -= spacerY;
					var toY:Number = layerHD.y - spacerY;
					var down:GTween = new GTween(layerHD, .1, {y: toY});
				}
			}	
		}
		private function addLayer(e:String):void
		{
			uniqueLayerID++;
			buildLayer(uniqueLayerID);
			var obj:Object = new Object();
			obj.id = uniqueLayerID;
			
			dispatcher.addLayer(obj);
		}	
		private function removeLayer(e:String):void
		{
			if (currentLayer != null)
			{
			for (var i:int = 0; i < layersArray.length; i++) 
			{
				var layerToRemove:LayerHolder = layersArray[i];
				if (currentLayer == layerToRemove)
				{				
					pushLayersUpFrom(layerToRemove);
					layersArray.splice(i, 1);
					removeChild(layerToRemove);
					currentLayer = null;
					break;
				}
			}
			dispatcher.removeLayer();
			}
		}
	}

}