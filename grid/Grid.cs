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
            for (int x = 0; x < pp.Count; x++) {
                for (int y = 0; y < pp[x].Count; y++) {
                    if(pp[x][y] != null && pp[x][y].UpdateInNextFrame(false)) {
                        List<Cell> chunk = getAllCellsInChunk(pp[x][y]);
                    }
                }
            }
            return null;
        }

        private List<Cell> getAllCellsInChunk(Cell which) {
            return null;
        }

        private void _SetCell(List<List<Cell>> which, int x, int y, Cell what) {
            x = Mathf.Abs(x);
            y = Mathf.Abs(y);
            
            GD.Print(GD.Str(which.Count), " : ", GD.Str(x), " - ", GD.Str(y));
            while (which.Count <= x) {
                which.Add(new List<Cell>());
            }

            while (which[x].Count <= y) {
                which[x].Add(new Cell(x, y, CHUNK_SIZE));
            }

            GD.Print(GD.Str(which.Count), " - ", GD.Str(which[x].Count), " : ", GD.Str(x), " - ", GD.Str(y));

            GD.Print(GD.Str(what));
            which[x][y] = what;
        }
    }
}