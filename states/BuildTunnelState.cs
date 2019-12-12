using System.Collections.Generic;
using Godot;

namespace State
{
    public class BuildTunnelState : AbstractState
    {

        private Vector2[] last_pts = new Vector2[0];
        public BuildTunnelState(Node ctrl) : base(ctrl)
        {
            this.Name = constant.StateNames.BUILD_TUNNEL;
        }

        public override void building_input_event(Camera camera, InputEvent _event, Vector3 click_position, Vector3 click_normal, int shape_idx, Node building) { }
        public override void dwarf_input_event(Camera camera, InputEvent _event, Vector3 click_position, Vector3 click_normal, int shape_idx, Node dwarf) { }
        public override void map_input_event(Camera camera, InputEvent _event, Vector3 click_position, Vector3 click_normal, int shape_idx, Vector2 chunk, AStar navigation, Node meshMapCtrl, Node info)
        {
            if (_event is InputEventMouseMotion)
            {
                if (click_normal.z == 1)
                {
                    var x = Mathf.Round(click_position.x / 2);
                    var y = Mathf.Round(click_position.y / 2);
                    info.Call("set_mouse_pos", new Vector2(x, y));
                }
            }

            Vector2[] pts = (Vector2[])info.Call("get_last_points");
            if (!last_pts.Equals(pts))
            {
                last_pts = pts;

                if (!Input.IsMouseButtonPressed((int)ButtonList.Left) && pts != null && pts.Length > 0)
                {
                    GD.Print("New build tunnel jobs to add: ", pts);
                    List<Job.AbstractJob> jobs = new List<Job.AbstractJob>();

                    foreach (Vector2 p in pts)
                    {
                        var job = new Job.BuildTunnelJob(p, navigation, meshMapCtrl);
                        jobs.Add(job);
                    }

                    var jobsarr = jobs.ToArray();
                    ((Node)ctrl.Call("get_job_system")).Call("submit_jobs", jobsarr);
                }
            }
            else if (_event is InputEventMouseButton)
            {
                var tmpInput = (InputEventMouseButton)_event;
                if (tmpInput.ButtonIndex == (int)ButtonList.Right && tmpInput.ButtonMask == (int)ButtonList.MaskRight)
                {
                    ctrl.Call("request_new_state", constant.StateNames.NONE);
                }
            }
        }
    }
}