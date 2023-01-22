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
        /*
        __m128i kernelOne;
        __m128i kernelTwo;
        __m128i kernelThree;
        
        for (int i = 0; i < 3; i++) {
            kernelOne = _mm_insert_epi8(kernelOne, kernel[0][i], i);
            kernelTwo = _mm_insert_epi8(kernelOne, kernel[1][i], i);
            kernelThree = _mm_insert_epi8(kernelOne, kernel[2][i], i);
        }*/

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

                val = 0;

                destination[i * width + j] = (unsigned char)round(val / wsum);
            }
    }

    function void BlurTargetTwoIntrinsics(unsigned char* image, unsigned char* output,
        unsigned int width, unsigned int height, int offset, float* kernel, float kernelSum, unsigned int kernelSize) { // kernel is constant so kernelSum also is
        for (int j = offset; j < height - kernelSize; ++j) {
            for (int i = 0; i < width - kernelSize; ++i) {
                float buffer = 0;
                for (int y = 0; y < kernelSize; y++) {
                    for (int x = 0; x < kernelSize; x += 4) {

                        UINT32 pixels = *(UINT32*)(image + (j + y) * width + i + x); // x x x x 
                        __m128i convertedPixels = _mm_set1_epi32(0);
                        convertedPixels = _mm_insert_epi32(convertedPixels, pixels, 0);
                        __m128i pixelVector = _mm_cvtepu8_epi32(convertedPixels);
                        __m128 convertedIntegers = _mm_cvtepi32_ps(pixelVector);
                        __m128 kernelRow = _mm_load_ps(kernel + y * kernelSize + x);
                        __m128 result = _mm_mul_ps(convertedIntegers, kernelRow);

                        __m128 sum = _mm_hadd_ps(result, result);
                        sum = _mm_hadd_ps(sum, sum);

                        buffer += _mm_cvtss_f32(_mm_shuffle_ps(sum, sum, _MM_SHUFFLE(0, 0, 0, 2)));
                    }
                }
                output[j * width + i] = buffer / kernelSum; // buffer/kernelSum
            }
            // x x x
            // x x x
            // x x x
        }
    }
}