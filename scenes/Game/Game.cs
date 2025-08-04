using Godot;

public partial class Game : Node2D {
    [Export] private Area2D deathLine;

    public override void _Ready() {
        RenderingServer.SetDefaultClearColor(new Color(0.53f, 0.81f, 0.92f));

        if (deathLine != null)
            deathLine.BodyEntered += OnDeathLineBodyEntered;
    }

    private void OnDeathLineBodyEntered(Node body) {
        if (body is Player)
            GetTree().ReloadCurrentScene();
    }
}