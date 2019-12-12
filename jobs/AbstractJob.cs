using Godot;

namespace Job
{
    public abstract class AbstractJob : Reference
    {

        private KinematicBody owner = null;
        public KinematicBody Owner
        {
            get
            {
                return this.owner;
            }
            set
            {
                this.owner = value;
                this._SetupNewOwner();
            }
        }

        private bool personal = false;
        public bool Personal
        {
            get
            {
                return this.personal;
            }
            set
            {
                if (!personal && value)
                {
                    personal = true;
                }
            }
        }
        public Node jobSystem;

        protected abstract void _SetupNewOwner();

        public virtual Vector2 get_cell_pos()
        {
            return new Vector2();
        }

        public virtual bool is_reachable_from_cell(Vector2 cell)
        {
            return false;
        }

        public virtual string get_job_name()
        {
            return "";
        }

        public virtual bool equals(AbstractJob other)
        {
            return false;
        }

        public virtual Texture icon()
        {
            return null;
        }

        public virtual string title()
        {
            return Tr("");
        }

        public virtual string description()
        {
            return Tr("");
        }

        public abstract void process(float delta);
        public abstract void physics_process(float delta);
        public virtual bool finished()
        {
            return true;
        }
    }
}