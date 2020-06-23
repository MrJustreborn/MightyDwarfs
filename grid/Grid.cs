using System.Collections.Generic;
using Godot;

namespace Grid
{
    public class Chunk {
        public readonly int x;
        public readonly int y;

        public List<Cell> cells {get; private set;} = new List<Cell>();

        public Chunk(int x, int y) {
            this.x = x;
            this.y = y;
        }

        public void addCell(Cell c) {
            this.cells.Add(c);
        }
    }
    public class Grid : Node {

        private const int CHUNK_SIZE = 5;

        private List<List<Cell>> pp = new List<List<Cell>>(); //upper-right
        private List<List<Cell>> pn = new List<List<Cell>>(); //lower-right
        private List<List<Cell>> nn = new List<List<Cell>>(); //lower-left
        private List<List<Cell>> np = new List<List<Cell>>(); //upper-left

        public void SetCell(int x, int y, Cell what) {
            // GD.Print("Grid::setCell: ", GD.Str(x), GD.Str(y), GD.Str(what));

            if (x >= 0 && y >= 0) {
                // GD.Print("SetCell: pp");
                _SetCell(pp, x, y, what);
            } else if(x >= 0 && y < 0) {
                // GD.Print("SetCell: pn");
                _SetCell(pn, x, y, what);
            } else if (x < 0 && y < 0) {
                // GD.Print("SetCell: nn");
                _SetCell(nn, x, y, what);
            } else if (x < 0 && y >= 0) {
                // GD.Print("SetCell: np");
                _SetCell(np, x, y, what);
            }
        }

        public Cell GetCell(int x, int y) {
            if (x >= 0 && y >= 0) {
                return pp[x][y];
            } else if(x >= 0 && y < 0) {
                y = Mathf.Abs(y);
                return pn[x][y];
            } else if (x < 0 && y < 0) {
                x = Mathf.Abs(x);
                y = Mathf.Abs(y);
                return nn[x][y];
            } else if (x < 0 && y >= 0) {
                x = Mathf.Abs(x);
                return np[x][y];
            }

            return null; //This does not exists so return null ... ?
        }

        public void _Process(float delta) {
            firstUpdateCallFlag = true;
        }

        //TODO: create list of chunks to regenerate mesh (fog/new depth etc)
        private bool regenerateMesh = false;
        private bool firstUpdateCallFlag = true; //TODO reset each frame (_Process)
        public void update(int x, int y, int radius_remove_fog = 5, int radius_discover_hidden = 2) {
            //Create FogOfWar
            if (firstUpdateCallFlag) {
                firstUpdateCallFlag = false;
                resetAllToFog(pp);
                resetAllToFog(pn);
                resetAllToFog(nn);
                resetAllToFog(np);
            }

            markVisible(x, y, radius_remove_fog, true);
            markVisible(x, y, radius_discover_hidden, false);
        }

        private void resetAllToFog(List<List<Cell>> which) {
            for (int x = 0; x < which.Count; x++) {
                for (int y = 0; y < which[x].Count; y++) {
                    which[x][y]?.SetToFogIfVisibleInNextFrame();
                }
            }
        }

        //Use circle isntead of rect, it's radius not size^^
        private void markVisible(int x, int y, int radius, bool fogOnly = true) {
            for (int xOff = 0; xOff < radius; xOff++) {
                if (fogOnly) {
                    GetCell(x - xOff, y)?.SetToVisibleIfFogInNextFrame();
                    GetCell(x + xOff, y)?.SetToVisibleIfFogInNextFrame();
                } else {
                    GetCell(x - xOff, y)?.SetToVisibleInNextFrame();
                    GetCell(x + xOff, y)?.SetToVisibleInNextFrame();
                }
            }
            for (int yOff = 0; yOff < radius; yOff++) {
                if (fogOnly) {
                    GetCell(x, y - yOff)?.SetToVisibleIfFogInNextFrame();
                    GetCell(x, y + yOff)?.SetToVisibleIfFogInNextFrame();
                } else {
                    GetCell(x, y - yOff)?.SetToVisibleInNextFrame();
                    GetCell(x, y + yOff)?.SetToVisibleInNextFrame();
                }
            }
        }

        //TODO: return chunks for regeneration each frame
        public List<List<Chunk>> getChangedChunks(bool reset = false) {
            List<Chunk> ppChunks = getChangedChunksFor(pp, reset);
            List<Chunk> pnChunks = getChangedChunksFor(pn, reset);
            List<Chunk> nnChunks = getChangedChunksFor(nn, reset);
            List<Chunk> npChunks = getChangedChunksFor(np, reset);

            addAllCellsInChunk(ppChunks, pp);
            addAllCellsInChunk(pnChunks, pn);
            addAllCellsInChunk(nnChunks, nn);
            addAllCellsInChunk(npChunks, np);

            //TODO: flatmap
            List<List<Chunk>> allChunks = new List<List<Chunk>>();
            allChunks.Add(ppChunks);
            allChunks.Add(pnChunks);
            allChunks.Add(nnChunks);
            allChunks.Add(npChunks);

            return allChunks;
        }

        private List<Chunk> getChangedChunksFor(List<List<Cell>> which, bool reset) {
            List<Chunk> chunks = new List<Chunk>();

            for (int x = 0; x < which.Count; x++) {
                for (int y = 0; y < which[x].Count; y++) {
                    if(which[x][y] != null && which[x][y].UpdateInNextFrame(reset)) {
                        var chunk = getChunk(which[x][y]);
                        
                        // chunks.Add(getChunk(which[x][y]));

                        bool alreadyInList = chunks.Exists((c) => {
                            return c.x == chunk.x && c.y == chunk.y;
                        });
                        
                        if (!alreadyInList) {
                            chunks.Add(chunk);
                        }
                    }
                }
            }

            return chunks;
        }

        private Chunk getChunk(Cell which) {
            int xCHUNK = (int) Mathf.Floor(Mathf.Abs(which.x) / CHUNK_SIZE);
            int yCHUNK = (int) Mathf.Floor(Mathf.Abs(which.y) / CHUNK_SIZE);

            return new Chunk(xCHUNK, yCHUNK);
        }

        private void addAllCellsInChunk(List<Chunk> chunks, List<List<Cell>> which) {
            // List<Cell> cells = new List<Cell>();
            GD.Print("addCells for Chunks, got chunks: ", GD.Str(chunks.Count));
            foreach (Chunk chunk in chunks)
            {
                // cells.Add(new List<Cell>());
                var xOff = chunk.x;
                var yOff = chunk.y;
                for (int y = 0; y < CHUNK_SIZE; y++) {
                    for (int x = 0; x < CHUNK_SIZE; x++) {
                        var yWorld = y + yOff * CHUNK_SIZE;
                        var xWorld = x + xOff * CHUNK_SIZE;

                        if (which.Count > xWorld && which[xWorld].Count > yWorld) {
                            // cells[cells.Count - 1].Add(which[xWorld][yWorld]);
                            // GD.Print("addCell ", GD.Str(which[xWorld][yWorld]));
                            chunk.addCell(which[xWorld][yWorld]);
                        }
                    }
                }
            }

            // return cells;
        }

        private void _SetCell(List<List<Cell>> which, int xOrg, int yOrg, Cell what) {
            var x = Mathf.Abs(xOrg);
            var y = Mathf.Abs(yOrg);
            
            // GD.Print(GD.Str(which.Count), " : ", GD.Str(x), " / ", GD.Str(y));
            while (which.Count <= x) {
                which.Add(new List<Cell>());
            }

            while (which[x].Count <= y) {
                which[x].Add(new Cell(xOrg, yOrg, CHUNK_SIZE));
            }

            // GD.Print(GD.Str(which.Count), " | ", GD.Str(which[x].Count), " : ", GD.Str(x), " / ", GD.Str(y));

            // GD.Print(GD.Str(what) + "\n");
            which[x][y] = what;
        }
    }
}