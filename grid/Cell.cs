using System.Collections.Generic;
using Godot;

namespace Grid
{
    public enum Visible {
        dark = 0,
        visible = 1,
        fog = 2
    }
    public class Cell : Reference {
        public Visible visible {get; private set;} = Visible.dark;
        public int depth {get; private set;} = 0;
        public int type {get; private set;} = 0;
        public int damage {get; private set;} = 0;
    }
}