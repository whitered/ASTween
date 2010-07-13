package ru.whitered.tween.tweens 
{
	import ru.whitered.tween.core.ITween;
	import ru.whitered.signaller.Signaller;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import ru.whitered.signaller.ISignal;

	/**
	 * @author whitered
	 */
	public class Delay implements ITween 
	{
		private const _onComplete:Signaller = new Signaller();
		
		
		
		private var duration:Number;
		private var timer:Timer;
		
		private var _isPlaying:Boolean = false;
		
		
		
		public function Delay(duration:Number) 
		{
			this.duration = duration || 0;
		}

		
		
		public function start():void
		{
			if(_isPlaying) return;
			
			_isPlaying = true;
			
			if(!timer)
			{
				timer = new Timer(duration, 1);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, handleTimerComplete);
			}
			timer.start();
		}
		
		
		
		public function stop():void
		{
			if(!_isPlaying) return;
			
			_isPlaying = false;
			
			timer.stop();
		}

		
		
		private function handleTimerComplete(event:TimerEvent):void 
		{
			stop();
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, handleTimerComplete);
			timer = null;
			
			_onComplete.dispatch(this);
		}

		
		
		public function rewind():void
		{
			if(timer)
			{
				timer.reset();
				
				if(_isPlaying)
				{
					timer.start();
				}
			}
			
		}
		
		
		
		public function get isPlaying():Boolean
		{
			return _isPlaying;
		}

		
		
		public function get onComplete():ISignal
		{
			return _onComplete.signal;
		}
	}
}
