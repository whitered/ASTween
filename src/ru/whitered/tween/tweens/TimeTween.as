package ru.whitered.tween.tweens 
{
	import ru.whitered.signaller.Signaller;
	import ru.whitered.signaller.ISignal;
	import ru.whitered.tween.core.ITween;
	import ru.whitered.tween.pulse.IPulse;
	import ru.whitered.tween.pulse.PulseGenerator;

	/**
	 * @author whitered
	 */
	public class TimeTween implements ITween  
	{
		private static var _defaultPulse:IPulse = PulseGenerator.enterFrame;

		
		
		public static function get defaultPulse():IPulse
		{
			return _defaultPulse;
		}
		
		
		
		public static function set defaultPulse(value:IPulse):void
		{
			if(value) _defaultPulse = value;
		}

		
		
		private const _onComplete:Signaller = new Signaller();
		
		private var _pulse:IPulse = _defaultPulse;
		
		private var _isPlaying:Boolean = false;

		private var duration:uint;
		private var lastSyncronization:uint = 0;
		private var position:uint = 0;

		
		
		/**
		 * @param duration in milliseconds
		 */
		public function TimeTween(duration:uint) 
		{
			this.duration = duration;
		}
		
		
		
		public function get pulse():IPulse
		{
			return _pulse;
		}
		
		
		
		public function set pulse(value:IPulse):void
		{
			if(_isPlaying)
			{
				stop();
				_pulse = value;
				start();
			}
			else
			{
				_pulse = value;
			}
		}
		
		
		
		public function start():Boolean
		{
			if(_isPlaying || position >= duration) return false;
			
			_isPlaying = true;
			lastSyncronization = _pulse.currentTime;
			_pulse.signal.add(handlePulse);
			
			return true;
		}
		
		
		
		public function stop():Boolean
		{
			if(!_isPlaying) return false;
			
			_isPlaying = false;
			_pulse.signal.remove(handlePulse);
			
			return true;
		}
		
		
		
		public function rewind():void
		{
			update(0, _pulse.currentTime);
		}

		
		
		private function handlePulse(timer:int):void
		{
			update(position + timer - lastSyncronization, timer);
		}

		
		
		public function get isPlaying():Boolean
		{
			return _isPlaying;
		}

		
		
		public function get onComplete():ISignal
		{
			return _onComplete.signal;
		}
		
		
		
		public function get progress():Number
		{
			return position / duration;
		}
		
		
		
		public function set progress(value:Number):void
		{
			if(isNaN(value) || value < 0) value = 0;
			else if(value > 1) value = 1;
			
			update(value * duration, _pulse.currentTime);
		}
		
		
		
		private function update(position:uint, lastSynchronization:uint):void
		{
			this.position = position; 
			this.lastSyncronization = lastSynchronization;
			
			if(_isPlaying && position >= duration)
			{
				stop();
				_onComplete.dispatch(this);
			}
		}
	}
}
