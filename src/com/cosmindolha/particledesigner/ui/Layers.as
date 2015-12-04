package com.cosmindolha.particledesigner.ui 
{
	import com.gskinner.motion.GTween;
	import com.utils.Delay;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
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
		private var selectedLayerToDragY:Number;
		private var selectedLayerToDrag:LayerHolder;
		private var enableLayerDragging:Boolean;
		private var selectedLayerLocalYpos:Number;
		private var prevVal:Number;

		private var swapLayersTimer:Timer;
		private var dragedValue:Number=-1;
		private var dragLayerTimer:Timer;
		private var selectedLayerTween:GTween;
		private var layerDictionary:Dictionary;
		private var onReleaseSelectedY:Number = -1;

		private var movedLayerID:int;
		
		public function Layers(dd:DataDispatcher, rs:Resource) 
		{
			dispatcher = dd;
			resources = rs;
			uniqueLayerID = 0;
			
			layerDictionary = new Dictionary();
			
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
			prevVal = -1;
			layerPosY = upperLimitY;

			
			buildLayer(uniqueLayerID);
			
			dispatcher.addEventListener(LayerEvents.CHANGE_LAYER, onLayerChange);

			dispatcher.addEventListener(LayerEvents.START_DRAG_LAYER, onLayerDrag);
			
			dispatcher.addEventListener(UpdateLayerPreviewEvent.UPDATE_LAYER_PREVIEW, onLayerUpdate);
			
			addEventListener(TouchEvent.TOUCH, onTouch);
				
			swapLayersTimer = new Timer(10, 1);
			swapLayersTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onSwapLayersTimer);
			
			dragLayerTimer = new Timer(50, 1);
			dragLayerTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onDragTimer);
			
			
		}
		private function onDragTimer(e:TimerEvent):void
		{
			if (selectedLayerToDrag != null)
			{
				if (dragedValue != -1 && enableLayerDragging == true)
				{
					
					selectedLayerTween.proxy.y = dragedValue;
					
				}
			}
			dragLayerTimer.start();
		}
		private function onSwapLayersTimer(e:TimerEvent):void
		{
			swapLayers();
			swapLayersTimer.start();
		}
		private function swapLayers():void
		{
			var layerToMove:LayerHolder;
			if (selectedLayerToDrag != null)
			{				
				for each (var layerHD:LayerHolder in layersArray)
				{
						var dist:Number = layerHD.y - selectedLayerToDrag.y;		
						if (dist < 45 && dist > 0)
						{
							layerToMove = layerHD;
							break;
						}
				}						
				if (layerToMove != null && prevVal != -1)
				{

				
					if (layerToMove.locked == false)
					{
						onReleaseSelectedY = layerToMove.pozy;
						
						var newY:Number =  (prevVal > selectedLayerToDrag.y) ?  layerToMove.pozy + spacerY : layerToMove.pozy - spacerY;


						movedLayerID = layerToMove.id;
						layerToMove.pozy = newY;
						layerToMove.locked = true;
						
						var movelayerTween:GTween = new GTween(layerToMove, .2, { y: newY }, { onComplete:done } );	
						
					}
				}
				prevVal = selectedLayerToDrag.y;
			}
			function done():void
			{
				layerToMove.locked = false;
			}
		}
		private function onTouch(e:TouchEvent):void
		{

				var moveTouch:Touch = e.getTouch(stage, TouchPhase.MOVED);

				
				if (selectedLayerToDrag != null)
				{
					if (moveTouch != null)
					{
						if (enableLayerDragging == false)
						{
							enableLayerDragging = true;
						}
						var localPos:Point =  moveTouch.getLocation(this);
						dragedValue = localPos.y - selectedLayerLocalYpos;
					}
				}
			

			
			var upTouch:Touch = e.getTouch(stage, TouchPhase.ENDED);
			if (upTouch != null)
			{
				enableLayerDragging = false;
				prevVal = -1;
				swapLayersTimer.stop();
				dragLayerTimer.stop();

				var dalayer:Delay = new Delay(sety, 150);

				
			}
			function sety():void
			{
				if (selectedLayerToDrag != null && layersArray.length>1)
				{
					if (onReleaseSelectedY != -1)
					{
						
					var changes:Boolean = (selectedLayerToDrag.pozy != onReleaseSelectedY);
					
					//trace("nothing changed")
						
					selectedLayerToDrag.pozy = onReleaseSelectedY;
					selectedLayerToDrag.y = onReleaseSelectedY;
					onReleaseSelectedY = -1;
					
					var obj:Object = new Object();
					obj.id = selectedLayerToDrag.id;
					obj.movedLayerID = movedLayerID;
										
					
					if (changes)
					{
					dispatcher.setLayerIndex(obj);
					}
					}else{
						
						selectedLayerToDrag.y = selectedLayerToDrag.pozy;
					}
				}else if (selectedLayerToDrag != null && layersArray.length == 1){
					
					selectedLayerToDrag.y = 50;
				}
			}
		}
		private function onLayerUpdate(e:UpdateLayerPreviewEvent):void
		{
			var obj:Object = e.customData;
			if (currentLayer != null)
			{
				currentLayer.updatePreview(obj.img);
			}	
		}
		private function onLayerDrag(e:LayerEvents):void
		{
			var obj:Object = e.customData;
			selectedLayerLocalYpos = obj.localYpoz;
			selectedLayerToDragY = obj.bt.y;
			selectedLayerToDrag = obj.bt;
			
			selectedLayerTween = new GTween(selectedLayerToDrag, .1);
			
			
			
			swapLayersTimer.start();
			dragLayerTimer.start();
			
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
				updateDictionary();
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
		private function updateDictionary():void
		{
			
			
			for each(var layerHD:LayerHolder in layersArray)
			{			
				layerDictionary[layerHD.id] = layerHD.y;
				layerHD.pozy =  layerHD.y;
			}
			

			
		}
		private function pushLayersDownFrom(lh:LayerHolder):void
		{
			var posY:Number = lh.y;
			
			for each (var layerHD:LayerHolder in layersArray)
			{
				if (layerHD.y >= posY)
				{
					
					var toY:Number = layerHD.y + spacerY;
					var down:GTween = new GTween(layerHD, .1, {y: toY}, {onComplete:done});
			
				}
			}
			function done():void
			{
				updateDictionary();
			}
		}		
		private function pushLayersUpFrom(lh:LayerHolder):void
		{
			var posY:Number = lh.y;
			for each (var layerHD:LayerHolder in layersArray)
			{
				if (layerHD.y > posY)
				{
					var toY:Number = layerHD.y - spacerY;
					var down:GTween = new GTween(layerHD, .1, {y: toY}, {onComplete:done});
				}
			}
			function done():void
			{
				updateDictionary();
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