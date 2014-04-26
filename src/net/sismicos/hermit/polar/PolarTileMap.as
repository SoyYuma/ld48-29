package net.sismicos.hermit.polar 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import org.flixel.FlxObject;
	import org.flixel.FlxG;
	
	public class PolarTileMap extends FlxObject
	{
		private var tiles:Array;
		private var isDirty:Boolean = true;
		private var buffers:Array;
		
		public function PolarTileMap() 
		{
			const numTiles:uint = PolarAux.numAngles * PolarAux.numRadii;
			tiles = new Array(numTiles);
			buffers = new Array();
		}
		
		public function LoadMap(image:Class):void
		{
			var tempBM:BitmapData = FlxG.addBitmap(image);
			if (!PolarAux.IsBitmapALevel(tempBM))
				throw new Error("Trying to load a bitmap that does not represent a level.");
			
			for (var i:uint = 0; i < tempBM.height; ++i)
			{
				for (var j:uint = 0; j < tempBM.width; ++j)
				{
					var r:uint = tempBM.height - i - 1;
					var p:uint = j;
					
					if (tempBM.getPixel(j, i) != 0xFFFFFF)
					{
						AddTile(r, p, new PolarTile(r, p));
					}
				}
			}
		}
		
		public function AddTile(r:uint, p:uint, tile:PolarTile):void
		{
			const index:uint = p * PolarAux.numRadii + r;
			tiles[index] = tile;
		}
		
		override public function draw():void
		{
			super.draw();
			
			if (isDirty) UpdateBuffers();
			
			for (var c:int; c < cameras.length; ++c)
			{
				cameras[c].buffer.copyPixels(buffers[c], buffers[c].rect, new Point(0, 0));
			}
		}
		
		private function UpdateBuffers():void
		{
			if (!visible) return;
			
			for (var c:int = 0; c < cameras.length; ++c)
			{
				if (!buffers[c])
				{
					buffers[c] = new BitmapData(FlxG.width, FlxG.height, true, 0x444444);
				}
				var buffer:BitmapData = buffers[c];
				
				for (var i:int = 0; i < tiles.length; ++i)
				{
					if (tiles[i])
					{
						buffer.draw(tiles[i].s);
					}
				}
			}
			
			isDirty = false;
		}
	}

}