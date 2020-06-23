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
    // private Dictionary<int, Dictionary<int, int[]>> terrain;

    private Grid.Grid grid;

    public void TEST() {
        this._Ready();
    }
    public override void _Ready() {
        //grid = GetNode("Grid"); //TODO: autoload grid?
        grid = new Grid.Grid();
        genTestWorld();
        GD.Print(GD.Str(grid));
        genMesh(grid.getChangedChunks());
    }

    private void genTestWorld() { //TODO: should be in Grid.cs
        GD.Print("Gen Test World");
        var tStart = OS.GetSystemTimeMsecs();
        
        for (int i = 0; i < 25; i++)
        {
            for (int j = 0; j < 25; j++)
            {
                grid.SetCell(i, j, new Grid.Cell(i, j, CHUNK_SIZE));
                grid.SetCell(i, -j, new Grid.Cell(i, -j, CHUNK_SIZE));
                grid.SetCell(-i, j, new Grid.Cell(-i, j, CHUNK_SIZE));
                grid.SetCell(-i, -j, new Grid.Cell(-i, -j, CHUNK_SIZE));
            }
        }

        var tStop = OS.GetSystemTimeMsecs();

        GD.Print("Time needed: ", GD.Str(tStop - tStart), "msecs");
    }


    // Chunks[Cells]
    private void genMesh(List<List<Grid.Chunk>> chunks) {
        GD.Print("Gen Mesh, Chunklist: ", GD.Str(chunks.Count));

        //each chunk
        foreach (List<Grid.Chunk> chunked in chunks)
        {
            GD.Print("Gen Mesh, Chunks: ", GD.Str(chunked.Count));
            foreach (Grid.Chunk chunk in chunked)
            {
                // GD.Print("Gen Mesh, cells: ", GD.Str(chunk.cells.Count));
                //Each cell in this chunk
                foreach (Grid.Cell item in chunk.cells)
                {
                    
                }
            }
        }
    }
}