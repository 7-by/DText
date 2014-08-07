package ;

import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
	
/**
 * Ported from DText.as
 * http://kaioa.com/node/85
 * 
 * @author Artur Shinkarev
 */

/* You need this image: http://kaioa.com/b/0808/console.png */
@:bitmap("src/res/console.png") class CSheet extends BitmapData { }

class DText
{
	private static var DEFAULT_CHAR:Int = '?'.charCodeAt(0);
	
	private static var chars:BitmapData;
	private static var charRects:Array<Rectangle>;
	
	//Static initialization
	static function __init__()
	{
		chars = new CSheet(256, 96);
		charRects = [];
		//for (i in 32...161)
		for (i in 0...129)
		{
			//charRects[i] = new Rectangle(((i - 32) % 16) * 16, Std.int((i - 32) / 16) * 16, 9, 16);
			charRects[i] = new Rectangle((i % 16) * 16, Std.int(i / 16) * 16, 9, 16);
		}
	}
	
	/**
	 * Clear drawable BitmapData before next draw
	 * @param	buffer BitmapData for drawing text
	 * @param	color Color for clearing of background
	 * @param	?rect Rectangle that must be cleared (default is full BitmapData)
	 */
	public static function clearBeforeDraw(buffer:BitmapData, color:UInt, ?rect:Rectangle):Void
	{
		if (rect == null) rect = new Rectangle(0, 0, buffer.width, buffer.height);
		
		buffer.fillRect(rect, color);
	}
	
	/**
	 * Draw text on the bitmap
	 * @param	buffer Drawing target
	 * @param	text Message (may contain '\n')
	 * @param	?x Origin x (default = 0) 
	 * @param	?y Origin y (default = 0)
	 * @param	?align Alignment (Align.Left, Align.Right, or Align.Center) (default = Align.Left)
	 */
	public static function draw(buffer:BitmapData, text:String, ?x:Int, ?y:Int, ?align:Align):Void
	{
		var lines:Array<String> = text.split('\n');
		for (line in lines)
		{
			if (align == null) align = Left;
			
			switch (align) 
			{
				case Align.Left:
					drawLine(buffer, line, x, y);
				case Align.Right:
					drawLine(buffer, line, Std.int(x - line.length * 8), y);
				case Align.Center:
					drawLine(buffer, line, Std.int(x - line.length * 8 / 2), y);
			}
			y += 13;
		}
	}
	
	private static inline function drawLine(buffer:BitmapData, text:String, x:Int, y:Int):Void
	{
		var p:Point = new Point(x, y);
		var len:Int = text.length;
		for (i in 0...len)
		{
			var c:Int = text.charCodeAt(i);
			if (c > 160 || c < 32)
				c = DEFAULT_CHAR;
			buffer.copyPixels(chars, charRects[c - 32], p); //charCode for latin codepage starts from 32
			p.x += 8;
		}
		
	}
	
}

enum Align
{
	Left;
	Right;
	Center;
}