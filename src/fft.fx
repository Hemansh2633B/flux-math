#import "constants.fx";
#import "complex.fx";
#import "polar.fx";

namespace cmath
{
    def fft_inplace(Complex[1024] data, int n) -> Complex[1024]
    {
        // Bit-reversal permutation
        int j = 0;
        for (int i = 0; i < n; i++) {
            if (i < j) {
                Complex temp = data[i];
                data[i] = data[j];
                data[j] = temp;
            };
            int m = n >> 1;
            while (m >= 1 & j >= m) {
                j = j - m;
                m = m >> 1;
            };
            j = j + m;
        };

        // Cooley-Tukey decimation-in-time
        for (int len = 2; len <= n; len = len << 1) {
            double ang = TAU / (double)len;
            Complex wlen = rect(1.0, 0.0 - ang);
            for (int i = 0; i < n; i = i + len) {
                Complex w = ONE;
                for (int k = 0; k < len / 2; k++) {
                    Complex u = data[i + k];
                    Complex v = mul(data[i + k + len / 2], w);
                    data[i + k] = add(u, v);
                    data[i + k + len / 2] = sub(u, v);
                    w = mul(w, wlen);
                };
            };
        };
        return data;
    };

    def ifft_inplace(Complex[1024] data, int n) -> Complex[1024]
    {
        // Conjugate inputs
        for (int i = 0; i < n; i++) {
            data[i] = conj(data[i]);
        };

        fft_inplace(data, n);

        // Conjugate outputs and scale
        double inv_n = 1.0 / (double)n;
        for (int i = 0; i < n; i++) {
            data[i] = scale(conj(data[i]), inv_n);
        };
        return data;
    };
};
