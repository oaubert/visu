package com.ithaca.utils
{
	public class StringUtils
	{
		public static function cap(value:String):String
		{
			if(!value)
				return value;
				
			var s:String = value.toLowerCase();
			var firstChar:String = s.charAt(0);
		
			if(firstChar) 
				return s.replace(firstChar, firstChar.toUpperCase());
			else
				return value;
		}
		
		public static function firstLetterCap(value:String):String
		{
			if(!value)
				return value;
				
			var firstChar:String = value.charAt(0);
		
			if(firstChar) 
				return firstChar.toUpperCase();
			else
				return value;
		}
		
	}
}