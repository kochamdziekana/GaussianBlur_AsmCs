using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

namespace GaussianBlurImplementator
{
    public static class BenchmarkManager
    {

        [DllImport("kernel32.dll", SetLastError = true)]
        [return: MarshalAs(UnmanagedType.Bool)]
        static extern bool AllocConsole();

        public static void CreateBenchmark()
        {
            AllocConsole();
            string consoleLog = string.Empty;

            if (MainWindow.CurrentCheckboxTextIsCs)
            {
                consoleLog = "Currently benchmark is made for C++.";
            }
            else
            {
                consoleLog = "Currently benchmark is made for Assembly.";
            }

            Console.WriteLine(consoleLog);

            var currentNumberOfThreads = 2;

            for (int k = 0; k < 7; k++)
            {
                currentNumberOfThreads = currentNumberOfThreads * 2;
                MainWindow.ThreadsNumber = (int)currentNumberOfThreads;

                consoleLog = $" Running on {MainWindow.ThreadsNumber} threads.";

                Console.WriteLine(consoleLog);

                for (int i = 2; i < 11; i++)
                {
                    long meanBlurTime = 0;

                    string filename = @"D:\GaussianBlurProject\GaussianBlur\Tests\Test" + i.ToString();

                    if (i == 3 || i == 5 || i == 8)
                    {
                        filename += ".png";
                    }
                    else
                    {
                        filename += ".jpg";
                    }

                    Bitmap bitmap = Image.FromFile(filename) as Bitmap;
                    Console.WriteLine($"File path: {filename}");
                    Console.WriteLine($"Bitmap size is: {bitmap.Size}");

                    for (int j = 0; j < 20; j++)
                    {
                        var manager = new DllExecutionManager(bitmap);

                        var sw = Stopwatch.StartNew();
                        manager.ProcessBitmap(3);
                        var timeElapsed = sw.ElapsedMilliseconds;
                        meanBlurTime += timeElapsed;

                        Console.WriteLine($"Try number {j}. It took: {timeElapsed} ms to blur this image.");
                    }

                    Console.WriteLine($"Mean: {meanBlurTime / 20.0} ms.");

                }
            }
            MainWindow.ThreadsNumber = 1;
        }
    }
}
