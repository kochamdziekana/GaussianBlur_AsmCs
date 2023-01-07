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

        private Task[] _tasks = new Task[MainWindow.ThreadsNumber];

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

            //GaussBlur(_alpha, changedAlpha, radial);
            //GaussBlur(_red, changedRed, radial);
            //GaussBlur(_green, changedGreen, radial);
            //GaussBlur(_blue, changedBlue, radial);

            //var threads = new Thread[_numberOfThreads];
            //var lenghtForThread = dest.Length / _numberOfThreads;

            //for (int i = 0; i < _numberOfThreads; i++)
            //{
            //    var thread = new Thread(new ThreadStart(() => UnifyColors(i * lenghtForThread, lenghtForThread, changedAlpha, changedRed, changedGreen, changedBlue, dest)));
            //    thread.Start();
            //    threads[i] = thread;
            //}// color unification from down there

            //for(int i = 0; i < _numberOfThreads; i++)
            //{
            //    threads[i].Join();
            //}

            foreach (var task in _tasks)
            {
                task.Wait();
            }

            Parallel.For(0, dest.Length, new ParallelOptions { MaxDegreeOfParallelism = _numberOfThreads }, i =>
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

            var image = new Bitmap(_width, _height);
            var rct = new Rectangle(0, 0, image.Width, image.Height);
            var bits2 = image.LockBits(rct, ImageLockMode.ReadWrite, PixelFormat.Format32bppArgb);
            Marshal.Copy(dest, 0, bits2.Scan0, dest.Length);
            image.UnlockBits(bits2);
            return image;
        }

        public void GaussBlur(int[] source, int[] destination, int radial)
        {
            //Thread[] threads = new Thread[_numberOfThreads];

            if (MainWindow.CurrentCheckboxTextIsCs)
            {
                int heightForThread = _height / _numberOfThreads;
                for (int i = 0; i < _numberOfThreads; i++)
                {
                    int offset = i * (_height / _numberOfThreads);
                    //Thread t = new Thread(new ThreadStart(() => BlurOne.BlurTarget(source, destination, _width, heightForThread * i, radial, offset)));
                    //t.Start();
                    //threads[i] = t;
                    _tasks[i] = new Task(() => BlurOne.BlurTarget(source, destination, _width, heightForThread * i, radial, offset));
                    _tasks[i].Start();
                }

                //for (int i = 0; i < _numberOfThreads; i++)
                //{
                //    tasks[i].Wait();
                //}

                Task.WaitAll(_tasks);
            }
            else
            {

            }
        }

        private void UnifyColors(int beggining, int length, int[] changedAlpha, int[] changedRed, int[] changedGreen, int[] changedBlue, int[] dest)
        {
            for (int i = beggining; i < length; i++)
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
            }

        }
    }
}