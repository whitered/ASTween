package ru.whitered.tween.pulse 
{
	import flash.utils.getTimer;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import ru.whitered.signaller.Signaller;
	import ru.whitered.signaller.ISignal;

	/**
	 * @author whitered
	 */
	public class TimerPulse implements IPulse 
	{
		private const signaller:Signaller = new Signaller();
		private var timer:Timer;
		
		
		public function TimerPulse(interval:uint) 
		{
			timer = new Timer(interval);
			timer.addEventListener(TimerEvent.TIMER, handleTimer);
			timer.start();
		}

		
		
		private function handleTimer(event:TimerEvent):void 
		{
			signaller.dispatch(currentTime);
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
