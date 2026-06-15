using Godot;
using System;

public partial class Cat : Area2D {
    [Export] private Sprite2D tipDialog;
    
    public override void _Ready() {
        base._Ready();
        BodyEntered += OnBodyEntered;
        BodyExited += OnBodyExited;
    }

    private void OnBodyEntered(Node node) {
        if (node.Name == "Player") {
            this.tipDialog.Show();
        }
    }

    private void OnBodyExited(Node node) {
        if (node.Name == "Player") {
            this.tipDialog.Hide();
        }
    }
}