/*////////////////////////////////////////////

GlassesFrame

Autor	YAMAGUCHI EIKICHI
(@glasses_factory)
Date	2010/12/07

Copyright 2010 glasses factory
http://glasses-factory.net

/*////////////////////////////////////////////

package net.glassesfactory.pools
{
	import flash.utils.Dictionary;

	public class GFObjectPool
	{
		/*/////////////////////////////////
		* public methods
		/*/////////////////////////////////
		
		//Constractor
		public function GFObjectPool( caller:Function = null )
		{
			if( caller != GFObjectPool.getInstance )
			{
				throw new Error( "直接インスタンス化は出来ません。");
			}
			else if( _objectPool != null )
			{
				throw new Error( "二つもつくれません" );
			}
			
			_poolDict = new Dictionary();
			_classList = [];
		}
		
		
		/**
		 * ObjectPoolは直接インスタンス化出来ないため、getInstanceから呼び出して使用します。 
		 * @return 
		 * 
		 */		
		public static function getInstance():GFObjectPool
		{
			if( _objectPool == null )
			{
				_objectPool = new GFObjectPool( arguments.callee );
			}
			return _objectPool;
		}
		
		
		/**
		 * インスタンスをクラスごとに格納しているプールを引っ張ります。
		 * @param className
		 * @return 
		 */		
		public function getPool( className:Class ):Array
		{
			var pool:Array = _poolDict[className];
			if( !pool )
			{
				registerClass( className );
			}
			return pool;
		}
		
		
		/**
		 * 指定したクラスのインスタンスを要求します。 
		 * @param className
		 * @return 
		 */		
		public function request( className:Class ):Object
		{
			var obj:Object;
			var pool:Array = getPool( className );
			
			if( pool.length )
			{
				obj = pool.pop();
			}
			else
			{
				obj = new className();
			}
			return obj;
		}
		
		
		/**
		 * ランダムにインスタンスを要求します。 
		 * @return 
		 * 
		 */		
		public function requestByRandom():Object
		{
			var i:int = int( Math.random() * _classList.length );
			return request( _classList[i] );
		}
		
		
		/**
		 * クラスを登録します。
		 * @param className	登録したいクラス名
		 * @param severity	重要度付け。この値をあげるとランダム生成した際、出現率が上がります。
		 * @return 
		 */		
		public function registerClass( className:Class, severity:uint = 1 ):Boolean
		{
			var pool:Array = _poolDict[className];
			if( !pool )
			{
				_poolDict[className] = [];
				for( var i:int = 0; i < severity; i++ )
				{
					_classList.push( className );
					
				}
				++_length;
				return true;
			}
			return false;
		}
		
		
		/**
		 * まとめてクラスを登録します。 
		 * @param args
		 * 
		 */		
		public function registerClasses( ...args):void
		{
			for ( var i:int = 0; i < args.length; i++ )
			{
				registerClass( args[i] );
			}
		}
		
		
		/**
		 * オブジェクトをプールに突っ込みます。
		 * @param obj
		 * @return 既にオブジェクトがプールにあるかどうか。
		 */		
		public function returnPool( obj:Object ):Boolean
		{
			var className:Class = obj["constructor"] as Class;
			var pool:Array = getPool( className );
			
			var hasObj:Boolean = false;
			if( !pool.length )
			{
				pool.push( obj );
				return hasObj;
			}
			
			for ( var i:int = 0; i < pool.length; i++ )
			{
				if( pool[i] == obj )
				{
					return hasObj = true;
				}
			}
			
			if( !hasObj )
			{
				pool.push( obj );
			}
			
			return hasObj;
		}
		
		
		/**
		 * poolの中身を空にします。 
		 */		
		public function clear():void
		{
			while( _length > 0 )
			{
				var className:Class = _classList.pop();
				if( _poolDict[className] ){ delete _poolDict[className]; }
				--_length;
			}
			_classList = [];
		}
		
		
		/*/////////////////////////////////
		* private variables
		/*/////////////////////////////////
		
		private static var _objectPool:GFObjectPool;
		private var _poolDict:Dictionary;
		private var _classList:Array;
		private var _length:int = 0;
	}
}