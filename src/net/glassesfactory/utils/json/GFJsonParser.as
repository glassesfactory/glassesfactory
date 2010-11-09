/*////////////////////////////////////////////

glassesfactory

Autor	YAMAGUCHI EIKICHI
(@glasses_factory)
Date	2010/08/31

Copyright 2010 glasses factory
http://glasses-factory.net

/*////////////////////////////////////////////

package net.glassesfactory.utils.json
{
	internal class GFJsonParser
	{
		
		/*/////////////////////////////////
		* public methods
		/*/////////////////////////////////
		
		//Constractor
		public function GFJsonParser(){}
		
		public static function decode( source:String, reviver:* ):*
		{
			_text = source;
			_ch = ' ';
			_position = 0;
			_nextValue();
			_value = _parseValue();
			return _value;
		}
		
		
		/*/////////////////////////////////
		* private methods
		/*/////////////////////////////////
		
		private static function _parseValue():*
		{
			_white();
			switch( _ch ){
				case '{':
					return _parceObject();
				case '[':
					return _array();
				case '"':
					return _string();
				case '-':
					return _number();
				default:
					return (_ch >= '0' && _ch <= '9') ? _number() : _word();
			}
		}
		
		private static function _white():void
		{
			while( _ch && _ch <= ' ')
			{
				_nextValue();
			}
		}
		
		private static function _nextValue( c:* = null ):String
		{
			if(c && c !== _ch)
			{
				_error("Expected '" + c + "' instead of '" + _ch + "'");
			}
		//	trace( _ch );
			_ch = _text.charAt( _position );
			_position++;
			return _ch;
		}
		
		
		
		private static function _parceObject():Object
		{
			var key:String;
			var obj:Object = {};
			if( _ch === '{')
			{
				_nextValue('{');
				_white();
				if( _ch === '}')
				{
					_nextValue('}');
					return obj;
				}
				
				while( _ch )
				{
					key = _string();
					_white();
					_nextValue(':');
					obj[key] = _parseValue();
					_white();
					if( _ch === '}')
					{
						_nextValue('}');
						return obj;
					}
					_nextValue(',');
					_white();
				}
			}
			_error("Bad object");
			return null;
		}
		
		private static function _array():Array
		{
			var array:Array = [];
			//trace( "in Array");
			if( _ch === '[')
			{
				_nextValue('[');
				_white();
				
				if(_ch === ']')
				{
					_nextValue(']');
					return array;
				}
				
				while( _ch )
				{
					array.push( _parseValue() );
					_white();
					if( _ch === ']' )
					{
						_nextValue(']');
						return array;
					}
					_nextValue(',');
					_white();
				}
			}
			_error("Bad array");
			return null;
		}
		
		
		private static function _string():*
		{
			var hex:int;
			var str:String = '';
			var i:int = 0;
			var uffff:int;
			if( _ch === '"'){
				while( _nextValue() )
				{
					if( _ch === '"')
					{
						_nextValue();
						return str;
					}
					else if( _ch === '\\'){
						_nextValue();
						if( _ch === 'u'){
							uffff = 0;
							for( i = 0; i < 4; i+=1){
								hex = parseInt( _nextValue(), 16);
								if( !isFinite(hex) ){
									break;
								}
								uffff = uffff * 16 + hex;
							}
							str += String.fromCharCode(uffff);
						}
						else if( typeof escapee[_ch] === 'string'){
							str += escapee[_ch];
						}
						else{
							break;
						}
					}
					else{
						str += _ch;
					}
				}
			}
			_error("Bad string");
			//return null;
		}
		
		private static function _number():*
		{
			var number:Number = 0;
			var string:String = '';
			
			if( _ch === '-'){
				string = '-';
				_nextValue('-');
			}
			
			while( _ch >= '0' && _ch <= '9')
			{
				string += _ch;
				_nextValue();
			}
			if( _ch === '.')
			{
				string += '.';
				while( _nextValue() && _ch >= '0' && _ch <= '9')
				{
					string += _ch;
				}
			}
			
			if( _ch === 'e' || _ch === 'E')
			{
				string += _ch;
				_nextValue();
				if( _ch === '-' || _ch === '+')
				{
					string += _ch;
					_nextValue();
				}
				
				while( _ch >= '0' && _ch <= '9')
				{
					string += _ch;
					_nextValue();
				}
			}
			
			number += Number(string);
			if(isNaN(number))
			{
				_error("Bad number");
			}
			else
			{
				return number;
			}
		}
		
		private static function _word():*
		{
			switch( _ch )
			{
				case 't':
					_nextValue('t');
					_nextValue('r');
					_nextValue('u');
					_nextValue('e');
					return true;
				case 'f':
					_nextValue('f');
					_nextValue('a');
					_nextValue('l');
					_nextValue('s');
					_nextValue('e');
					return false;
				case 'n':
					_nextValue('n');
					_nextValue('u');
					_nextValue('l');
					_nextValue('l');
					return null;
			}
			_error("Unexpected '" + _ch + "'");

		}
		
		
		private static function _error( msg:* ):void
		{
			var message:Object = {
				Error:"SyntaxError",
				m:msg.toString(),
				at:_position,
				text:_text
			}
			throw new Error(_position.toString());
		}

		
		/*/////////////////////////////////
		* private variables
		/*/////////////////////////////////
		
		private static var _ch:String = ' ';
		
		//テキスト位置
		private static var _position:int;
		
		//操作するテキスト
		private static var _text:String;
		
		private static var _value:*;
		
		private static var escapee:Object = {
			'"' : '"',
			'\\': '\\',
			'/' : '/',
			b   : 'b',
			f   : 'f',
			n   : 'n',
			r   : 'r',
			t   : 't'
		};
	}
}