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
        
        // k1 = (kernel[0],kernel[1],kernel[2],0) xmm0
        // k2 = (kernel[3],kernel[4],kernel[5],0) xmm1
        // k3 = (kernel[6],kernel[7],kernel[8],0) xmm2


        for (int i = offset; i < height; i++)
            for (int j = 0; j < width; j++)
            {
                // xorps xmm6, xmm6, xmm6
                // xorps xmm8, xmm8, xmm8 - z1 vector
                double val = 0;
                for (int iy = i - 1; iy < i + 2; iy++) {
                    // xorps xmm7, xmm7, xmm7
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
                        // movsx eax, BYTE PTR[source[y * width + x]]
                        // pinsrd xmm7, eax, ix - j + 1
                        // v1 = (source[y * width + x], source[y * width + x + 1], source[y * width + x + 2], 0)
                        val += (double)(((int)source[y * width + x]) * kernel[ix - j + 1][iy - i + 1]); // weight = kernel[a][b], val = sum(weight * source[y * current + x])
                    } // i - 1 - i + 1 = 0 -> 1 -> 2, j - 1 - j + 1 = 0 -> 1 -> 2

                    // pinsrd xmm7, DWORD PTR[miejsce wskazuj¹ce na zero], 3
                    // vmulpd xmm6, xmm0, xmm7
                    // z2 = v1 *  
                }

                // z1 = v1 * k1 ; xmm8 += xmm7 * xmm0
                // z2 = v2 * k2 ; xmm8 += xmm7 * xmm1
                // z3 = v3 * k3 ; xmm8 += xmm7 * xmm2
                // z1 = z1 + z2 
                // z1 = z1 + z3
                // z1 = haddps(z1) ; haddps xmm8, xmm8
                // z1 = haddps(z1) ; haddps xmm8, xmm8
                // pextrd eax, xmm8

                destination[i * width + j] = (unsigned char)((int)val >> 4);
                // destination[i * width + j] = (int)(z1 >> 4);
            }
    }


    function void BlurEmptyChanges(unsigned char* source, unsigned char* destination, int width, int height, int offset) {
        int kernel[3][3] = { 1, 2, 1,   // xmm0
                            2, 4, 2,    // xmm1
                            1, 2, 1 };  // xmm2


        // xmm7

        for (int i = offset; i < height; i++)
            for (int j = 0; j < width; j++)
            {
                int y = 0;
                int iy = i - 1;


                // xorps xmm7, xmm7, xmm7

                if (iy > 0) {
                    y = iy;
                }
                if (height - 1 < y) {
                    y = height - 1;
                }
                for (int ix = j - 1; ix < j + 2; ix++) {
                    int x = 0;
                    if (ix > 0) {
                        x = ix;
                    }
                    if (width - 1 < x) {
                        x = width - 1;
                    }
                    // movsx eax, BYTE PTR[source[y * width + x]]
                    // pinsrd xmm7, eax, ix - j + 1
                    // v1 = (source[y * width + x], source[y * width + x + 1], source[y * width + x + 2], 0) // zero will be there because of the xorps
                }

                // vmulpd xmm8, xmm0, xmm7
                // vmovsd xmm9, xmm8

                // xorps xmm7, xmm7, xmm7

                iy++;

                if (iy > 0) {
                    y = iy;
                }
                if (height - 1 < y) {
                    y = height - 1;
                }
                for (int ix = j - 1; ix < j + 2; ix++) {
                    int x = 0;
                    if (ix > 0) {
                        x = ix;
                    }
                    if (width - 1 < x) {
                        x = width - 1;
                    }
                    // movsx eax, BYTE PTR[source[y * width + x]]
                    // pinsrd xmm7, eax, ix - j + 1
                    // v1 = (source[y * width + x], source[y * width + x + 1], source[y * width + x + 2], 0)
                }

                // vmulpd xmm8, xmm1, xmm7
                // vaddpd xmm9, xmm9, xmm8

                // xorps xmm7, xmm7, xmm7

                iy++;

                if (iy > 0) {
                    y = iy;
                }
                if (height - 1 < y) {
                    y = height - 1;
                }
                for (int ix = j - 1; ix < j + 2; ix++) {
                    int x = 0;
                    if (ix > 0) {
                        x = ix;
                    }
                    if (width - 1 < x) {
                        x = width - 1;
                    }
                    // movsx eax, BYTE PTR[source[y * width + x]]
                    // pinsrd xmm7, eax, ix - j + 1
                    // v1 = (source[y * width + x], source[y * width + x + 1], source[y * width + x + 2], 0)
                }
                // vmulpd xmm8, xmm2, xmm7
                // vaddpd xmm9, xmm9, xmm8

                // haddpd xmm9, xmm9
                // haddpd xmm9, xmm9
                // pextrd eax, xmm9 -> eax has the sum
                // sar    eax, 4 -> divide by 16 (kernelSum)


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