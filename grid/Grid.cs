using System.Collections.Generic;
using Godot;

namespace Grid
{
    public class Grid : Node {

        private const int CHUNK_SIZE = 5;

        private List<List<Cell>> pp = new List<List<Cell>>(); //upper-right
        private List<List<Cell>> pn = new List<List<Cell>>(); //lower-right
        private List<List<Cell>> nn = new List<List<Cell>>(); //lower-left
        private List<List<Cell>> np = new List<List<Cell>>(); //upper-left

        public void SetCell(int x, int y, Cell what) {
            if (x >= 0 && y >= 0) {
                GD.Print("SetCell: pp");
                _SetCell(pp, x, y, what);
            } else if(x >= 0 && y < 0) {
                GD.Print("SetCell: pn");
                _SetCell(pn, x, y, what);
            } else if (x < 0 && y < 0) {
                GD.Print("SetCell: nn");
                _SetCell(nn, x, y, what);
            } else if (x < 0 && y >= 0) {
                GD.Print("SetCell: np");
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
        public List<List<Cell>> getChangedChunks() {
            List<(int, int)> ppChunks = getChangedChunksFor(pp);
            List<(int, int)> pnChunks = getChangedChunksFor(pn);
            List<(int, int)> nnChunks = getChangedChunksFor(nn);
            List<(int, int)> npChunks = getChangedChunksFor(np);

            List<List<Cell>> cells;
            cells.Add(getAllCellsInChunk(ppChunks, pp));
            cells.Add(getAllCellsInChunk(pnChunks, pn));
            cells.Add(getAllCellsInChunk(nnChunks, nn));
            cells.Add(getAllCellsInChunk(npChunks, np));

            return cells;
        }

        private List<(int, int)> getChangedChunksFor(List<List<Cell>> which) {
            List<(int, int)> chunks;

            for (int x = 0; x < which.Count; x++) {
                for (int y = 0; y < which[x].Count; y++) {
                    if(which[x][y] != null && which[x][y].UpdateInNextFrame(false)) {
                        chunks.Add(getChunk(which[x][y]));
                    }
                }
            }

            return chunks;
        }

        private (int, int) getChunk(Cell which) {
            var xCHUNK = Mathf.Floor(Mathf.Abs(which.x) / CHUNK_SIZE);
            var yCHUNK = Mathf.Floor(Mathf.Abs(which.y) / CHUNK_SIZE);

            return (xCHUNK, yCHUNK);
        }

        private List<Cell> getAllCellsInChunk(int xChunk, int yChunk, List<List<Cell>> which) {
            List<Cell> cells;
            for (int y = 0; y < CHUNK_SIZE; y++) {
                for (int x = 0; x < CHUNK_SIZE; x++) {
                    var yWorld = y + yChunk * CHUNK_SIZE;
                    var xWorld = x + xChunk * CHUNK_SIZE;

                    if (which.Count >= xWorld && which[xWorld].Count >= yWorld) {
                        cells.Add(which[xWorld][yWorld]);
                    }
                }
            }

            return cells;
        }

        private void _SetCell(List<List<Cell>> which, int xOrg, int yOrg, Cell what) {
            x = Mathf.Abs(xOrg);
            y = Mathf.Abs(yOrg);
            
            GD.Print(GD.Str(which.Count), " : ", GD.Str(x), " - ", GD.Str(y));
            while (which.Count <= x) {
                which.Add(new List<Cell>());
            }

            while (which[x].Count <= y) {
                which[x].Add(new Cell(xOrg, yOrg, CHUNK_SIZE));
            }

            GD.Print(GD.Str(which.Count), " - ", GD.Str(which[x].Count), " : ", GD.Str(x), " - ", GD.Str(y));

            GD.Print(GD.Str(what));
            which[x][y] = what;
        }
    }
}