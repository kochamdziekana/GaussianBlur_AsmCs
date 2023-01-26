#include "GaussianBlurCpp.h"
#include "pch.h"
#include <immintrin.h>
#include <xmmintrin.h>
#include <cmath>
#define M_PI 3.14159265358979323846

#define function _declspec(dllexport)
extern "C" {
    function void BlurTarget(unsigned char* source, unsigned char* destination, int width, int height, int offset) {

        int kernel[3][3] = { 1, 2, 1,
                             2, 4, 2,
                             1, 2, 1 };
        
        // k1 = (kernel[0],kernel[1],kernel[2],0)
        // k2 = (kernel[3],kernel[4],kernel[5],0)
        // k3 = (kernel[6],kernel[7],kernel[8],0)


        for (int i = offset; i < height; i++)
            for (int j = 0; j < width; j++)
            {
                double val = 0;
                for (int iy = i - 1; iy < i + 2; iy++) {
                    int y = 0;
                    if (iy > 0) {
                        y = iy;
                    }
                    if (height - 1 < y) {
                        y = height - 1;
                    }
                    //int y = min(height - 1, max(0, iy));
                    for (int ix = j - 1; ix < j + 2; ix++) {
                        //int x = min(width - 1, max(0, ix));
                        int x = 0;
                        if (ix > 0) {
                            x = ix;
                        }
                        if (width - 1 < x) {
                            x = width - 1;
                        }
                        // v1 = (source[y * width + x], source[y * width + x + 1], source[y * width + x + 2], 0)
                        // v2 = (source[y * width + x], source[y * width + x + 1], source[y * width + x + 2], 0) y += 1
                        // v3 = (source[y * width + x], source[y * width + x + 1], source[y * width + x + 2], 0) y += 2

                        val += (double)(((int)source[y * width + x]) * kernel[ix - j + 1][iy - i + 1]); // weight = kernel[a][b], val = sum(weight * source[y * current + x])
                    }                                                        // i - 1 - i + 1 = 0 -> 1 -> 2, j - 1 - j + 1 = 0 -> 1 -> 2
                }

                // z1 = v1 * k1
                // z2 = v2 * k2
                // z3 = v3 * k3
                // z1 = z1 + z2
                // z1 = z1 + z3
                // z1 = haddps(z1)
                // z1 = haddps(z1)

                destination[i * width + j] = (unsigned char)((int)val >> 4);
                // destination[i * width + j] = (int)(z1 >> 4);
            }
    }

    function void BlurTargetTwoIntrinsics(unsigned char* image, unsigned char* output,
        unsigned int width, unsigned int height, int offset, float* kernel, float kernelSum, unsigned int kernelSize) { // kernel is constant so kernelSum also is
        for (int j = offset; j < height; ++j) {
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

                        //buffer += _mm_cvtss_f32(_mm_shuffle_ps(sum, sum, _MM_SHUFFLE(0, 0, 0, 2)));
                        buffer += *(float*)(&sum);
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