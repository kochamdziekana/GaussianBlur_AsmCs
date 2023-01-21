#include "GaussianBlurCpp.h"
#include "pch.h"
#include <immintrin.h>
#include <xmmintrin.h>
#include <cmath>
#define M_PI 3.14159265358979323846

#define function _declspec(dllexport)
extern "C" {
    function void BlurTarget(unsigned char* source, unsigned char* destination, int width, int height, int radial, int offset) {

        int kernel[3][3] = { 1, 2, 1,
                             2, 4, 2,
                             1, 2, 1 };

        double wsum = 16.0;

        //int rs = (int)(radial * 2.57);     // significant radius
        for (int i = offset; i < height; i++)
            for (int j = 0; j < width; j++)
            {
                double val = 0;//, wsum = 0;
                /*for (int iy = i - 1; iy < i + 1 + 1; iy++)
                {
                    for (int ix = j - 1; ix < j + 1 + 1; ix++)
                    {
                        int x = min(width - 1, max(0, ix));
                        int y = min(height - 1, max(0, iy));
                        int dsq = (ix - j) * (ix - j) + (iy - i) * (iy - i);
                        double wght = (exp(-dsq / (2 * radial * radial)) / (M_PI * 2 * radial * radial));
                        val += (double)(source[(y * width + x)] * wght);
                        wsum += wght;
                    }
                }*/

                val = 0;
                for (int iy = i - 1; iy < i + 2; iy++) {
                    for (int ix = j - 1; ix < j + 2; ix++) {
                        int x = min(width - 1, max(0, ix));
                        int y = min(height - 1, max(0, iy));

                        val += (double)(((int)source[y * width + x]) * (int)kernel[ix - j + 1][iy - i + 1]); // weight = kernel[a][b], val = sum(weight * source[y * current + x])
                    }                                                        // i - 1 - i + 1 = 0 -> 1 -> 2, j - 1 - j + 1 = 0 -> 1 -> 2
                }

                destination[i * width + j] = (unsigned char)round(val / wsum);
            }
    }

    function void BlurTargetTwo(unsigned char* image, unsigned char* output,
        unsigned int width, unsigned int height, float* kernel, float kernelSum,
        unsigned int kernelSize) { // kernel is constant so kernelSum also is
        for (int j = 0; j < height - kernelSize; ++j) {
            for (int i = 0; i < width - kernelSize; ++i) {
                float buffer = 0;
                for (int y = 0; y < kernelSize; ++y) {
                    for (int x = 0; x < kernelSize; x += 4) {

                        //__m64 pixels = *(__m64*)(image + (j + y) * width + i + x);
                        //__m128 imageRow = _mm_cvtpi8_ps(pixels);
                        //__m128 kernelRow = _mm_load_ps(kernel + y * kernelSize + i);
                        //__m128 result = _mm_mul_ps(imageRow, kernelRow);

                        buffer += image[(j + y) * width + i + x] * kernel[y * kernelSize + x];
                    }
                }
                output[j * width + i] = buffer / kernelSum; // buffer/kernelSum
            }
        }
    }
}