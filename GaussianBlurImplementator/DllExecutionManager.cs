using GaussianBlur.Blurers;
using System;
using System.Collections.Generic;
using System.Drawing.Imaging;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace GaussianBlurImplementator
{
    public class DllExecutionManager
    {
        private int _numberOfThreads = MainWindow.ThreadsNumber;

        private readonly int[] _alpha;
        private readonly int[] _red;
        private readonly int[] _green;
        private readonly int[] _blue;

        private readonly int _width;
        private readonly int _height;
        public DllExecutionManager(Bitmap image) 
        {
            var rct = new Rectangle(0, 0, image.Width, image.Height);
            var source = new int[rct.Width * rct.Height];
            var bits = image.LockBits(rct, ImageLockMode.ReadWrite, PixelFormat.Format32bppArgb);
            Marshal.Copy(bits.Scan0, source, 0, source.Length);
            image.UnlockBits(bits);

            _width = image.Width;
            _height = image.Height;

            _alpha = new int[_width * _height];
            _red = new int[_width * _height];
            _green = new int[_width * _height];
            _blue = new int[_width * _height];

            Parallel.For(0, source.Length, new ParallelOptions { MaxDegreeOfParallelism = (int)_numberOfThreads }, i =>
            {
                _alpha[i] = (int)((source[i] & 0xff000000) >> 24);
                _red[i] = (source[i] & 0xff0000) >> 16;
                _green[i] = (source[i] & 0x00ff00) >> 8;
                _blue[i] = (source[i] & 0x0000ff);
            });
        }

        public Bitmap ProcessBitmap(int radial)
        {
            var changedAlpha = new int[_width * _height];
            var changedRed = new int[_width * _height];
            var changedGreen = new int[_width * _height];
            var changedBlue = new int[_width * _height];
            var dest = new int[_width * _height];

            Parallel.Invoke(
                () => GaussBlur(_alpha, changedAlpha, radial),
                () => GaussBlur(_red, changedRed, radial),
                () => GaussBlur(_green, changedGreen, radial),
                () => GaussBlur(_blue, changedBlue, radial));

            Parallel.For(0, dest.Length, new ParallelOptions { MaxDegreeOfParallelism = (int)_numberOfThreads }, i =>
            {
                if (changedAlpha[i] > 255) changedAlpha[i] = 255;
                if (changedRed[i] > 255) changedRed[i] = 255;
                if (changedGreen[i] > 255) changedGreen[i] = 255;
                if (changedBlue[i] > 255) changedBlue[i] = 255;

                if (changedAlpha[i] < 0) changedAlpha[i] = 0;
                if (changedRed[i] < 0) changedRed[i] = 0;
                if (changedGreen[i] < 0) changedGreen[i] = 0;
                if (changedBlue[i] < 0) changedBlue[i] = 0;

                dest[i] = (int)((uint)(changedAlpha[i] << 24) | (uint)(changedRed[i] << 16) | (uint)(changedGreen[i] << 8) | (uint)changedBlue[i]);
            });

            //for(int i = 0; i < dest.Length; i++)
            //{
            //    if (changedAlpha[i] > 255) changedAlpha[i] = 255;
            //    if (changedRed[i] > 255) changedRed[i] = 255;
            //    if (changedGreen[i] > 255) changedGreen[i] = 255;
            //    if (changedBlue[i] > 255) changedBlue[i] = 255;

            //    if (changedAlpha[i] < 0) changedAlpha[i] = 0;
            //    if (changedRed[i] < 0) changedRed[i] = 0;
            //    if (changedGreen[i] < 0) changedGreen[i] = 0;
            //    if (changedBlue[i] < 0) changedBlue[i] = 0;

            //    dest[i] = (int)((uint)(changedAlpha[i] << 24) | (uint)(changedRed[i] << 16) | (uint)(changedGreen[i] << 8) | (uint)changedBlue[i]);
            //}

            var image = new Bitmap(_width, _height);
            var rct = new Rectangle(0, 0, image.Width, image.Height);
            var bits2 = image.LockBits(rct, ImageLockMode.ReadWrite, PixelFormat.Format32bppArgb);
            Marshal.Copy(dest, 0, bits2.Scan0, dest.Length);
            image.UnlockBits(bits2);
            return image;
        }

        public void GaussBlur(int[] source, int[] destination, int radial)
        {
            Thread[] threads = new Thread[_numberOfThreads];

            if (MainWindow.CurrentCheckboxTextIsCs)
            {
                BlurOne blur = new BlurOne();
                for (int i = 0; i < _numberOfThreads; i++)
                {
                    int heightForThread = _height / _numberOfThreads;
                    int offset = (i / _numberOfThreads) * _height;
                    Thread t = new Thread(new ThreadStart(() => blur.BlurTarget(source, destination, _width, heightForThread * i, radial, offset)));
                    t.Start();
                    threads[i] = t;
                }

                for(int i = 0; i < _numberOfThreads; i++)
                {
                    threads[i].Join();
                }
            }
            else
            {

            }
        }

    }
}
