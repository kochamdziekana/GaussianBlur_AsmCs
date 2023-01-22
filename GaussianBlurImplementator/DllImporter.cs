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
        public static extern int BlurOneAsm(byte[] source, byte[] destination, int width, int height, int radial, int offset);
        
        [DllImport("D:\\GaussianBlurProject\\GaussianBlur\\x64\\Debug\\GaussianBlurCpp.dll")]
        public static extern void BlurTarget(byte[] source, byte[] destination, int width, int height, int radial, int offset);

        [DllImport("D:\\GaussianBlurProject\\GaussianBlur\\x64\\Debug\\GaussianBlurCpp.dll")]
        public static extern void BlurTargetTwoIntrinsics(byte[] image, byte[] output, int width, int height,int offset, float[] kernel, float kernelSum, int kernelSize);

#else
        [DllImport("D:\\GaussianBlurProject\\GaussianBlur\\x64\\Release\\GaussianBlurAsm.dll")]
        public static extern void BlurOneAsm(byte[] source, byte[] destination, int width, int height, int radial, int offset);

        [DllImport("D:\\GaussianBlurProject\\GaussianBlur\\x64\\Release\\GaussianBlurCpp.dll",CallingConvention=CallingConvention.Cdecl)]
        public static extern void BlurTarget(byte[] source, byte[] destination, int width, int height, int radial, int offset);

#endif
    }
}
