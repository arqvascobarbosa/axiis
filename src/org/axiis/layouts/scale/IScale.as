package org.axiis.layouts.scale
{
	import mx.collections.ArrayCollection;
	
	/**
	 * IScale is an interface the defines the methods required to translate
	 * between a range of values and screen (layout) coordinate space.
	 */
	public interface IScale
	{
		/**
		 * The DataSet, ArrayCollection, Array, XML, etc. that is used to
		 * determine the range of this scale.
		 */
		function get dataProvider():Object;
		function set dataProvider(value:Object):void;
		
		/**
		 * The name of the property of the Objects in the dataProvider
		 * that should be used when computing maximum and minimum values.
		 * If this property is not set, the implementing class should
		 * use the Objects themselves.
		 */
		function get dataField():String;
		function set dataField(value:String):void;
		
		/**
		 * The minimum value allowed in this scale. If this property is
		 * not set, the implementer should compute an appropriate minimum
		 * by analyzing the contents of the dataProvider.
		 */
		function get minValue():Object;
		function set minValue(value:Object):void;
		
		/**
		 * The maximum value allowed in this scale. If this property is
		 * not set, the implementer should compute an appropriate maximum
		 * by analyzing the contents of the dataProvider.
		 */
		function get maxValue():Object;
		function set maxValue(value:Object):void;
		
		/**
		 * The minimum layout position.
		 */
		function get minLayout():Number;
		function set minLayout(value:Number):void;
		
		/**
		 * The maximum layout position.
		 */
		function get maxLayout():Number;
		function set maxLayout(value:Number):void;
		
		/**
		 * Converts a value to a position in layout space.
		 */
		function valueToLayout(value:Object):Number;
		
		/**
		 * Converts a layout position to a value that would arise in the
		 * space defined by the implementing class. For example, LinearScale
		 * converts a layout position to a Number between minValue and
		 * maxValue, whether or not that Number is actually present within
		 * the dataProvider. CategoricalScale, on the other hand, will only
		 * convert layout positions to values found within the dataProvider.
		 */
		function layoutToValue(layout:Number):Object;
		
		/**
		 * Initiates the computation of minValue and maxValue.
		 */
		function validate():void;
		
		/**
		 * Marks this IScale as needing its minValue and maxValue recomputed.
		 */
		function invalidate():void;
	}
}