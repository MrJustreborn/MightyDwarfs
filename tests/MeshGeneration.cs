using System.Collections.Generic;
using Godot;

public class MeshGeneration : Spatial {

    private Spatial chunks;
    private Spatial chunks_cave;
    private Spatial chunks_fog;
    private Spatial chunks_fps;

    private const int MAX_DAMAGE = 5;

    private const int CHUNK_SIZE = 5;
    private const int CUBE_SIZE = 2;

    // [visible, depth, type, damage]
    // dark = 0
    // visible = 1
    // fog = 2
    private Dictionary<int, Dictionary<int, int[]>> terrain;

    public override void _Ready() {
        terrain = new Dictionary<int, Dictionary<int, int[]>>();

        // terrain.Add
    }


    private void genTestWorld() {
        Grid.Grid grid = new Grid.Grid();

        for (int i = 0; i < 25; i++)
        {
            for (int j = 0; j < 25; j++)
            {
                grid.SetCell(i, j, new Grid.Cell());
            }
        }
    }
}