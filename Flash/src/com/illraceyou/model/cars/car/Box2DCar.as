package com.illraceyou.model.cars.car
{
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2PrismaticJointDef;
	import Box2D.Dynamics.Joints.b2RevoluteJoint;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2World;

	public class Box2DCar
	{
		public const MAX_STEER_ANGLE:Number = Math.PI/4;
		public const STEER_SPEED:Number = 1;
		public const SIDEWAYS_FRICTION_FORCE:Number = .5;
		public const HORSEPOWERS:Number = 10;
		public const CAR_STARTING_POS:b2Vec2 = new b2Vec2(10,10);
		
		
		private const CAR_BODY_WIDTH:Number = .4;
		private const CAR_BODY_HEIGHT:Number = .6;
		private const WHEEL_WIDTH:Number = .05;
		private const WHELL_HEIGHT:Number = .2;
		
		private const leftRearWheelPosition:b2Vec2 = new b2Vec2(-CAR_BODY_WIDTH, CAR_BODY_HEIGHT - .1);
		private const rightRearWheelPosition:b2Vec2 = new b2Vec2(CAR_BODY_WIDTH,CAR_BODY_HEIGHT - .1);
		private const leftFrontWheelPosition:b2Vec2 = new b2Vec2(-CAR_BODY_WIDTH,-CAR_BODY_HEIGHT + .1);
		private const rightFrontWheelPosition:b2Vec2 = new b2Vec2(CAR_BODY_WIDTH,-CAR_BODY_HEIGHT + .1);
		
		private var _engineSpeed:Number =0;
		private var _steeringAngle:Number = 0;
		
		private var _body:b2Body;
			
		private var _leftWheel:b2Body;
		private var _rightWheel:b2Body;
		private var _leftRearWheel:b2Body;
		private var _rightRearWheel:b2Body;
		
		private var _leftJoint:b2RevoluteJoint;
		private var _rightJoint:b2RevoluteJoint;
			
		private var myWorld:b2World;
		
		public function Box2DCar(world:b2World)
		{
			myWorld = world;
			
			// define our body
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.linearDamping = 1;
			bodyDef.angularDamping = 1;
			bodyDef.position = CAR_STARTING_POS.Copy()
			
			_body = myWorld.CreateBody(bodyDef);
			_body.SetMassFromShapes();
			
			var leftWheelDef:b2BodyDef = new b2BodyDef();
			leftWheelDef.position = CAR_STARTING_POS.Copy();
			leftWheelDef.position.Add(leftFrontWheelPosition);
			_leftWheel = myWorld.CreateBody(leftWheelDef);
			
			var rightWheelDef:b2BodyDef = new b2BodyDef();
			rightWheelDef.position = CAR_STARTING_POS.Copy();
			rightWheelDef.position.Add(rightFrontWheelPosition);
			_rightWheel = myWorld.CreateBody(rightWheelDef);
			
			var leftRearWheelDef:b2BodyDef = new b2BodyDef();
			leftRearWheelDef.position = CAR_STARTING_POS.Copy();
			leftRearWheelDef.position.Add(leftRearWheelPosition);
			_leftRearWheel = myWorld.CreateBody(leftRearWheelDef);
			
			var rightRearWheelDef:b2BodyDef = new b2BodyDef();
			rightRearWheelDef.position = CAR_STARTING_POS.Copy();
			rightRearWheelDef.position.Add(rightRearWheelPosition);
			_rightRearWheel = myWorld.CreateBody(rightRearWheelDef);
			
			// define our shapes
			var boxDef:b2PolygonDef = new b2PolygonDef();
			boxDef.SetAsBox(CAR_BODY_WIDTH, CAR_BODY_HEIGHT);
			boxDef.density = 1;
			_body.CreateShape(boxDef);
			
			//Left Wheel shape
			var leftWheelShapeDef:b2PolygonDef = new b2PolygonDef();
			leftWheelShapeDef.SetAsBox(WHEEL_WIDTH,WHELL_HEIGHT);
			leftWheelShapeDef.density = 1;
			_leftWheel.CreateShape(leftWheelShapeDef);
			
			//Right Wheel shape
			var rightWheelShapeDef:b2PolygonDef = new b2PolygonDef();
			rightWheelShapeDef.SetAsBox(WHEEL_WIDTH,WHELL_HEIGHT);
			rightWheelShapeDef.density = 1;
			_rightWheel.CreateShape(rightWheelShapeDef);
			
			//Left Wheel shape
			var leftRearWheelShapeDef:b2PolygonDef = new b2PolygonDef();
			leftRearWheelShapeDef.SetAsBox(WHEEL_WIDTH,WHELL_HEIGHT);
			leftRearWheelShapeDef.density = 1;
			_leftRearWheel.CreateShape(leftRearWheelShapeDef);
			
			//Right Wheel shape
			var rightRearWheelShapeDef:b2PolygonDef = new b2PolygonDef();
			rightRearWheelShapeDef.SetAsBox(WHEEL_WIDTH,WHELL_HEIGHT);
			rightRearWheelShapeDef.density = 1;
			_rightRearWheel.CreateShape(rightRearWheelShapeDef);
			
			_body.SetMassFromShapes();
			_leftWheel.SetMassFromShapes();
			_rightWheel.SetMassFromShapes();
			_leftRearWheel.SetMassFromShapes();
			_rightRearWheel.SetMassFromShapes();
			
			var leftJointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
			leftJointDef.Initialize(_body, _leftWheel, _leftWheel.GetWorldCenter());
			leftJointDef.enableMotor = true;
			leftJointDef.maxMotorTorque = 100;
			
			var rightJointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
			rightJointDef.Initialize(_body, _rightWheel, _rightWheel.GetWorldCenter());
			rightJointDef.enableMotor = true;
			rightJointDef.maxMotorTorque = 100;
			
			_leftJoint = b2RevoluteJoint(myWorld.CreateJoint(leftJointDef));
			_rightJoint = b2RevoluteJoint(myWorld.CreateJoint(rightJointDef));
			
			var leftRearJointDef:b2PrismaticJointDef = new b2PrismaticJointDef();
			leftRearJointDef.Initialize(_body, _leftRearWheel, _leftRearWheel.GetWorldCenter(), new b2Vec2(1,0));
			leftRearJointDef.enableLimit = true;
			leftRearJointDef.lowerTranslation = leftRearJointDef.upperTranslation = 0;
			
			var rightRearJointDef:b2PrismaticJointDef = new b2PrismaticJointDef();
			rightRearJointDef.Initialize(_body, _rightRearWheel, _rightRearWheel.GetWorldCenter(), new b2Vec2(1,0));
			rightRearJointDef.enableLimit = true;
			rightRearJointDef.lowerTranslation = rightRearJointDef.upperTranslation = 0;
			
			myWorld.CreateJoint(leftRearJointDef);
			myWorld.CreateJoint(rightRearJointDef);
		}
		
		public function get body():b2Body
		{
			return _body;
		}
		public function get leftWheel():b2Body
		{
			return _leftWheel;
		}
		public function get rightWheel():b2Body
		{
			return _rightWheel;
		}
		public function get leftRearWheel():b2Body
		{
			return _leftRearWheel;
		}
		public function get rightRearWheel():b2Body
		{
			return _rightRearWheel;
		}
		public function get engineSpeed():Number
		{
			return _engineSpeed;
		}
		public function set engineSpeed(value:Number):void
		{
			_engineSpeed = value;
		}
		public function get steeringAngle():Number
		{
			return _steeringAngle;
		}
		public function set steeringAngle(value:Number):void
		{
			_steeringAngle = value;
		}
		public function get leftJoint():b2RevoluteJoint
		{
			return _leftJoint;
		}
		public function get rightJoint():b2RevoluteJoint
		{
			return _rightJoint;
		}
	}
}