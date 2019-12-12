using Godot;

namespace singleton {
    public class InGameState : Node {
        [Signal]
        delegate void state_changed(string newState);

        private string CURRENT_STATE = "";

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

        public InGameJobs get_job_system() {
            return GetNode<InGameJobs>("/root/in_game_jobs");
        }

        public void request_new_state(string newState) {
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