using Godot;
using System;

public partial class Player : CharacterBody2D {
    [Export] public float Speed { get; set; } = 300.0f;
    [Export] public float JumpVelocity { get; set; } = -500.0f;

    private AnimatedSprite2D sprite;
    private float gravity = 980.0f;

    public override void _Ready() {
        sprite = GetNode<AnimatedSprite2D>("AnimatedSprite2D");
    }

    public override void _PhysicsProcess(double delta) {
        if (!IsOnFloor()) {
            Velocity = new Vector2(Velocity.X, Velocity.Y + gravity * (float)delta);
        }
        if (Input.IsActionJustPressed("jump") && IsOnFloor()) {
            Velocity = new Vector2(Velocity.X, JumpVelocity);
        }
        float direction = Input.GetAxis("move_left", "move_right");
        if (direction != 0) {
            sprite.FlipH = (direction == -1);
        }
        if (direction != 0) {
            Velocity = new Vector2(direction * Speed, Velocity.Y);
        } else {
            Velocity = new Vector2(Mathf.MoveToward(Velocity.X, 0, Speed), Velocity.Y);
        }
        MoveAndSlide();
        UpdateAnimations();
    }

    private void UpdateAnimations() {
        if (Velocity.Y < 0) {
            sprite.Play("jump");
        } else if (Velocity.Y > 0) {
            sprite.Play("fall");
        } else {
            if (Velocity.X != 0) {
                sprite.Play("run");
            } else {
                sprite.Play("idle");
            }
        }
    }
}
