package ru.whitered.tween.displayObject 
{

	/**
	 * @author whitered
	 */
	public class PropertyModifier 
	{
		private var object:Object;
		private var propertyName:String;
		
		private var _startValue:Number = 0;
		private var _endValue:Number = 1;
		
		

		
		
		public function PropertyModifier(object:Object, propertyName:String) 
		{
			this.propertyName = propertyName;
			this.object = object;
		}
		
		
		
		public function get startValue():Number
		{
			return _startValue;
		}
		
		
		
		public function set startValue(startValue:Number):void
		{
			_startValue = startValue;
		}
		
		
		
		public function get endValue():Number
		{
			return _endValue;
		}
		
		
		
		public function set endValue(endValue:Number):void
		{
			_endValue = endValue;
		}
		
		
		
		public function update(progress:Number):void
		{
			object[propertyName] = _startValue * (1 - progress) + _endValue * progress;
		}
		
		
		
		public function init():void
		{
			_startValue = object[propertyName];
		}
	}
}
