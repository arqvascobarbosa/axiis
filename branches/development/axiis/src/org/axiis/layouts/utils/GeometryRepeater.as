package org.axiis.layouts.utils
{
	import com.degrafa.geometry.Geometry;
	
	import flash.events.EventDispatcher;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import mx.core.Application;

	/**
	 * GeometryRepeater modifies geometries through the use of
	 * PropertyModifiers.
	 * 
	 * When modifications take longer than a single frame, they are distributed
	 * over multiple frames to prevent the application from appearing to have
	 * frozen. 
	 */
	public class GeometryRepeater extends EventDispatcher
	{
		/**
		 * Constructor.
		 */
		public function GeometryRepeater()
		{
			super();
		}
		
		private var timerID:int;
		
		/**
		 * The Geometry that should be repeated.
		 */
		public var geometry:Geometry;
		
		[Inspectable(category="General", arrayType="org.axiis.layouts.utils.PropertyModifier")]
		[ArrayElementType("org.axiis.layouts.utils.PropertyModifier")]
		/**
		 * An array of PropertyModifiers that should be applied with each
		 * iteration of the GeometryRepeater.
		 */
		public var modifiers:Array;
		
		/**
		 * The number of iterations that the GeometryRepeater has processed.
		 * When the GeometryRepeater is not running, this value is -1.
		 */
		public function get currentIteration():int
		{
			return _currentIteration;
		}
		private var _currentIteration:int = -1;
		
		/**
		 * A flag indicating that the GeometryRepeater has finished repeating
		 * but the geometry's properties have not yet been restored to their
		 * original values.
		 */
		public function get iterationLoopComplete():Boolean
		{
			return _iterationLoopComplete;
		}
		private var _iterationLoopComplete:Boolean = true;
		
		private var numIterations:int = 0;
		
		/**
		 * Begins the modifications process.
		 *  
		 * @param preIterationCallback
		 * @param postIterationCallback
		 * @param completeCallback
		 */
		public function repeat(numIterations:int, preIterationCallback:Function = null, postIterationCallback:Function=null, completeCallback:Function = null):void
		{
			this.numIterations = numIterations;
			if(numIterations <= 0)
				return;
			
			_iterationLoopComplete = false;
			clearTimeout(timerID);
			_currentIteration = 0;
			repeatHelper(preIterationCallback,postIterationCallback,completeCallback);
		}
		
		/**
		 * @private
		 */
		protected function repeatHelper(preIterationCallback:Function = null, postIterationCallback:Function=null, completeCallback:Function = null):void
		{
			var app:Application = Application(Application.application);
			var millisecondsPerFrame:Number = app.stage ? 1000 / app.stage.frameRate : 50;
			var startTime:int = getTimer();
			var totalTime:int = 0;
			while(totalTime < millisecondsPerFrame && currentIteration < numIterations)
			{
				if(preIterationCallback != null)
					preIterationCallback.call(this);
				
				if(geometry)
				{
					for each (var modifier:PropertyModifier in modifiers)
					{ 
						if(currentIteration == 0)
							modifier.beginModify(geometry);
						modifier.apply();
					}
				}
				_currentIteration++;
				
				if (postIterationCallback != null)
					postIterationCallback.call(this);
			
				totalTime = getTimer() - startTime;
			}
			
			// We've finished looping before time ran out. Tear down and call completeCallback
			if(currentIteration == numIterations)
			{					
				_iterationLoopComplete = true;
				for each (modifier in modifiers)
				{
					modifier.end();
				}
				_currentIteration = -1;
				completeCallback.call(this); //Call back now, before we set all our properties back to the original values
			}
			// The loop took too long and we had to break out. Give the player 10ms to render and, and try again
			else
			{
				timerID = setTimeout(repeatHelper,1,preIterationCallback,postIterationCallback,completeCallback);
			}
		}
	}
}