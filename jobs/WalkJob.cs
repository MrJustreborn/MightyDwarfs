using Godot;
using System;
using System.Collections.Generic;

namespace Job
{
    public class WalkJob : AbstractJob
    {
        private AStar navigation;
        private Vector3 target;

        private List<Vector3> way_points;

        public WalkJob(AStar nav, Vector3 pos)
        {
            this.navigation = nav;
            this.target = pos;
        }

        public override void physics_process(float delta)
        {
            if (way_points?.Count > 0)
            {

                var dist = Owner.Translation.DistanceTo(way_points[0]);
                var dir = Owner.Translation.DirectionTo(way_points[0]);

                // print(way_points[0], " ", translation, " ", dist, " ", dir, " -> ", way_points.size())
                if (dist >= 0.025)
                {
                    Owner.MoveAndSlide(dir * 5);//Owner.SPEED);
                }
                else
                {
                    way_points.RemoveAt(0);
                }
            }
        }

        protected override void _DebugDraw(ImmediateGeometry ig) {
            if (Owner != null) {
                ig.Clear();
                ig.Begin(Mesh.PrimitiveType.LineStrip);
                ig.SetColor(new Color(1, 0, 0));
                if (!ig.IsSetAsToplevel())
                    ig.SetAsToplevel(true);
                    ig.SetTranslation(new Vector3(0, 0, 0));
                ig.AddVertex(Owner.Translation);

                foreach (var p in way_points)
                {
                    ig.AddVertex(p);
                }
                ig.End();
            }
        }
        public override void process(float delta)
        {
            return;
        }

        protected override void _SetupNewOwner()
        {
            GD.Print("Setup ... ", Owner);
            if (Owner != null)
            {
                way_points = calc_way_points();
            }
            else
            {
                way_points = new List<Vector3>(0);
            }
        }

        public override string get_job_name()
        {
            return constant.JobNames.WALK;
        }

        public override Vector2 get_cell_pos()
        {
            var x = Mathf.Round(target.x / 2);
            var y = Mathf.Round(target.y / 2);
            return new Vector2(x, y);
        }

        public override bool finished()
        {
            return way_points?.Count <= 0;
        }

        private List<Vector3> calc_way_points()
        {
            var toPos = navigation.GetClosestPoint(target);
            var targetPos = navigation.GetPointPosition(toPos);
            var dist = (targetPos - target).Length();
            GD.Print("Dist: ", dist);

            // if (dist < 1.5)
            //     return new List<Vector3>(0);

            var fromPos = navigation.GetClosestPoint(Owner.Translation);
            Vector3[] path = navigation.GetPointPath(fromPos, toPos);

            GD.Print("Waypoints size: ", path.Length);

            List<Vector3> returnPath = new List<Vector3>();
            returnPath.AddRange(path);
            return returnPath;
        }
    }
}