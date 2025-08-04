using Godot;

public partial class Player : CharacterBody2D {
    private const float RunSpeed = 130f;
    private const float GroundAccel = 800f;
    private const float AirAccel = 600f;
    private const float JumpForce = -320f;
    private const float Gravity = 1200f;
    private const float CoyoteTime = 0.1f;
    private const float JumpBufferTime = 0.1f;
    private const float DashSpeed = 320f;
    private const float DashDuration = 0.05f;

    [Export] private AnimatedSprite2D sprite;

    private float coyoteTimer;
    private float jumpBufferTimer;
    private bool canDash = true;
    private bool isDashing = false;
    private float dashTimer;
    private Vector2 dashDirection = Vector2.Zero;

    public override void _PhysicsProcess(double delta) {
        float dt = (float)delta;
        Vector2 velocity = Velocity;

        if (isDashing) {
            velocity = HandleDash(dt);
        } else {
            velocity = ApplyGravity(velocity, dt);
            HandleInputBuffer();
            velocity = HandleMovement(velocity, dt);
            velocity = HandleJump(velocity);
            velocity = TryStartDash(velocity);
        }
        UpdateAnimation(velocity);
        UpdateTimers(dt);
        Velocity = velocity;
        MoveAndSlide();
    }

    private Vector2 ApplyGravity(Vector2 velocity, float dt) {
        if (!IsOnFloor())
            velocity.Y += Gravity * dt;
        else {
            coyoteTimer = CoyoteTime;
            canDash = true;
        }
        return velocity;
    }

    private void HandleInputBuffer() {
        if (Input.IsActionJustPressed("jump"))
            jumpBufferTimer = JumpBufferTime;
    }

    private Vector2 HandleMovement(Vector2 velocity, float dt) {
        float targetSpeed = 0f;
        if (Input.IsActionPressed("left")) {
            targetSpeed = -RunSpeed;
            sprite.FlipH = true;
        } else if (Input.IsActionPressed("right")) {
            targetSpeed = RunSpeed;
            sprite.FlipH = false;
        }

        float accel = IsOnFloor() ? GroundAccel : AirAccel;
        velocity.X = Mathf.MoveToward(velocity.X, targetSpeed, accel * dt);

        return velocity;
    }

    private Vector2 HandleJump(Vector2 velocity) {
        if (jumpBufferTimer > 0 && coyoteTimer > 0) {
            velocity.Y = JumpForce;
            jumpBufferTimer = 0;
            coyoteTimer = 0;
        }
        return velocity;
    }

    private Vector2 TryStartDash(Vector2 velocity) {
        if (Input.IsActionJustPressed("dash") && canDash) {
            canDash = false;
            isDashing = true;
            dashTimer = DashDuration;
            dashDirection = GetDashDirection();
            return dashDirection * DashSpeed;
        }
        return velocity;
    }

    private Vector2 HandleDash(float dt) {
        dashTimer -= dt;
        if (dashTimer <= 0) {
            isDashing = false;
            return Velocity;
        }
        return dashDirection * DashSpeed;
    }

    private Vector2 GetDashDirection() {
        Vector2 dir = Vector2.Zero;
        if (Input.IsActionPressed("up")) dir.Y = -1;
        if (Input.IsActionPressed("down")) dir.Y = 1;
        if (Input.IsActionPressed("left")) dir.X = -1;
        if (Input.IsActionPressed("right")) dir.X = 1;

        if (dir == Vector2.Zero)
            dir.X = sprite.FlipH ? -1 : 1;

        return dir.Normalized();
    }

    private void UpdateAnimation(Vector2 velocity) {
        if (!IsOnFloor())
            sprite.Play("jump");
        else if (Mathf.Abs(velocity.X) > 5)
            sprite.Play("run");
        else
            sprite.Play("idle");
    }

    private void UpdateTimers(float dt) {
        jumpBufferTimer -= dt;
        coyoteTimer -= dt;
    }
}