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
            ToggleFullscreen();
        }
    }

    private static void ToggleFullscreen() {
        DisplayServer.WindowMode mode = DisplayServer.WindowGetMode();
        bool isFullscreen = mode == DisplayServer.WindowMode.Fullscreen
            || mode == DisplayServer.WindowMode.ExclusiveFullscreen;
        DisplayServer.WindowSetMode(isFullscreen
            ? DisplayServer.WindowMode.Windowed
            : DisplayServer.WindowMode.Fullscreen);
    }
}   