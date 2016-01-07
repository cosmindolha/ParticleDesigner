/**
 *	Copyright (c) 2013 Devon O. Wolfgang
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
     * Creates a tiled glass distortion effect
     * @author Devon O.
     */
	
    public class GlassFilter extends BaseFilter
    {
        private var vars:Vector.<Number> = new <Number>[1, 1, 1, 1];
        
        private var _amount:Number;
        private var _ripple:Number;
        
        /**
         * Create a new GlassFilter effect
         * @param	amount		Amount of effect (0 - 1)
         * @param	ripple		Amount of ripple to apply
         */
        public function GlassFilter(amount:Number=0.0, ripple:Number=0.0)
        {
            _amount = amount;
            _ripple = ripple;
        }
        
        /** Set AGAL */
        override protected function setAgal():void 
        {
            FRAGMENT_SHADER =
            <![CDATA[
                mul ft0.xy, v0.xy, fc0.yy
                sin ft0.xy, ft0.xy
                mul ft0.xy, ft0.xy, fc0.xx
                
                add ft0.xy, v0.xy, ft0.xy
                tex oc, ft0.xy, fs0<2d, clamp, linear, mipnone>
            ]]>
        }
        
        /** Activate */
        protected override function activate(pass:int, context:Context3D, texture:Texture):void
        {
            this.vars[0] = _amount / 100;
            this.vars[1] = _ripple ;
            
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, this.vars, 1);
            
            super.activate(pass, context, texture);
        }
        
        /** Ripple */
        public function get ripple():Number { return _ripple; }
        public function set ripple(value:Number):void { _ripple = value; }
        
        /** Amount (0 - 1) */
        public function get amount():Number { return _amount; }
        public function set amount(value:Number):void { _amount = value; }
    }
}