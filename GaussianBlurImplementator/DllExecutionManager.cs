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

        private readonly byte[] _alphaBytes;
        private readonly byte[] _redBytes;
        private readonly byte[] _greenBytes;
        private readonly byte[] _blueBytes;

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

            _alphaBytes = new byte[_width * _height];
            _redBytes = new byte[_width * _height];
            _greenBytes = new byte[_width * _height];
            _blueBytes = new byte[_width * _height];

            int lenghtForThread = source.Length / _numberOfThreads;
            int lenghtForThreadRemaining = source.Length % _numberOfThreads;

            for (int i = 0; i < _numberOfThreads; i++)
            {
                int currOffset = lenghtForThread * i;
                int currLenght = lenghtForThread * (i + 1);
                _tasks[i] = new Task(() => GetColorsFromSource(source, currOffset, currLenght));
                _tasks[i].Start();
            }

            if(lenghtForThreadRemaining > 0)
            {
                GetColorsFromSource(source, source.Length - lenghtForThreadRemaining, source.Length);
            }

            Task.WaitAll(_tasks);

        }

        public Bitmap ProcessBitmap(int radial)
        {

            var dest = new int[_width * _height];

            var changedAlphaChars = new byte[_width * _height];
            var changedRedChars = new byte[_width * _height];
            var changedGreenChars = new byte[_width * _height];
            var changedBlueChars = new byte[_width * _height];


            GaussBlur(_alphaBytes, changedAlphaChars, radial);
            GaussBlur(_redBytes, changedRedChars, radial);
            GaussBlur(_greenBytes, changedGreenChars, radial);
            GaussBlur(_blueBytes, changedBlueChars, radial);


            int lenghtForThread = dest.Length / _numberOfThreads;
            int lenghtForThreadRemaining = dest.Length % _numberOfThreads;
            _tasks = new Task[MainWindow.ThreadsNumber];

            for(int i = 0; i < _numberOfThreads; i++)
            {
                int currOffset = lenghtForThread * i;
                int currLenght = lenghtForThread * (i + 1);
                _tasks[i] = new Task(() => FillColorsToDestination(dest, currOffset, currLenght, changedAlphaChars, changedRedChars, changedGreenChars, changedBlueChars));
                _tasks[i].Start();
            }

            if(lenghtForThreadRemaining > 0)
            {
                FillColorsToDestination(dest, dest.Length - lenghtForThreadRemaining, dest.Length, changedAlphaChars, changedRedChars, changedGreenChars, changedBlueChars);
            }

            Task.WaitAll(_tasks);

            var image = new Bitmap(_width, _height);
            var rct = new Rectangle(0, 0, image.Width, image.Height);
            var bits2 = image.LockBits(rct, ImageLockMode.ReadWrite, PixelFormat.Format32bppArgb);
            Marshal.Copy(dest, 0, bits2.Scan0, dest.Length);
            image.UnlockBits(bits2);
            return image;
        }

        public void GaussBlur(byte[] source, byte[] destination, int radial)
        {
            int heightForThread = _height / _numberOfThreads;
            int remainer = _height % _numberOfThreads;

            if (MainWindow.CurrentCheckboxTextIsCs)
            {
                for (int i = 0; i < _numberOfThreads; i++)
                {
                    int offset = i * heightForThread;
                    int currHeight = heightForThread * (i + 1);

                    _tasks[i] = new Task(() => DllImporter.BlurTarget(source, destination, _width, currHeight, radial, offset));
                    _tasks[i].Start();
                }

                if (remainer > 0)
                {
                    Task t = new Task(() => DllImporter.BlurTarget(source, destination, _width, heightForThread * _numberOfThreads + remainer, radial, heightForThread * _numberOfThreads));
                    t.Start();
                    t.Wait();
                }
            }
            else
            {
                for (int i = 0; i < _numberOfThreads; i++)
                {
                    int offset = i * heightForThread;
                    int currHeight = heightForThread * (i + 1);
                    _tasks[i] = new Task(() => DllImporter.BlurOneAsm(source, destination, _width, currHeight, radial, offset));
                    _tasks[i].Start();
                }

                if (remainer > 0)
                {
                    Task t = new Task(() => DllImporter.BlurOneAsm(source, destination, _width, heightForThread * _numberOfThreads + remainer, radial, heightForThread * _numberOfThreads));
                    t.Start();
                    t.Wait();
                }
            }
            Task.WaitAll(_tasks);
        }

        private void FillColorsToDestination(int[] dest, int offset, int lenght, byte[] alphas, byte[]reds, byte[] greens, byte[] blues)
        {
            for(int i = offset; i < lenght; i++)
            {
                dest[i] = (int)((uint)(alphas[i] << 24) | (uint)(reds[i] << 16) | (uint)(greens[i] << 8) | (uint)blues[i]);
            }
        }

        private void GetColorsFromSource(int[] source, int offset, int lenght)
        {
            for (int i = offset; i < lenght; i++)
            {
                _alphaBytes[i] = (byte)((source[i] & 0xff000000) >> 24);
                _redBytes[i] = (byte)((source[i] & 0xff0000) >> 16);
                _greenBytes[i] = (byte)((source[i] & 0x00ff00) >> 8);
                _blueBytes[i] = (byte)(source[i] & 0x0000ff);
            }
        }
    }
}