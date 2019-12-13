using System.Collections.Generic;
using Godot;

namespace entities
{
    public class Dwarf : KinematicBody
    {
        public static int SPEED = 5;

        [Export]
        bool WASD = false;

        private singleton.InGameState state;
        private singleton.InGameJobs job_system;

        private Spatial CTRL;
        private List<Job.AbstractJob> jobs = new List<Job.AbstractJob>();

        public override void _Ready()
        {
            state = GetNodeOrNull<singleton.InGameState>("/root/in_game_state");
            job_system = GetNodeOrNull<singleton.InGameJobs>("/root/in_game_jobs");
            // FIXME: setup ctrl
            CTRL = (Spatial)GetParent().GetParent();

            Connect("input_event", GetNode("/root/in_game_state"), "_on_dwarf_input_event", new Godot.Collections.Array { this });

            if (WASD)
            {
                var meshInst = GetNodeOrNull<MeshInstance>("MeshInstance2");
                meshInst?.SetMaterialOverride((Material)meshInst?.GetSurfaceMaterial(0).Duplicate());
                ((SpatialMaterial)meshInst?.MaterialOverride).AlbedoColor = new Color(1, 0, 0);
            }
        }

        public void set_personal_jobs(Job.AbstractJob[] jobtToDo)
        {
            if (jobs.Count > 0)
            {
                job_system.submit_jobs(jobs.ToArray());
            }
            jobs = new List<Job.AbstractJob>(jobtToDo);
        }

        public override void _PhysicsProcess(float delta)
        {
            if (jobs.Count > 0)
            {
                jobs[0].physics_process(delta);
            }
        }

        int time = 0;
        public override void _Process(float delta)
        {
            update();

            var pos = GetViewport().GetCamera().UnprojectPosition(Translation);
            var label = GetNode<Label>("Label");
            label.RectGlobalPosition = pos;
            label.Text = "" + jobs.Count;

            if (jobs.Count > 0)
            {
                jobs[0].process(delta);
                label.Text += "\n" + jobs[0].title() + ": " + jobs[0].get_job_name() + " -> " + jobs[0].get_cell_pos();
                label.Text += "\n" + jobs[0].finished();
                if (jobs[0].finished())
                {
                    jobs.Remove(jobs[0]);
                }
            }
            else if (time >= 100)
            {
                time = 0;
                var newJobs = job_system.request_jobs(last_cell, this);
                if (newJobs?.Length > 0)
                {
                    foreach (var n in newJobs)
                    {
                        jobs.Add(n);
                    }
                }
            }
            else
            {
                time += 1;
            }
        }

        private Vector2 last_cell = new Vector2();
        private void update()
        {
            var x = Mathf.Round(Translation.x / 2);
            var y = Mathf.Round(Translation.y / 2);
            var cur_cell = new Vector2(x, y);
            if (!last_cell.Equals(cur_cell))
            {
                last_cell = cur_cell;
            }
            CTRL.Call("update", x, y);
        }
    }
}