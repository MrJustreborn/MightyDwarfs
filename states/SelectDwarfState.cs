using Godot;

namespace State
{
    public class SelectDwarfState : AbstractState
    {
        public SelectDwarfState(Node ctrl) : base(ctrl)
        {
            this.Name = constant.StateNames.SELECT_DWARFS;
        }

        public override void teardown_state()
        {
            base.teardown_state();
            ((SceneTree)ctrl.Call("get_tree")).CallGroup(constant.GroupNames.SELECTED_DWARFS, "remove_from_group", constant.GroupNames.SELECTED_DWARFS);
        }

        public override void building_input_event(Camera camera, InputEvent _event, Vector3 click_position, Vector3 click_normal, int shape_idx, Node building) { }
        public override void dwarf_input_event(Camera camera, InputEvent _event, Vector3 click_position, Vector3 click_normal, int shape_idx, Node dwarf)
        {
            if (_event is InputEventMouseButton)
            {
                var tmpInput = (InputEventMouseButton)_event;
                if (tmpInput.ButtonIndex == 1 && tmpInput.ButtonMask == 0)
                {
                    if (Input.IsKeyPressed((int)KeyList.Shift))
                    {
                        dwarf.AddToGroup(constant.GroupNames.SELECTED_DWARFS);
                    }
                    else
                    {
                        ((SceneTree)ctrl.Call("get_tree")).CallGroup(constant.GroupNames.SELECTED_DWARFS, "remove_from_group", constant.GroupNames.SELECTED_DWARFS);
                        dwarf.AddToGroup(constant.GroupNames.SELECTED_DWARFS);
                    }
                }
            }
        }
        public override void map_input_event(Camera camera, InputEvent _event, Vector3 click_position, Vector3 click_normal, int shape_idx, Vector2 chunk, AStar navigation, Node meshMapCtrl, Info info)
        {
            if (_event is InputEventMouseButton)
            {
                var tmpInput = (InputEventMouseButton)_event;
                if (tmpInput.ButtonIndex == (int)ButtonList.Right && tmpInput.ButtonMask == (int)ButtonList.MaskRight)
                {
                    var x = Mathf.Round(click_position.x / 2);
                    var y = Mathf.Round(click_position.y / 2);
                    Job.AbstractJob job = ((singleton.InGameState)ctrl).get_job_system().get_tunnel_job_on_cell(new Vector2(x, y));
                    if (job != null)
                    {
                        GD.Print(constant.JobNames.BUILD_TUNNEL, job);
                    }
                    else
                    {
                        var dwarfs = ((SceneTree)ctrl.Call("get_tree")).GetNodesInGroup(constant.GroupNames.SELECTED_DWARFS);
                        foreach (entities.Dwarf d in dwarfs)
                        {
                            Job.AbstractJob walkJob = new Job.WalkJob(navigation, click_position);
                            walkJob.Personal = true;
                            walkJob.Owner = d;
                            Job.AbstractJob[] jobsToAdd = { walkJob };
                            ((singleton.InGameState)ctrl).get_job_system().submit_jobs(jobsToAdd, walkJob.Owner);
                        }
                    }
                }
                ((singleton.InGameState)ctrl).request_new_state(constant.StateNames.NONE);
            }
        }
    }
}