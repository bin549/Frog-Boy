using Godot;
using System;

public partial class Main : Node2D {
    public override void _Ready() {
        base._Ready();
        RenderingServer.SetDefaultClearColor(Colors.LightBlue);
    }

    public override void _Input(InputEvent @event) {
        base._Input(@event);
        if (Input.IsActionJustPressed("ui_cancel")) {
            GD.Print("UI cancel");
        }
    }
}