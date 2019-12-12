using Godot;

namespace State
{
    public abstract class SelectDwarfState : AbstractState
    {
        public SelectDwarfState(Node ctrl) : base(ctrl)
        {
            this.Name = constant.StateNames.SELECT_DWARFS;
        }

        public override void teardown_state()
        {
            base.teardown_state();
            ((Node)ctrl.Call("get_tree")).Call("call_group", constant.GroupNames.SELECTED_DWARFS, "remove_from_group", constant.GroupNames.SELECTED_DWARFS);
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
                        ((Node)ctrl.Call("get_tree")).Call("call_group", constant.GroupNames.SELECTED_DWARFS, "remove_from_group", constant.GroupNames.SELECTED_DWARFS);
                        dwarf.AddToGroup(constant.GroupNames.SELECTED_DWARFS);
                    }
                }
            }
        }
        public override void map_input_event(Camera camera, InputEvent _event, Vector3 click_position, Vector3 click_normal, int shape_idx, Vector2 chunk, AStar navigation, Node meshMapCtrl, Node info)
        {
            if (_event is InputEventMouseButton)
            {
                var tmpInput = (InputEventMouseButton)_event;
                if (tmpInput.ButtonIndex == (int)ButtonList.Right && tmpInput.ButtonMask == (int)ButtonList.MaskRight)
                {
                    var x = Mathf.Round(click_position.x / 2);
                    var y = Mathf.Round(click_position.y / 2);
                    Job.AbstractJob job = (Job.AbstractJob)((Node)ctrl.Call("get_job_system")).Call("get_tunnel_job_on_cell", new Vector2(x, y));
                    if (job != null)
                    {
                        GD.Print(constant.JobNames.BUILD_TUNNEL, job);
                    }
                    else
                    {
                        KinematicBody[] dwarfs = (KinematicBody[])((Node)ctrl.Call("get_tree")).Call("get_nodes_in_group", constant.GroupNames.SELECTED_DWARFS);
                        foreach (KinematicBody d in dwarfs)
                        {
                            Job.AbstractJob walkJob = new Job.WalkJob(navigation, click_position);
                            walkJob.Personal = true;
                            walkJob.Owner = d;
                            Job.AbstractJob[] jobsToAdd = { walkJob };
                            ((Node)ctrl.Call("get_job_system")).Call("submit_jobs", jobsToAdd, walkJob.Owner);
                        }
                    }
                }
            }
        }
    }
}