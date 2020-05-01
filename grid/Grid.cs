using System.Collections.Generic;
using Godot;

namespace Grid
{
    public class Grid : Reference {
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

        private void _SetCell(List<List<Cell>> which, int x, int y, Cell what) {
            x = Mathf.Abs(x);
            y = Mathf.Abs(y);
            
            GD.Print(GD.Str(which.Count), " : ", GD.Str(x), " - ", GD.Str(y));
            while (which.Count <= x) {
                which.Add(new List<Cell>());
            }

            while (which[x].Count <= y) {
                which[x].Add(new Cell());
            }

            GD.Print(GD.Str(which.Count), " - ", GD.Str(which[x].Count), " : ", GD.Str(x), " - ", GD.Str(y));

            GD.Print(GD.Str(what));
            which[x][y] = what;
        }
    }
}