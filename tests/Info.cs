using System.Collections.Generic;
using Godot;

public class Info : Spatial
{
    private Vector2 mouse_cell_pos;
    public Vector2 MouseCellPosistion
    {
        set
        {
            set_mouse_pos(value);
        }
        get
        {
            return mouse_cell_pos;
        }
    }

    private Vector2? start_pos;
    private Vector2? end_pos;
    private Vector2[] lastPoints;
    private Vector2[] curPoints;

    private MeshInstance mouse_preview;

    public override void _Ready()
    {
        GetNodeOrNull("/root/in_game_state")?.Connect("state_changed", this, "_on_state_changed");
        GetNodeOrNull("/root/in_game_jobs")?.Connect("job_added", this, "_on_job_added");
        GetNodeOrNull("/root/in_game_jobs")?.Connect("job_removed", this, "_on_job_added");

        mouse_preview = GetNode<MeshInstance>("mouse_preview");
    }

    private void _on_state_changed(string newState)
    {
        mouse_preview.Visible = newState == constant.StateNames.BUILD_TUNNEL;
    }

    private void _on_job_added(Job.AbstractJob newJob)
    {
        if (newJob.get_job_name().Equals(constant.JobNames.BUILD_TUNNEL))
        {
            var jobs = GetNodeOrNull<singleton.InGameJobs>("/root/in_game_jobs")?.get_copy_of_all_jobs();
            List<Vector2> positions = new List<Vector2>();

            foreach (var j in jobs)
            {
                if (j.get_job_name().Equals(constant.JobNames.BUILD_TUNNEL))
                {
                    positions.Add(j.get_cell_pos());
                }
            }
            generate_ui_mesh(positions.ToArray());
        }
        else
        {
            GD.Print("No Tunnel-Job: ", newJob);
        }
    }

    public void set_mouse_pos(Vector2 pos)
    {
        if (!GetNodeOrNull<singleton.InGameState>("/root/in_game_state").CURRENT_STATE.Equals(constant.StateNames.BUILD_TUNNEL))
        {
            return;
        }
        mouse_cell_pos = pos;

        int x = (int)pos.x;
        int y = (int)pos.y;

        if (x % 2 == 0 && y % 2 == 0 && start_pos == null)
        {
            var tl = mouse_preview.GetTranslation();
            tl.x = pos.x * 2;
            tl.y = pos.y * 2;
            mouse_preview.SetTranslation(tl);
        }
        else if (start_pos != null)
        {
            var tl = mouse_preview.GetTranslation();
            tl.x = pos.x * 2;
            tl.y = pos.y * 2;
            mouse_preview.SetTranslation(tl);
        }

        if (start_pos != null && !end_pos.Equals(pos))
        {
            end_pos = pos;
            generate_mesh();
        }

        if (Input.IsMouseButtonPressed((int)ButtonList.Left) && start_pos == null && x % 2 == 0 && y % 2 == 0)
        {
            GetNode<MeshInstance>("mouse_draw_preview").Visible = true;
            start_pos = pos;
        }
        else if (!Input.IsMouseButtonPressed((int)ButtonList.Left) && start_pos != null)
        {
            lastPoints = (Vector2[])curPoints.Clone();
            curPoints = new Vector2[0];
            start_pos = null;
            end_pos = null;
            GD.Print(lastPoints);
            GetNode<MeshInstance>("mouse_draw_preview").Visible = false;
        }
    }

    public Vector2[] get_last_points()
    {
        if (lastPoints != null)
            return _filter_mineable((Vector2[])lastPoints.Clone());
        else
            return new Vector2[0];
    }

    private Vector2[] _filter_mineable(Vector2[] points)
    {
        List<Vector2> newArr = new List<Vector2>();
        foreach (var p in points)
        {
            if ((bool)GetParent().Call("is_mineable", p.x, p.y))
            {
                newArr.Add(p);
            }
        }
        return newArr.ToArray();
    }

    private Color get_color(int x, int y)
    {
        if ((bool)GetParent().Call("is_mineable", x, y))
        {
            return new Color(1, 0, 0);
        }
        return new Color(0, 0, 0);
    }

    private void generate_mesh()
    {
        GD.Print("Update info mesh");
        var tmpPoints = new List<Vector2>();

        var st = new SurfaceTool();
        st.Begin(Mesh.PrimitiveType.Triangles);

        Vector2 _test = (Vector2)start_pos - (Vector2)end_pos;
        if (Mathf.Abs(_test.x) > Mathf.Abs(_test.y))
        {
            _test.y = 0;
        }
        else
        {
            _test.x = 0;
        }

        int size = (int)_test.Length();

        if (_test.x != 0 && _test.y == 0)
        {
            GD.Print("X");
            for (int i = 0; i < size + 1; i++)
            {
                if (_test.x < 0)
                {
                    _plane(st, ((Vector2)start_pos).x + i, ((Vector2)start_pos).y);
                    tmpPoints.Add(((Vector2)start_pos) + new Vector2(i, 0));
                }
                else
                {
                    _plane(st, ((Vector2)start_pos).x - i, ((Vector2)start_pos).y);
                    tmpPoints.Add(((Vector2)start_pos) + new Vector2(-i, 0));
                }
            }
        }
        else if (_test.y != 0 && _test.x == 0)
        {
            GD.Print("Y");
            for (int i = 0; i < size + 1; i++)
            {
                if (_test.y < 0)
                {
                    _plane(st, ((Vector2)start_pos).x, ((Vector2)start_pos).y + i);
                    tmpPoints.Add(((Vector2)start_pos) + new Vector2(0, i));
                }
                else
                {
                    _plane(st, ((Vector2)start_pos).x, ((Vector2)start_pos).y - i);
                    tmpPoints.Add(((Vector2)start_pos) + new Vector2(0, -i));
                }
            }
        }

        st.Index();
        st.GenerateNormals();
        st.GenerateTangents();

        var mesh = st.Commit();
        mesh.SurfaceSetMaterial(0, mouse_preview.GetSurfaceMaterial(0));
        GetNode<MeshInstance>("mouse_draw_preview").Mesh = mesh;

        curPoints = tmpPoints.ToArray();
        GD.Print(_test, size);
    }

    private void generate_ui_mesh(Vector2[] positions)
    {
        GD.Print("Generate new UI mesh", positions);

        var st = new SurfaceTool();
        st.Begin(Mesh.PrimitiveType.Triangles);

        foreach (var p in positions)
        {
            GD.Print(p);
            _plane(st, p.x, p.y);
        }

        st.Index();
        st.GenerateNormals();
        st.GenerateTangents();

        var mesh = st.Commit();
        mesh.SurfaceSetMaterial(0, mouse_preview.GetSurfaceMaterial(0));
        GetNode<MeshInstance>("MeshInstance3").Mesh = mesh;
    }

    private void _plane(SurfaceTool st, float posX, float posY)
    {
        int xOffset = (int)posX;
        int yOffset = (int)posY;
        var z = 0;
        GD.Print(posX, " ", posY);
        st.AddColor(get_color(xOffset, yOffset));
        st.AddUv(new Vector2(0, 1));
        st.AddVertex(new Vector3(-1 + xOffset * 2, 1 + yOffset * 2, z));

        st.AddUv(new Vector2(1, 1));
        st.AddVertex(new Vector3(1 + xOffset * 2, 1 + yOffset * 2, z));

        st.AddUv(new Vector2(1, 0));
        st.AddVertex(new Vector3(1 + xOffset * 2, -1 + yOffset * 2, z));

        st.AddUv(new Vector2(1, 0));
        st.AddVertex(new Vector3(1 + xOffset * 2, -1 + yOffset * 2, z));

        st.AddUv(new Vector2(0, 0));
        st.AddVertex(new Vector3(-1 + xOffset * 2, -1 + yOffset * 2, z));

        st.AddUv(new Vector2(0, 1));
        st.AddVertex(new Vector3(-1 + xOffset * 2, 1 + yOffset * 2, z));
    }
}