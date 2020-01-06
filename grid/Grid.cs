using System.Collections.Generic;
using Godot;

namespace Grid
{
    public class Grid : Reference {
        private List<List<int[]>> pp = new List<List<int[]>>();
        private List<List<int[]>> pn = new List<List<int[]>>();
        private List<List<int[]>> nn = new List<List<int[]>>();
        private List<List<int[]>> np = new List<List<int[]>>();

        public void SetCell(int x, int y, int[] what) {
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

        public int[] GetCell(int x, int y) {
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

            return new int[4] {0, 0, 0, 0};
        }

        private void _SetCell(List<List<int[]>> which, int x, int y, int[] what) {
            x = Mathf.Abs(x);
            y = Mathf.Abs(y);
            
            GD.Print(GD.Str(which.Count), " : ", GD.Str(x), " - ", GD.Str(y));
            while (which.Count <= x) {
                which.Add(new List<int[]>());
            }

            while (which[x].Count <= y) {
                which[x].Add(new int[4]);
            }

            GD.Print(GD.Str(which.Count), " - ", GD.Str(which[x].Count), " : ", GD.Str(x), " - ", GD.Str(y));

            GD.Print(GD.Str(what));
            which[x][y] = what;
        }
    }
}