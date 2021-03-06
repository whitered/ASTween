package ru.whitered.tween.tweens 
{
	import ru.whitered.signaller.Signal;
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
		
		
		private const _onUpdate:Signaller = new Signaller();
		public const onUpdate:Signal = _onUpdate.signal;

		
		
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
		private var offset:uint = 0;
		
		private var positionFrom:Number = 0;
		private var positionTo:Number = 1;

		
		
		/**
		 * @param duration in milliseconds
		 */
		public function TimeTween(duration:uint) 
		{
			this.duration = duration;
		}
		
		
		
		public function setInterval(begin:Number, end:Number):void
		{
			this.positionFrom = begin;
			this.positionTo = end;
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
			if(_isPlaying || offset >= duration) return false;
			
			_isPlaying = true;
			update(offset, _pulse.currentTime);
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
			update(offset + timer - lastSyncronization, timer);
		}

		
		
		public function get isPlaying():Boolean
		{
			return _isPlaying;
		}

		
		
		public function get onComplete():ISignal
		{
			return _onComplete.signal;
		}
		
		
		
		public function get position():Number
		{
			return positionFrom + (positionTo - positionFrom) * offset / duration;
		}
		
		
		
		public function set position(value:Number):void
		{
			if(isNaN(value)) value = positionFrom;
			const progress:Number = (value - positionFrom) / (positionTo - positionFrom);
			update(progress * duration, _pulse.currentTime);
		}
		
		
		
		private function update(offset:uint, lastSynchronization:uint):void
		{
			this.offset = offset; 
			this.lastSyncronization = lastSynchronization;
			
			_onUpdate.dispatch(this);
			
			if(_isPlaying && offset >= duration)
			{
				stop();
				_onComplete.dispatch(this);
			}
		}
	}
}
