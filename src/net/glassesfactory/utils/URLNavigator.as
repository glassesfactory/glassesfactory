/*/////////////////////////////////////////////
* glassesfactory
*
* Autor YAMAGUCHI EIKICHI
*	(http://glasses-factory.net/)
* 
* Copyright (c) 2010 glassses factory
*
* 2010/03/27
* 
/*/////////////////////////////////////////////

package net.glassesfactory.utils
{
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class URLNavigator
	{
		
		/*/////////////////////////////////////////////////
		* public variables
		/*/////////////////////////////////////////////////
		
		
		/*/////////////////////////////////////////////////
		* public methods
		/*/////////////////////////////////////////////////
		
		public static function getURL( url:String, window:String = "_self" ):void
		{
			if( !ExternalInterface.available )
			{
				navigateToURL( new URLRequest( url ), window );
			}
			else
			{
				var strUserAgent:String = String( ExternalInterface.call("function() {return navigator.userAgent;}")).toLowerCase();
				if (strUserAgent.indexOf("firefox") != -1 || (strUserAgent.indexOf("msie") != -1 && uint(strUserAgent.substr(strUserAgent.indexOf("msie") + 5, 3)) >= 7))
				{
					ExternalInterface.call( "window.open", url, window );
				}
				else
				{
					navigateToURL(new URLRequest( url ), window );
				}
			}
		}
			
		
		/*/////////////////////////////////////////////////
		* private methods
		/*/////////////////////////////////////////////////
		
		
		/*/////////////////////////////////////////////////
		* private variables
		/*/////////////////////////////////////////////////
	}
}