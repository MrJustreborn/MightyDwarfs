using Godot;
using System;
using System.Collections.Generic;

namespace Job {
public abstract class WalkJob : AbstractJob
{
    private AStar navigation;
    private Vector3 target;

    private List<Vector3> way_points;

    public WalkJob() {
        GD.Print("Constructor NO args");
    }
    public WalkJob(AStar nav, Vector3 pos)
    {
        GD.Print("Constructor args", nav, pos);
        GD.Print(nav is AStar);
        GD.Print(pos is Vector3);
        this.navigation = nav;
        this.target = pos;
    }

    // public void _Init(AStar nav, Vector3 pos) {
    //     GD.Print("_init args");
    //     this.navigation = nav;
    //     this.target = pos;
    //     base._Init();
    // }

    // public override void _Init() {
    //     GD.Print("_init NO args");
    //     base._Init();
    // }

    public override void physics_process(float delta)
    {
        if (way_points?.Count > 0) {
            
            var dist = Owner.Translation.DistanceTo(way_points[0]);
            var dir = Owner.Translation.DirectionTo(way_points[0]);
            
            // print(way_points[0], " ", translation, " ", dist, " ", dir, " -> ", way_points.size())
            if (dist >= 0.025) {
                Owner.MoveAndSlide(dir * 5);//Owner.SPEED);
            }
            else {
                way_points.RemoveAt(0);
            }
        }
    }

    public override void process(float delta)
    {
        return;
    }

    protected override void _SetupNewOwner()
    {
        GD.Print("Setup ... ", Owner);
        if (Owner != null) {
            way_points = calc_way_points();
        }
        else {
            way_points = new List<Vector3>(0);
        }
    }

    public override string get_job_name() {
        return "WALK - C#";
    }

    public override Vector2 get_cell_pos() {
        var x = Mathf.Round(target.x / 2);
        var y = Mathf.Round(target.y / 2);
        return new Vector2(x, y);
    }

    public override bool finished() {
        return way_points?.Count <= 0;
    }

    private List<Vector3> calc_way_points() {
        var toPos = navigation.GetClosestPoint(target);
        var targetPos = navigation.GetPointPosition(toPos);
        var dist = (targetPos - target).Length();
        GD.Print("Dist: ", dist);
        
        if (dist > 1.5)
            return new List<Vector3>(0);
        
        var fromPos = navigation.GetClosestPoint(Owner.Translation);
        Vector3[] path = navigation.GetPointPath(fromPos, toPos);
        
        GD.Print("Waypoints size: ", path.Length);
        
        List<Vector3> returnPath = new List<Vector3>();
        returnPath.AddRange(path);
        return returnPath;
    }
}
}