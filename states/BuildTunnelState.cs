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
        public override void map_input_event(Camera camera, InputEvent _event, Vector3 click_position, Vector3 click_normal, int shape_idx, Vector2 chunk, AStar navigation, Node meshMapCtrl, Info info)
        {
            if (_event is InputEventMouseMotion)
            {
                if (click_normal.z == 1)
                {
                    var x = Mathf.Round(click_position.x / 2);
                    var y = Mathf.Round(click_position.y / 2);
                    info.MouseCellPosistion = new Vector2(x, y);
                }
            }

            var pts = info.get_last_points();
            // GD.Print("Check if equal: ", equals(last_pts, pts));
            if (!last_pts.Equals(pts))
            {
                last_pts = pts;

                if (!Input.IsMouseButtonPressed((int)ButtonList.Left) && pts != null && pts.Length > 0)
                {
                    GD.Print("New build tunnel jobs to add: ", pts, " ", last_pts != pts);
                    List<Job.AbstractJob> jobs = new List<Job.AbstractJob>();

                    foreach (Vector2 p in pts)
                    {
                        var job = new Job.BuildTunnelJob(p, navigation, meshMapCtrl);
                        jobs.Add(job);
                    }

                    var jobsarr = jobs.ToArray();
                    ((singleton.InGameState)ctrl).get_job_system().submit_jobs(jobsarr);
                }
            }
            if (_event is InputEventMouseButton)
            {
                var tmpInput = (InputEventMouseButton)_event;
                if (tmpInput.ButtonIndex == (int)ButtonList.Right && tmpInput.ButtonMask == (int)ButtonList.MaskRight)
                {
                    ctrl.Call("request_new_state", constant.StateNames.NONE);
                }
            }
        }

        private bool equals(Vector2[] arr1, Vector2[] arr2) {
            // GD.Print("EQUAL: ", arr1.Length, " ? " ,arr2.Length);
            if (arr1.Length != arr2.Length) {
                return false;
            } else {
                for (int i = 0; i < arr1.Length; i++)
                {
                    // GD.Print("EQUAL: ", arr1[i], " ? " , arr2[i]);
                    if (arr1[i] != arr2[i]) {
                        return false;
                    }
                }
                return true;
            }
        }
    }
}