using Godot;

public partial class Dust : AnimatedSprite2D {
    public override void _Ready() {
        Play();
        AnimationFinished += OnAnimationFinished;
    }

    private void OnAnimationFinished() {
        QueueFree();
    }
}