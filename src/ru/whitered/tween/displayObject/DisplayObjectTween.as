package ru.whitered.tween.displayObject 
{
	import flash.utils.Dictionary;
	import ru.whitered.tween.tweens.TimeTween;

	import flash.display.DisplayObject;

	/**
	 * @author whitered
	 */
	public class DisplayObjectTween extends TimeTween 
	{
		private var displayObject:DisplayObject;
		
		private const modifiers:Dictionary = new Dictionary();
		
		
		
		public function DisplayObjectTween(displayObject:DisplayObject, duration:uint)
		{
			this.displayObject = displayObject;
			super(duration, 0, 1);
			onUpdate.add(handleUpdate);
		}

		
		
		override public function start():Boolean 
		{
			for each(var modifier:IPropertyModifier in modifiers) modifier.init();
			return super.start();
		}
		
		
		
		private function handleUpdate(tween:DisplayObjectTween):void 
		{
			const progress:Number = this.position;
			for each(var modifier:IPropertyModifier in modifiers)
			{
				modifier.update(progress);
			}
		}
		
		
		
		private function createModifier(propertyName:String, value:Number, relative:Boolean):IPropertyModifier
		{
			const modifier:PropertyModifier = modifiers[propertyName] ||= new PropertyModifier(displayObject, propertyName);
			modifier.setChange(value, relative); 
			if(isPlaying) modifier.init();
			return modifier;
		}

		
		
		//----------------------------------------------------------------------
		// basic properties
		//----------------------------------------------------------------------
		public function xTo(value:Number):DisplayObjectTween
		{
			createModifier("x", value, false);
			return this;
		}
		
		
		
		public function xBy(value:Number):DisplayObjectTween
		{
			createModifier("x", value, true);
			return this;
		}

		
		
		public function yTo(value:Number):DisplayObjectTween
		{
			createModifier("y", value, false);
			return this;
		}
		
		
		
		public function yBy(value:Number):DisplayObjectTween
		{
			createModifier("y", value, true);
			return this;
		}
		
		
		
		public function moveTo(x:Number, y:Number):DisplayObjectTween
		{
			createModifier("x", x, false);
			createModifier("y", y, false);
			return this;
		}
		
		
		
		public function moveBy(x:Number, y:Number):DisplayObjectTween
		{
			createModifier("x", x, true);
			createModifier("y", y, true);
			return this;
		}

		
		
		public function alphaTo(value:Number):DisplayObjectTween
		{
			createModifier("alpha", value, false);
			return this;
		}
		
		
		
		public function alphaBy(value:Number):DisplayObjectTween
		{
			createModifier("alpha", value, true);
			return this;
		}
	}
}
