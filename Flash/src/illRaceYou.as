package
{
	import com.illraceyou.model.box2dworld.Box2dWorldController;
	import com.illraceyou.model.cars.car.Box2DCar;
	
	import flash.display.Sprite;
	
	
	public class illRaceYou extends Sprite
	{
		public function illRaceYou()
		{
			var world:Box2dWorldController = new Box2dWorldController(this);
			
			var car:Box2DCar = new Box2DCar(world.world);
			
			world.setUserCar(car);
		}
	}
}