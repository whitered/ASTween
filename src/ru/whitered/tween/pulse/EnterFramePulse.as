package ru.whitered.tween.pulse 
{
	import flash.utils.getTimer;
	import ru.whitered.signaller.ISignal;

	import flash.events.Event;
	import ru.whitered.signaller.Signaller;
	import flash.display.Sprite;

	/**
	 * @author whitered
	 */
	internal class EnterFramePulse implements IPulse 
	{
		private const sprite:Sprite = new Sprite();
		private const signaller:Signaller = new Signaller();
		

		
		public function EnterFramePulse() 
		{
			sprite.addEventListener(Event.ENTER_FRAME, handleEnterFrame);
		}

		
		
		private function handleEnterFrame(event:Event):void 
		{
			signaller.dispatch(getTimer());
		}
		
		
		
		public function get signal():ISignal
		{
			return signaller.signal;
		}
		
		
		
		public function get currentTime():uint
		{
			return getTimer();
		}
	}
}
