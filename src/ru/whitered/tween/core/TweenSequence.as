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

		
		
		public function TweenSequence(tweens:Vector.<ITween>) 
		{
			for each(var tween:ITween in tweens)
			{
				add(tween);
			}
		}
		
		
		
		public function add(tween:ITween, beforeTween:ITween = null):void
		{
			
			if(beforeTween)
			{
				const index:int = tweens ? tweens.indexOf(beforeTween) : -1;
				if(index == -1) return;
				tweens.splice(index, 0, tween);
			}
			else
			{
				tweens ||= new Vector.<ITween>();
				tweens.push(tween);
			}
		}
		
		
		
		public function remove(tween:ITween):void
		{
			const index:int = tweens ? tweens.indexOf(tween) : -1;
			if(index == -1) return;
			
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
		}

		
		
		public function start():void
		{
			if(_isPlaying || !tweens || tweens.length == 0) return;
			
			_isPlaying = true;
			startTween(currentTween || tweens[0]);
		}
		
		
		
		private function startTween(tween:ITween):void
		{	
			currentTween = tween;
			currentTween.start();
			currentTween.onComplete.add(handleCurrentTweenComplete);
			
			if(!currentTween.isPlaying)
			{
				startNextTween();
			}
		}

		
		
		private function handleCurrentTweenComplete(tween:ITween):void 
		{
			startNextTween();
		}

		
		
		private function startNextTween():void 
		{
			const nextIndex:int = tweens.indexOf(currentTween) + 1;
			if(nextIndex >= tweens.length)
			{
				stop();
				_onComplete.dispatch(this);
			}
			else
			{
				currentTween.onComplete.remove(handleCurrentTweenComplete);
				startTween(tweens[nextIndex]);
			}
		}

		
		
		public function stop():void
		{
			if(!_isPlaying) return;
			
			_isPlaying = false;
			currentTween.onComplete.remove(handleCurrentTweenComplete);
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
