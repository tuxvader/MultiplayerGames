package com.illraceyou.model.box2dworld
{
	import Box2D.Collision.b2AABB;
	import Box2D.Common.Math.b2Math;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2World;
	
	import com.illraceyou.model.cars.car.Box2DCar;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	public class Box2dWorldController
	{
		private var _world:b2World;
		private var _cars:Vector.<Box2DCar>;
		private var _worlContainer:Sprite;
		private var _userCar:Box2DCar = null;
		
		public function Box2dWorldController(worldContainer:Sprite)
		{
			
			_cars = new Vector.<Box2DCar>();
			_worlContainer = worldContainer;
			
			var worldBox:b2AABB = new b2AABB();
			worldBox.lowerBound.Set(-100,-100);
			worldBox.upperBound.Set(100,100);
			
			_world = new b2World(worldBox, new b2Vec2(0,0) , true);
			
			// debug draw
			var dbgDraw:b2DebugDraw = new b2DebugDraw();
			dbgDraw.m_sprite = new Sprite();
			worldContainer.addChild(dbgDraw.m_sprite);
			dbgDraw.m_drawScale = 20.0;
			dbgDraw.m_fillAlpha = 0.3;
			dbgDraw.m_lineThickness = 1.0;
			dbgDraw.m_drawFlags = b2DebugDraw.e_shapeBit;// |b2DebugDraw.e_centerOfMassBit;
			_world.SetDebugDraw(dbgDraw);
			
			_worlContainer.addEventListener(Event.ENTER_FRAME, Update);
			_worlContainer.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed_handler);
			_worlContainer.stage.addEventListener(KeyboardEvent.KEY_UP, keyReleased_handler);
			
		}
		
		public function addCar(car:Box2DCar):void
		{
			_cars.push(car);
		}
		
		public function setUserCar(car:Box2DCar):void
		{
			_userCar = car;
		}
		
		//This function applies a "friction" in a direction orthogonal to the body's axis.
		private function killOrthogonalVelocity(targetBody:b2Body):void{
			var localPoint:b2Vec2 = new b2Vec2(0,0);
			var velocity:b2Vec2 = targetBody.GetLinearVelocityFromLocalPoint(localPoint);
			
			var sidewaysAxis:b2Vec2 = targetBody.GetXForm().R.col2.Copy();
			sidewaysAxis.Multiply(b2Math.b2Dot(velocity,sidewaysAxis))
			
			targetBody.SetLinearVelocity(sidewaysAxis);//targetBody.GetWorldPoint(localPoint));
		}
		
		private function keyPressed_handler(e:KeyboardEvent):void {
			if(_userCar != null)
			{
				if(e.keyCode == Keyboard.UP){
					_userCar.body.WakeUp();
					_userCar.engineSpeed = -_userCar.HORSEPOWERS;
				}
				if(e.keyCode == Keyboard.DOWN){
					_userCar.engineSpeed = _userCar.HORSEPOWERS;
				}
				if(e.keyCode == Keyboard.RIGHT){
					_userCar.steeringAngle = _userCar.MAX_STEER_ANGLE
				}
				if(e.keyCode == Keyboard.LEFT){
					_userCar.steeringAngle = -_userCar.MAX_STEER_ANGLE
				}
			}
		}
		
		private function keyReleased_handler(e:KeyboardEvent):void{
			if(_userCar != null)
			{
				if(e.keyCode == Keyboard.UP || e.keyCode == Keyboard.DOWN){
					_userCar.engineSpeed = 0;
				} 
				if(e.keyCode == Keyboard.LEFT || e.keyCode == Keyboard.RIGHT){
					_userCar.steeringAngle = 0;
				}
			}
		}
		
		
		private function Update(e:Event):void {
			_world.Step(1/30, 8);
			
			if(_userCar != null)
			{
				killOrthogonalVelocity(_userCar.leftWheel);
				killOrthogonalVelocity(_userCar.rightWheel);
				killOrthogonalVelocity(_userCar.leftRearWheel);
				killOrthogonalVelocity(_userCar.rightRearWheel);
				
				//Driving
				var ldirection:b2Vec2 = _userCar.leftWheel.GetXForm().R.col2.Copy();
				ldirection.Multiply(_userCar.engineSpeed);
				var rdirection:b2Vec2 = _userCar.rightWheel.GetXForm().R.col2.Copy()
				rdirection.Multiply(_userCar.engineSpeed);
				_userCar.leftWheel.ApplyForce(ldirection, _userCar.leftWheel.GetPosition());
				_userCar.rightWheel.ApplyForce(rdirection, _userCar.rightWheel.GetPosition());
				
				//Steering
				var mspeed:Number;
				mspeed = _userCar.steeringAngle - _userCar.leftJoint.GetJointAngle();
				_userCar.leftJoint.SetMotorSpeed(mspeed * _userCar.STEER_SPEED);
				mspeed = _userCar.steeringAngle - _userCar.rightJoint.GetJointAngle();
				_userCar.rightJoint.SetMotorSpeed(mspeed * _userCar.STEER_SPEED);
			}
		}
		
		public function get world():b2World
		{
			return _world;
		}
	}
}