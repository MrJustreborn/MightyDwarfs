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

        private const int MAX_DAMAGE = 5;

        public Visible visible {get; private set;} = Visible.dark;
        public int depth {get; private set;} = 0;
        public int type {get; private set;} = 0;
        public int damage {get; private set;} = 0;


        public void takeDamge(int amt) {
            damage += amt;

            if (damage >= MAX_DAMAGE) {
                depth += 1;
                damage = 0;
            }
        }
    }
}