/**
 *	Copyright (c) 2013 Amos Laber
 *
 *	Permission is hereby granted, free of charge, to any person obtaining a copy
 *	of this software and associated documentation files (the "Software"), to deal
 *	in the Software without restriction, including without limitation the rights
 *	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *	copies of the Software, and to permit persons to whom the Software is
 *	furnished to do so, subject to the following conditions:
 *
 *	The above copyright notice and this permission notice shall be included in
 *	all copies or substantial portions of the Software.
 *
 *	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *	THE SOFTWARE.
 */

package fw.anim
{
  import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	// =============================  Created by: Amos Laber, Dec 2, 2011
	// =================  Updated:  Feb 6, 2013  Initial Starling port
	// =================  Updated:  May 10, 2013 
	
	//
	// AnimSprite is a class to display an animated sequence from a sprite sheet
	// it is initialized with a sprite sheet and can hold multiple 
	// animation sequnces that can be switched anytime.
	//
	// This is a Starling port of the original class. All blitting code was replaced
	// with starling related display code.
	//
	public class AnimSprite extends Image implements IAnimatable
	{
		private var mAnimSheet:TextureAtlas;
		private var mSequences:Vector.<AnimSeqData>;
		
		private var donePlaying:Boolean;
		private var curAnim:AnimSeqData;
		private var curFrame:uint;  // Frame index in a sequence (local)
		
		// Internal, used to time each frame of animation.
		protected var frameTimer:Number;
		private var mNotifyFn:Function;
		
		private static var msEmptyFrame:Texture;
		
		public function AnimSprite(sheet:TextureAtlas)
		{
			mAnimSheet= sheet;
			
			if (!msEmptyFrame) {
				msEmptyFrame= Texture.empty(32,32);
			}
			
			super(msEmptyFrame);
			
			mSequences= new Vector.<AnimSeqData>();
		}
		
		// Check if we are playing a sequence
		//
		public function isPlaying():Boolean
		{
			return !donePlaying;
		}
		
		
		public function get numSequences():int { return mSequences.length; }
		
		public function get currentFrame():uint { return curFrame; }
		
		public function set currentFrame(val:uint):void
		{
			curFrame = val;
			frameTimer=0;
			
			updateFrame();
		}
		
		override public function dispose():void
		{
			mAnimSheet= null;
			
			while ( mSequences.length > 0) 	{
				mSequences.pop();
			}
			
			super.dispose();
		}
		
		//
		//
		public function addSequence(name:String, base:String, looped:Boolean=true, frameRate:Number=15):void
		{
			var frames:Vector.<Texture> = mAnimSheet.getTextures(base);
			if (!frames || frames.length==0) {
				trace("Error: not textures found!");
				return;	
			}
			
			addSequenceInternal(name, frames, frameRate, looped);
		}
		
		public function addReverseSequence(name:String, base:String, looped:Boolean=true, frameRate:Number=15):void
		{
			var frames:Vector.<Texture> = mAnimSheet.getTextures(base);
			if (!frames || frames.length==0) {
				trace("Error: not textures found!");
				return;	
			}
			
			addSequenceInternal(name, frames.reverse(), frameRate, looped);
		}
		
		private function addSequenceInternal(name:String, frames:Vector.<Texture>, frameRate:Number, looped:Boolean):void
		{
			var seq:AnimSeqData = new AnimSeqData(name, frames, frameRate, looped);
			mSequences.push(seq);
			
			// Show the first frame
			if (!curAnim) {
				curAnim= seq;
				currentFrame=0;
				donePlaying= true;
				readjustSize();
			}
		}
			
		private function findSequence(name:String):AnimSeqData
		{
			var aSeq:AnimSeqData;
			for (var i:int = 0; i < mSequences.length; i++) {
				aSeq = AnimSeqData(mSequences[i]);
				if (aSeq.seqName == name) {
					return aSeq;
				}
			}
			return null;
		}
		
		// Start playing a sequence
		//
		// Leaving sequence name as null will play the current sequence 
		//
		public function play(name:String=null, doneCb:Function=null):void
		{
			mNotifyFn= doneCb;
			frameTimer = 0;
			
			if (name == null) {
				donePlaying= false;

				return;
			}
			
			
			curFrame = 0; // Set to first frame
			
			if (!curAnim || curAnim.seqName != name) {
				curAnim= findSequence(name);
				if (!curAnim) {
					trace("play: cannot find sequence: " + name);
					return;
				}
				
				updateFrame();
				readjustSize();
			}
			
			// trace("playing " + name +", frames: " + curAnim.arFrames.length);
			donePlaying= false;
		
			
			// Stop if we only have a single frame
			if (curAnim.seqFrames.length==1) donePlaying= true;
		}
		
		private var _showWhenDone:Boolean= false;
		
		// Covinience function that takes care of attching the animation to the juggler
		// and detaching it when it is done.
		//
		public function attachAndPlayOnce(name:String=null, showAfterStop:Boolean=false):void
		{
			_showWhenDone= showAfterStop;
			Starling.juggler.add(this);
			this.visible= true;
			
			this.play(name, endPlay);
		}
		
		private function endPlay(a:AnimSprite):void
		{
			Starling.juggler.remove(a);
			a.visible= _showWhenDone;
		}
		
		// External stop
		//
		public function stop():void
		{
			donePlaying= true;
		}
		
		public function internal_stop():void
		{
			donePlaying= true;
			//dispatchEventWith(Event.COMPLETE);
			if (mNotifyFn!=null) mNotifyFn(this);
		}
		
		private function updateFrame():void
		{
			texture = curAnim.seqFrames[curFrame]; 
		}
		
		// 
		//
		private function advanceFrame():void
		{
			if (curFrame == curAnim.seqFrames.length -1) {
				if (curAnim.loop)
					curFrame = 0;
				else internal_stop(); 
				
			}
			else ++curFrame;
			
			updateFrame();
		}
		
		public function advanceTime(deltaTime:Number):void
		{
			if (curAnim!=null && curAnim.frameTime > 0 && !donePlaying) {
				
				// Check elapsed time and adjust to sequence rate 
				frameTimer += deltaTime;
				
				while(frameTimer > curAnim.frameTime) {
					frameTimer = frameTimer - curAnim.frameTime;
					advanceFrame();
				}
			}
		}
		
	}
}


import starling.textures.Texture;

internal class AnimSeqData
{
	public var seqName:String;
	public var seqFrames:Vector.<Texture>;
	public var fps:int;
	public var loop:Boolean;
	public var frameTime:Number=0;
	
	public function AnimSeqData(name:String, frames:Vector.<Texture>, frameRate:Number=0, looped:Boolean=true)
	{
		seqName= name;
		seqFrames= frames;
		fps= frameRate;
		loop= looped;
		
		frameTime = 1.0 / frameRate;
	}
}
