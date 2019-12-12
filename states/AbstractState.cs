using Godot;

namespace State
{
    public abstract class AbstractState : Reference
    {
        public string Name { set; private get; } = "Abstract";
        protected Node ctrl;

        protected AbstractState(Node ctrl)
        {
            this.ctrl = ctrl;
        }
        public virtual void setup_state()
        {
            GD.Print("Setup state ... ", Name);
        }

        public virtual void teardown_state()
        {
            GD.Print("Teardown state ... ", Name);
        }

        public abstract void building_input_event(Camera camera, InputEvent _event, Vector3 click_position, Vector3 click_normal, int shape_idx, Node building);
        public abstract void dwarf_input_event(Camera camera, InputEvent _event, Vector3 click_position, Vector3 click_normal, int shape_idx, Node dwarf);
        public abstract void map_input_event(Camera camera, InputEvent _event, Vector3 click_position, Vector3 click_normal, int shape_idx, Vector2 chunk, AStar navigation, Node meshMapCtrl, Node info);
    }
}