package ru.whitered.tween.core 
{
	import ru.whitered.signaller.Signaller;
	import ru.whitered.signaller.ISignal;

	/**
	 * @author whitered
	 */
	public class TweenRepeater implements ITween 
	{
		private const _onComplete:Signaller = new Signaller();

		private var tween:ITween;
		
		private var _iterations:uint;
		private var currentIteration:uint = 0;
		private var _isPlaying:Boolean;

		
		
		public function TweenRepeater(tween:ITween, iterations:uint = 1) 
		{
			this.tween = tween;
			_iterations = iterations;
		}

		
		
		public function start():Boolean
		{
			if(_isPlaying || currentIteration >= _iterations) return false;
			_isPlaying = tween.start();
			if(_isPlaying)
			{
				tween.onComplete.add(handleTweenComplete);
			}
			return _isPlaying;
		}

		
		
		private function handleTweenComplete(tween:ITween):void 
		{
			if(++currentIteration < _iterations)
			{
				tween.rewind();
				tween.start();
			}
			else
			{
				_isPlaying = false;
				tween.onComplete.remove(handleTweenComplete);
				_onComplete.dispatch(this);
			}
		}

		
		
		public function stop():Boolean
		{
			if(!_isPlaying) return false;
			if(tween.stop())
			{
				_isPlaying = false;
				tween.onComplete.remove(handleTweenComplete);
			}
			return !_isPlaying;
		}

		
		
		public function rewind():void
		{
			tween.rewind();
			currentIteration = 0;
		}

		
		
		public function get isPlaying():Boolean
		{
			return _isPlaying;
		}
		
		
		
		public function get onComplete():ISignal
		{
			return _onComplete.signal;
		}

		
		
		public function get iterations():uint
		{
			return _iterations;
		}
		
		
		
		public function set iterations(value:uint):void
		{
			_iterations = value;
			if(_isPlaying && currentIteration >= _iterations)
			{
				_isPlaying = false;
				tween.onComplete.remove(handleTweenComplete);
				_onComplete.dispatch(this);
			}
		}
	}
}
