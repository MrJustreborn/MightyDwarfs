using Godot;

namespace Job
{
    public class BuildTunnelJob : AbstractJob
    {

        private Vector2 position;
        public AStar navigation {get; private set;}
        private Node mapMeshCtrl;

        public BuildTunnelJob(Vector2 pos, AStar nav, Node meshCtrl)
        {
            this.position = pos;
            this.navigation = nav;
            this.mapMeshCtrl = meshCtrl;
        }

        protected override void _SetupNewOwner() { }

        public override Vector2 get_cell_pos()
        {
            return this.position;
        }

        public override Vector3[] distance_from_cell(Vector2 cell)
        {
            var target = new Vector3(cell.x * 2, cell.y * 2, 0);
            var selfPos = new Vector3(position.x * 2, position.y * 2, 0);

            var toPos = navigation.GetClosestPoint(selfPos);
            var targetPos = navigation.GetPointPosition(toPos);

            var dist = (targetPos - selfPos).Length();
            // print(self, " Dist: ", dist);
            if (dist > 3)
            {
                return new Vector3[0];
            }

            var fromPos = navigation.GetClosestPoint(target);
            var path = navigation.GetPointPath(fromPos, toPos);
            // print(self, " -> ", path)
            return path;
        }

        public override string get_job_name()
        {
            return constant.JobNames.BUILD_TUNNEL;
        }

        public override bool equals(AbstractJob other)
        {
            return other.get_job_name() == get_job_name()
                && other is BuildTunnelJob
                && ((BuildTunnelJob)other).position == position;
        }

        public override void process(float delta)
        {
            // mapMeshCtrl.update(position.x, position.y, 0, 0, 1);
            mapMeshCtrl.Call("update", position.x, position.y, 0, 0, 1);
            // var c = mapMeshCtrl.terrain_next_frame[int(position.y)][int(position.x)];
            // print("asdf ", c, " ", mapMeshCtrl._cell_exists(position.x, position.y), mapMeshCtrl._cell_exists(position.x, position.y) && c[1] < 1 && c[3] <= 5)
        }
        public override void physics_process(float delta) { }

        public override bool finished()
        {
            // var finished = !mapMeshCtrl.is_mineable(get_cell_pos().x, get_cell_pos().y);
            bool finished = !(bool)mapMeshCtrl.Call("is_mineable", get_cell_pos().x, get_cell_pos().y);

            GD.Print("Finished?: ", finished);
            if (finished)
            {
                // jobSystem.remove_finished_job(self);
                jobSystem.Call("remove_finished_job", this);
            }

            return finished;
        }
    }
}