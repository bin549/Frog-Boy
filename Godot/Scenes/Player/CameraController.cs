using Godot;

public partial class CameraController : Camera2D {
    [Export] private float followSpeed = 10f;
    [Export] private float lookaheadX = 28f;
    [Export] private float lookaheadY = 20f;
    [Export] private float lookaheadSpeed = 4f;
    private Player player;
    private Vector2 lookahead;

    public override void _Ready() {
        TopLevel = true;
        player = GetParent<Player>();
        if (player != null) {
            GlobalPosition = player.GlobalPosition;
        }
    }

    public override void _PhysicsProcess(double delta) {
        if (player == null) {
            return;
        }
        float dt = (float)delta;
        Vector2 wantLook = new Vector2(
            player.Facing * lookaheadX,
            Input.GetAxis("ui_up", "ui_down") * lookaheadY);
        lookahead = lookahead.Lerp(wantLook, 1f - Mathf.Exp(-lookaheadSpeed * dt));
        Vector2 wantPos = player.GlobalPosition + lookahead;
        GlobalPosition = GlobalPosition.Lerp(wantPos, 1f - Mathf.Exp(-followSpeed * dt));
    }
}
