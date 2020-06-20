using System.Collections.Generic;
using Godot;

public class MeshGeneration : Spatial {

    private Spatial chunks;
    private Spatial chunks_cave;
    private Spatial chunks_fog;
    private Spatial chunks_fps;


    private const int CHUNK_SIZE = 5;
    private const int CUBE_SIZE = 2;

    // [visible, depth, type, damage]
    // dark = 0
    // visible = 1
    // fog = 2
    private Dictionary<int, Dictionary<int, int[]>> terrain;

    private Grid.Grid grid;

    public override void _Ready() {
        terrain = new Dictionary<int, Dictionary<int, int[]>>();

        // terrain.Add

        //grid = GetNode("Grid"); //TODO: autoload grid?
    }

    private void genTestWorld() { //TODO: should be in Grid.cs

        for (int i = 0; i < 25; i++)
        {
            for (int j = 0; j < 25; j++)
            {
                grid.SetCell(i, j, new Grid.Cell(i, j, CHUNK_SIZE));
            }
        }
    }
}