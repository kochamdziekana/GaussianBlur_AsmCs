#include "GaussianBlurCpp.h"
#include "pch.h"
#include <cmath>
#define M_PI 3.14159265358979323846

#define function _declspec(dllexport)
extern "C" {
    function void BlurTarget(int* source, int* destination, int width, int height, int radial, int offset) {

        int rs = (int)ceil(radial * 2.57);     // significant radius
        for (int i = offset; i < height; i++)
            for (int j = 0; j < width; j++)
            {
                double val = 0, wsum = 0;
                for (int iy = i - rs; iy < i + rs + 1; iy++)
                    for (int ix = j - rs; ix < j + rs + 1; ix++)
                    {
                        int x = min(width - 1, max(0, ix));
                        int y = min(height - 1, max(0, iy));
                        int dsq = (ix - j) * (ix - j) + (iy - i) * (iy - i);
                        double wght = (exp(-dsq / (2 * radial * radial)) / (M_PI * 2 * radial * radial));
                        val += (double)(source[(y * width + x)] * wght);
                        wsum += wght;
                    }
                destination[i * width + j] = (int)round(val / wsum);
            }
    }
}