using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

namespace GaussianBlurImplementator
{
    public static class DllImporter
    {
#if DEBUG
        [DllImport("D:\\GaussianBlurProject\\GaussianBlur\\x64\\Debug\\GaussianBlurAsm.dll")]
        public static extern int BlurOneAsm(int[] source, int[] destination, int width, int height, int radial, int offset);
        
        [DllImport("D:\\GaussianBlurProject\\GaussianBlur\\x64\\Debug\\GaussianBlurCpp.dll")]
        public static extern int BlurTarget(int[] source, int[] destination, int width, int height, int radial, int offset);

#else
        [DllImport("D:\\GaussianBlurProject\\GaussianBlur\\x64\\Release\\GaussianBlurAsm.dll")]
        public static extern void BlurOneAsm(int[] source, int[] destination, int width, int height, int radial, int offset);

        [DllImport("D:\\GaussianBlurProject\\GaussianBlur\\x64\\Release\\GaussianBlurCpp.dll",CallingConvention=CallingConvention.Cdecl)]
        public static extern void BlurTarget(int[] source, int[] destination, int width, int height, int radial, int offset);

#endif
    }
}
