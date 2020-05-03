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

        private readonly int x;
        private readonly int y;
        private readonly int chunk_size;

        public Visible visible {get; private set;} = Visible.dark;
        public int depth {get; private set;} = 0;
        public int type {get; private set;} = 0; //TODO create type-db
        public int damage {get; private set;} = 0;


        //Track if Cell has changed and must be regenerated in next frame
        private Visible visibleInNextFrame = Visible.dark;
        private int depthInNextFrame = 0;
        private int damageInNextFrame = 0;

        public Cell(int x, int y, int chunk_size) {
            self.x = x;
            self.y = y;
            self.chunk_size = chunk_size;
        }

        //TODO: track state for current and next frame
        public void SetToFogIfVisibleInNextFrame() {
            if (visible == Visible.visible) {
                visibleInNextFrame = Visible.fog;
            }
        }

        public void SetToVisibleInNextFrame() {
            visibleInNextFrame = Visible.visible;
        }

        public void SetToVisibleIfFogInNextFrame() {
            if (visible = Visible.fog) {
                visibleInNextFrame = Visible.visible;
            }
        }

        public void TakeDamgeInNextFrame(int amt) {
            damageInNextFrame = damage + amt; //Prevent multi damage per frame

            if (damageInNextFrame >= MAX_DAMAGE) {
                depthInNextFrame += 1;
                damageInNextFrame = 0;
            }
        }

        public bool UpdateInNextFrame(bool reset = true) {
            if (visible != visibleInNextFrame || depth != depthInNextFrame || damage != damageInNextFrame) {
                if (reset) {
                    visible = visibleInNextFrame;
                    depth = depthInNextFrame;
                    damage = damageInNextFrame;
                }
                return true;
            } else {
                return false;
            }
        }
    }
}