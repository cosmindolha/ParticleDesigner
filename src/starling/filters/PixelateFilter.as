/**
 *	Copyright (c) 2012 Devon O. Wolfgang
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

package starling.filters
{
    import flash.display3D.Context3D;
    import flash.display3D.Context3DProgramType;
    import starling.textures.Texture;
	
    /**
     * Pixelates images (square 'pixels')
     * @author Devon O.
     */
    public class PixelateFilter extends BaseFilter
    {
        
        private var vars:Vector.<Number> = new <Number>[1, 1, 1, 1];
        private var _size:int;
        
        /**
         * Creates a new PixelateFilter
         * @param   size	size of pixel effect
         */
        public function PixelateFilter(size:int=8)
        {
            this._size = size;
        }
        
        /** Set AGAL */
        protected override function setAgal():void
        {
            FRAGMENT_SHADER =
            <![CDATA[
                div ft0, v0, fc0
                frc ft1, ft0
                sub ft0, ft0, ft1
                mul ft0, ft0, fc0
                tex oc, ft0, fs0<2d, clamp, linear, mipnone>
            ]]>
        }
        
        /** Activate */
        protected override function activate(pass:int, context:Context3D, texture:Texture):void
        {
            this.vars[0] = this._size / texture.width;
            this.vars[1] = this._size / texture.height;
            
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, this.vars, 1);
            super.activate(pass, context, texture);
        }
        
        /** Pixel Size */
        public function get pixelSize():int { return _size; }
        public function set pixelSize(value:int):void { _size = value; }
    }
}