package com.door.ane
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;

	[Event(name="ane_sysc_event", type="com.door.ane.ANESyncEvent")]
	public class ANEHelper extends EventDispatcher
	{
		private static var _instance:ANEHelper;
		private  var extContext:ExtensionContext = null;
		private static const EXTENSION_ID:String ="com.door.ANEManager";
		private var callBack:Function;
		
		public var doorSDK:DoorInterface;

		//sss
		public function ANEHelper(target:IEventDispatcher=null)
		{
			initExtContext();
			super(target);
		}
		private function initExtContext():void{
			if(extContext==null){
				extContext = ExtensionContext.createExtensionContext(EXTENSION_ID,"aneutilmanager");
				extContext.addEventListener(StatusEvent.STATUS,statusHandler);
				doorSDK = new DoorInterface(extContext);
			}
		}
		
		protected function statusHandler(event:StatusEvent):void
		{
			var e:ANESyncEvent = new ANESyncEvent(ANESyncEvent.ANE_SYSC_EVENT);
			e.level = event.level;
			e.code = event.code;
			if(callBack!=null)
			{
				callBack(event.code,event.level);
			}
			this.dispatchEvent(e);
		}
		
		public static function getInstance():ANEHelper{
			if(_instance==null){
				_instance = new ANEHelper();
			}
			return _instance;
		}
		public static function clear():void{
			if(_instance){
				_instance.dispose();
			}
			_instance = null;
		}
		
		public function setCallBack(callback:Function):void
		{
			callBack = callback;
		}
		public function dispose():void{
			if(extContext){
				extContext.removeEventListener(StatusEvent.STATUS,statusHandler);
				doorSDK.dispose();
			}
			extContext = null;
			doorSDK = null;
		}
	}
}