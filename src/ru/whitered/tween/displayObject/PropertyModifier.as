package ru.whitered.tween.displayObject 
{

	/**
	 * @author whitered
	 */
	public class PropertyModifier implements IPropertyModifier 
	{
		private var object:Object;
		private var propertyName:String;
		
		private var _startValue:Number = 0;
		private var _endValue:Number = 0;
		
		private var relative:Boolean = true;
		private var value:Number = 0;

		
		
		
		
		public function PropertyModifier(object:Object, propertyName:String) 
		{
			this.propertyName = propertyName;
			this.object = object;
		}
		
		
		
		public function setChange(value:Number, relative:Boolean):PropertyModifier
		{
			this.relative = relative;
			this.value = value;
			return this;
		}
		
		
		
		public function update(progress:Number):void
		{
			object[propertyName] = _startValue * (1 - progress) + _endValue * progress;
		}
		
		
		
		public function init():void
		{
			_startValue = object[propertyName];
			_endValue = relative ? _startValue + value : value;
		}
	}
}
