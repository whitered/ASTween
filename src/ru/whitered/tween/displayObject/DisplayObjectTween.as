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
			for each(var modifier:PropertyModifier in modifiers) modifier.init();
			return super.start();
		}
		
		
		
		private function handleUpdate(tween:DisplayObjectTween):void 
		{
			const progress:Number = this.position;
			for each(var modifier:PropertyModifier in modifiers)
			{
				modifier.update(progress);
			}
		}
		
		
		
		private function createModifier(propertyName:String):PropertyModifier
		{
			const modifier:PropertyModifier = modifiers[propertyName] ||= new PropertyModifier(displayObject, propertyName); 
			if(isPlaying) modifier.init();
			return modifier;
		}

		
		
		public function xTo(value:Number):DisplayObjectTween
		{
			createModifier("x").endValue = value;
			return this;
		}

		
		
		public function yTo(value:Number):DisplayObjectTween
		{
			createModifier("y").endValue = value;
			return this;
		}

		
		
		public function alphaTo(value:Number):DisplayObjectTween
		{
			createModifier("alpha").endValue = value;
			return this;
		}
		
		
		
		public function moveTo(x:Number, y:Number):DisplayObjectTween
		{
			createModifier("x").endValue = x;
			createModifier("y").endValue = y;
			return this;
		}
	}
}
