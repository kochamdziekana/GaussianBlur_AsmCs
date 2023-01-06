using System.Diagnostics;
using System.Drawing.Imaging;

namespace GaussianBlurImplementator
{
    public partial class MainWindow : Form
    {
        public static int ThreadsNumber = 1;
        public static int BlurStrenght = 1;
        public static bool CurrentCheckboxTextIsCs = true;

        public MainWindow()
        {
            InitializeComponent();
            radioButton1.Checked = true;
            chBoxLanguageCs.Checked = true;
        }

        private void chBoxLanguage_CheckedChanged(object sender, EventArgs e)
        {
            if (CurrentCheckboxTextIsCs)
            {
                chBoxLanguageCs.Checked = false;
                chBoxLanguageAsm.Checked = true;
                CurrentCheckboxTextIsCs = false;
            }
            else
            {
                chBoxLanguageCs.Checked = true;
                chBoxLanguageAsm.Checked = false;
                CurrentCheckboxTextIsCs = true;
            }
        }

        private void btnChooseBmp_Click(object sender, EventArgs e)
        {
            var openDialog = new OpenFileDialog();

            if (openDialog.ShowDialog() == DialogResult.OK)
            {
                if (openDialog.FileName.EndsWith(".jpg") || openDialog.FileName.EndsWith(".png") || openDialog.FileName.EndsWith(".bmp"))
                {
                    txtFilename.Text = openDialog.FileName;
                }
                else
                {
                    lblTime.Text = "Not a viable file.";
                }
            }
        }

        private void btnBlur_Click(object sender, EventArgs e)
        {
            var image = Image.FromFile(txtFilename.Text);
            var blur = new DllExecutionManager(image as Bitmap);

            var sw = Stopwatch.StartNew();
            var result = blur.ProcessBitmap(BlurStrenght);
            result.Save("gaussianed.jpg", ImageFormat.Jpeg);
            result.Save("gaussianed.png", ImageFormat.Png);
            picBoxBefore.ImageLocation = txtFilename.Text;
            picBoxAfter.ImageLocation = "gaussianed.png";
            lblTime.Text = sw.ElapsedMilliseconds.ToString();
        }

        private void radioButton1_CheckedChanged(object sender, EventArgs e)
        {
            ThreadsNumber = 1;
            lblThreads.Text = ThreadsNumber.ToString();
        }

        private void radioButton2_CheckedChanged(object sender, EventArgs e)
        {
            ThreadsNumber = 2;
            lblThreads.Text = ThreadsNumber.ToString();
        }

        private void radioButton4_CheckedChanged(object sender, EventArgs e)
        {
            ThreadsNumber = 4;
            lblThreads.Text = ThreadsNumber.ToString();
        }

        private void radioButton8_CheckedChanged(object sender, EventArgs e)
        {
            ThreadsNumber = 8;
            lblThreads.Text = ThreadsNumber.ToString();
        }

        private void radioButton16_CheckedChanged(object sender, EventArgs e)
        {
            ThreadsNumber = 16;
            lblThreads.Text = ThreadsNumber.ToString();
        }

        private void radioButton32_CheckedChanged(object sender, EventArgs e)
        {
            ThreadsNumber = 32;
            lblThreads.Text = ThreadsNumber.ToString();
        }

        private void radioButton64_CheckedChanged(object sender, EventArgs e)
        {
            ThreadsNumber = 64;
            lblThreads.Text = ThreadsNumber.ToString();
        }


        private void trackBar1_Scroll(object sender, EventArgs e)
        {
            BlurStrenght = trackBar1.Value;
            lblBlurStrenght.Text = trackBar1.Value.ToString();
        }
    }
}