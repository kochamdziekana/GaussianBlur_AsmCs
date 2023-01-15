using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GaussianBlur.Blurers
{
    public class BlurOne
    {
        // height for one thread, offset = thread/threads * height of bmp
        public static void BlurTarget(int[] source, int[] destination, int width, int height, int radial, int offset)
        {
            var rs = (int)(radial * 2.57);     // significant radius
            for (var i = offset; i < height; i++)
                for (var j = 0; j < width; j++)
                {
                    double val = 0, wsum = 0;
                    for (var iy = i - rs; iy < i + rs + 1; iy++)
                        for (var ix = j - rs; ix < j + rs + 1; ix++)
                        {
                            var x = Math.Min(width - 1, Math.Max(0, ix));
                            var y = Math.Min(height - 1, Math.Max(0, iy));
                            var dsq = (ix - j) * (ix - j) + (iy - i) * (iy - i);
                            var wght = (Math.Exp(-dsq / (2 * radial * radial)) / (Math.PI * 2 * radial * radial));
                            val += (double)(source[(y * width + x)] * wght);
                            wsum += wght;
                        }
                    destination[i * width + j] = (int)Math.Round(val / wsum);
                }
        }
    }
}
