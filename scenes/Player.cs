using Godot;
using System;

public partial class Player : CharacterBody2D {
	private const float RUN_SPEED = 120.0f;
	[Export] private AnimatedSprite2D _sprite2D;
	
	public override void _PhysicsProcess(double delta) { 
		Velocity = GetInput((float)delta);
		MoveAndSlide();
	}

	private Vector2 GetInput(float delta) {
		Vector2 newVelocity = Velocity;
		newVelocity.X = 0;
		if (Input.IsActionPressed("left")) {
			newVelocity.X = -RUN_SPEED;
			_sprite2D.FlipH = true;
		}
		if (Input.IsActionPressed("right")) {
			newVelocity.X = RUN_SPEED;
			_sprite2D.FlipH = false;
		}
		return newVelocity;
	}
}
