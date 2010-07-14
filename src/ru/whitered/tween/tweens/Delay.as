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
		
		
		
		private var duration:uint;
		private var timer:Timer;
		
		private var _isPlaying:Boolean = false;
		
		
		
		/**
		 * @param duration in milliseconds
		 */
		public function Delay(duration:uint) 
		{
			this.duration = duration;
		}

		
		
		public function start():Boolean
		{
			if(_isPlaying) return false;
			
			
			if(!timer)
			{
				timer = new Timer(duration, 1);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, handleTimerComplete);
			}
			timer.start();
			
			_isPlaying = true;
			return true;
		}
		
		
		
		public function stop():Boolean
		{
			if(!_isPlaying) return false;
			
			_isPlaying = false;
			
			timer.stop();
			return true;
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
