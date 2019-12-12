using System.Collections.Generic;
using Godot;

namespace singleton
{
    public class InGameJobs : Node
    {
        [Signal]
        delegate void job_added(Job.AbstractJob newJob);
        [Signal]
        delegate void job_removed(Job.AbstractJob removedJob);

        private List<Job.AbstractJob> jobs = new List<Job.AbstractJob>();

        public void submit_jobs(Job.AbstractJob[] newJobs, KinematicBody to_instance = null)
        {
            GD.Print("Submit new jobs: ", newJobs, " -> ", to_instance);

            if (to_instance != null && to_instance.HasMethod("set_personal_jobs"))
            {
                foreach (var j in newJobs)
                {
                    j.Personal = true;
                    j.Owner = to_instance;
                    j.jobSystem = this;
                }
                to_instance.Call("set_personal_jobs", newJobs);
            }
            else
            {
                foreach (var j in newJobs)
                {
                    if (!j.Personal)
                    {
                        j.Owner = null;
                        j.jobSystem = this;
                        _AddJob(j);
                    }
                }
            }
        }

        private void _AddJob(Job.AbstractJob job)
        {
            foreach (var j in jobs)
            {
                if (j.equals(job))
                {
                    return;
                }
            }
            jobs.Add(job);
            EmitSignal(nameof(job_added), job);
            GD.Print("new job added: ", job);
        }

        public void remove_finished_job(Job.AbstractJob job)
        {
            GD.Print("Remove: ", job);
            var success = jobs.Remove(job);
            if (success)
            {
                EmitSignal(nameof(job_removed), job);
            }
        }

        public Job.AbstractJob[] get_copy_of_all_jobs()
        {
            return jobs.ToArray();
        }

        public Job.BuildTunnelJob get_tunnel_job_on_cell(Vector2 cell)
        {
            foreach (var j in jobs)
            {
                if (j.get_job_name().Equals(constant.JobNames.BUILD_TUNNEL))
                {
                    if (j.get_cell_pos().Equals(cell))
                    {
                        return (Job.BuildTunnelJob)j;
                    }
                }
            }
            return null;
        }

        public Job.AbstractJob[] request_jobs(Vector2 pos, KinematicBody caller)
        {
            Job.AbstractJob nearest = null;
            int lastPos = 500;

            foreach (var j in jobs)
            {
                if (j.distance_from_cell(pos).Length < lastPos && j.distance_from_cell(pos).Length > 0)
                {
                    lastPos = j.distance_from_cell(pos).Length;
                    nearest = j;
                }
            }

            if (nearest != null)
            {
                GD.Print(pos, " -> ", lastPos, " ", nearest, " ", nearest.get_cell_pos(), " ", nearest.Owner, " ", caller);
                nearest.Owner = caller;

                var path = nearest.distance_from_cell(pos);
                if (path.Length > 0)
                {
                    var walk = new Job.WalkJob(((Job.BuildTunnelJob)nearest).navigation, path[path.Length - 1]);
                    walk.Personal = true;
                    walk.Owner = caller;
                    return new Job.AbstractJob[] { walk, nearest };
                }
                else
                {
                    return new Job.AbstractJob[] { nearest };
                }
            }
            else
            {
                GD.Print(pos, " -> ", lastPos);
            }
            return new Job.AbstractJob[0];

        }
    }
}