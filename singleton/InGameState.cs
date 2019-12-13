using Godot;

namespace singleton {
    public class InGameState : Node {
        [Signal]
        delegate void state_changed(string newState);

        public string CURRENT_STATE {get; private set;} = "";

        private State.AbstractState STATE_NONE;
        private State.AbstractState STATE_SELECT_DWARF;
        private State.AbstractState STATE_BUILD_TUNNEL;

        private State.AbstractState state = null;

        public InGameState() {
            STATE_NONE = new State.NoneState(this);
            STATE_SELECT_DWARF = new State.SelectDwarfState(this);
            STATE_BUILD_TUNNEL = new State.BuildTunnelState(this);
        }

        public override void _Ready() {
            this.request_new_state(constant.StateNames.NONE);
        }

        public void _on_building_input_event(Camera camera, InputEvent _event, Vector3 click_position, Vector3 click_normal, int shape_idx, Node building) {
            state.building_input_event(camera, _event, click_position, click_normal, shape_idx, building);
        }

        public void _on_dwarf_input_event(Camera camera, InputEvent _event, Vector3 click_position, Vector3 click_normal, int shape_idx, KinematicBody dwarf) {
            state.dwarf_input_event(camera, _event, click_position, click_normal, shape_idx, dwarf);
        }

        public void _on_map_input_event(Camera camera, InputEvent _event, Vector3 click_position, Vector3 click_normal, int shape_idx, Vector2 chunk, AStar navigation, Node meshMapCtrl, Info info) {
            state.map_input_event(camera, _event, click_position, click_normal, shape_idx, chunk, navigation, meshMapCtrl, info);
        }

        public InGameJobs get_job_system() {
            return GetNode<InGameJobs>("/root/in_game_jobs");
        }

        public void request_new_state(string newState) {
            GD.Print("Request new state: ", newState);
            if (!CURRENT_STATE.Equals(newState)) {
                state?.teardown_state();
                switch (newState)
                {
                    case constant.StateNames.NONE:
                        state = STATE_NONE;
                        break;
                    case constant.StateNames.SELECT_DWARFS:
                        state = STATE_SELECT_DWARF;
                        break;
                    case constant.StateNames.BUILD_TUNNEL:
                        state = STATE_BUILD_TUNNEL;
                        break;
                    default:
                        GD.PrintErr("Unknown state! ", newState);
                        state?.setup_state();
                        return;
                }
                state.setup_state();
                CURRENT_STATE = newState;
                EmitSignal(nameof(state_changed), CURRENT_STATE);
            }
        }
    }
}