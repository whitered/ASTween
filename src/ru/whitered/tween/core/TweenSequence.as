package ru.whitered.tween.core 
{
	import ru.whitered.signaller.Signaller;
	import ru.whitered.signaller.ISignal;

	/**
	 * @author whitered
	 */
	public class TweenSequence implements ITween 
	{
		private const _onComplete:Signaller = new Signaller();
		
		
		private var tweens:Vector.<ITween>;
		
		private var currentTween:ITween;
		private var _isPlaying:Boolean = false;

		
		
		public function TweenSequence(tweens:Vector.<ITween> = null) 
		{
			for each(var tween:ITween in tweens)
			{
				add(tween);
			}
		}
		
		
		
		public function add(tween:ITween, beforeTween:ITween = null):Boolean
		{
			if(tweens && tweens.indexOf(tween) >= 0) return false;
			
			if(beforeTween)
			{
				const index:int = tweens ? tweens.indexOf(beforeTween) : -1;
				if(index == -1) return false;
				tweens.splice(index, 0, tween);
			}
			else
			{
				tweens ||= new Vector.<ITween>();
				tweens.push(tween);
			}
			
			return true;
		}
		
		
		
		public function remove(tween:ITween):Boolean
		{
			const index:int = tweens ? tweens.indexOf(tween) : -1;
			if(index == -1) return false;
			
			if(tween == currentTween)
			{
				if(_isPlaying)
				{
					handleCurrentTweenComplete(currentTween);
				}
				else
				{
					if(tweens.length > 1)
					{
						currentTween = tweens[(index < tweens.length - 1) ? (index + 1) : (index - 1)]; 
					}
					else
					{
						currentTween = null;
					}
				}
			}
			
			tweens.splice(index, 1);
			
			return true;
		}

		
		
		public function start():Boolean
		{
			if(_isPlaying || !tweens || tweens.length == 0) return false;
			
			_isPlaying = startTween(currentTween || tweens[0]);
			return _isPlaying;
		}

		
		
		private function startTween(tween:ITween):Boolean
		{	
			currentTween = tween;
			if(currentTween.start())
			{
				currentTween.onComplete.add(handleCurrentTweenComplete);
				return true;
			}
			else
			{
				return startNextTween();
			}
		}

		
		
		private function handleCurrentTweenComplete(tween:ITween):void 
		{
			tween.onComplete.remove(handleCurrentTweenComplete);
			if(!startNextTween())
			{
				_isPlaying = false;
				_onComplete.dispatch(this);
			}
		}

		
		
		private function startNextTween():Boolean 
		{
			const nextIndex:int = tweens.indexOf(currentTween) + 1;
			if(nextIndex >= tweens.length)
			{
				return false;
			}
			else
			{
				return startTween(tweens[nextIndex]);
			}
		}

		
		
		public function stop():Boolean
		{
			if(!_isPlaying) return false;
			
			_isPlaying = false;
			currentTween.onComplete.remove(handleCurrentTweenComplete);
			return true;
		}

		
		
		public function rewind():void
		{
			for each(var tween:ITween in tweens)
			{
				tween.stop();
				tween.rewind();
			}
			
			if(_isPlaying)
			{
				currentTween.onComplete.remove(handleCurrentTweenComplete);
				startTween(tweens[0]);
			}
			else
			{
				currentTween = null;
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
