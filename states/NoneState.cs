using Godot;

namespace State
{
    public abstract class NoneState : AbstractState
    {
        public NoneState(Node ctrl) : base(ctrl)
        {
            this.Name = constant.StateNames.NONE;
        }

        public override void building_input_event(Camera camera, InputEvent _event, Vector3 click_position, Vector3 click_normal, int shape_idx, Node building) { }
        public override void dwarf_input_event(Camera camera, InputEvent _event, Vector3 click_position, Vector3 click_normal, int shape_idx, Node dwarf)
        {
            if (_event is InputEventMouseButton)
            {
                var tmpInput = (InputEventMouseButton)_event;
                if (tmpInput.ButtonIndex == 1 && tmpInput.ButtonMask == 0)
                {
                    dwarf.AddToGroup(constant.GroupNames.SELECTED_DWARFS);
                    ctrl.Call("request_new_state", constant.StateNames.SELECT_DWARFS);
                }
            }
        }
        public override void map_input_event(Camera camera, InputEvent _event, Vector3 click_position, Vector3 click_normal, int shape_idx, Vector2 chunk, AStar navigation, Node meshMapCtrl, Node info) { }
    }
}