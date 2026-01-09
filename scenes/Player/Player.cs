using Godot;
using System;

public partial class Player : CharacterBody2D {
    private float gravity = ProjectSettings.GetSetting("physics/2d/default_gravity").AsSingle();
    [Export] private float speed = 200f;
    [Export] private float jumpForce = 200f;
    private Sprite2D sprite;

    public override void _Ready() {
        base._Ready();
        this.sprite = GetNode<Sprite2D>("Sprite");
    }

    public override void _PhysicsProcess(double delta) {
        base._PhysicsProcess(delta);
        Vector2 velocity = Velocity;
        if (!IsOnFloor()) {
            velocity.Y += this.gravity * (float)delta;
        }
        if (Input.GetActionStrength("jump") > 0 && IsOnFloor()) {
            velocity.Y = -jumpForce;
        }
        float direction = Input.GetAxis("move_left", "move_right");
        if (direction != 0 && IsOnFloor()) {
            velocity.X = this.speed * direction;
            this.sprite.FlipH = direction > 0;
        } else {
            velocity.X = Mathf.MoveToward(velocity.X, 0, this.speed);
        }
        Velocity = velocity;
        MoveAndSlide();
    }
}