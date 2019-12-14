using Godot;

namespace Job
{
    public class BuildTunnelJob : AbstractJob
    {

        private Vector2 position;
        public AStar navigation { get; private set; }
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

            var toPos = GetclosesPointInNavigation(selfPos);//navigation.GetClosestPoint(selfPos);
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

        private int GetclosesPointInNavigation(Vector3 pos)
        {
            var pointN = navigation.GetClosestPoint(pos + new Vector3(0, 0.1f, 0));
            var pointS = navigation.GetClosestPoint(pos + new Vector3(0, -0.1f, 0));
            var pointW = navigation.GetClosestPoint(pos + new Vector3(-0.1f, 0, 0));
            var pointE = navigation.GetClosestPoint(pos + new Vector3(0.1f, 0, 0));

            var posN = navigation.GetPointPosition(pointN);
            var posS = navigation.GetPointPosition(pointS);
            var posW = navigation.GetPointPosition(pointW);
            var posE = navigation.GetPointPosition(pointE);

            var posNDiff = (posN - pos).Abs();
            var posSDiff = (posS - pos).Abs();
            var posWDiff = (posW - pos).Abs();
            var posEDiff = (posE - pos).Abs();

            return GetShortestVector(new Vector3[] { posNDiff, posSDiff, posWDiff, posWDiff }, new int[] { pointN, pointS, pointW, pointE });
        }

        private int GetShortestVector(Vector3[] vectors, int[] idx)
        {
            var shortestV = new Vector3(500, 500, 500);
            int id = -1;

            for (var i = 0; i < idx.Length; i++)
            {
                if (vectors[i].Length() <= shortestV.Length())
                {
                    shortestV = vectors[i];
                    id = idx[i];
                }
            }
            return id;
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

        protected override void _DebugDraw(ImmediateGeometry ig) {}

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