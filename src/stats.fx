#import "constants.fx";
#import "power.fx";
#import "erf.fx";
#import "random.fx";
#import "ndarray.fx";

namespace cmath
{
    // Uniform Distribution
    def uniform_pdf(double x, double a, double b) -> double
    {
        if (x >= a & x <= b) { return 1.0 / (b - a); };
        return 0.0;
    };

    def uniform_cdf(double x, double a, double b) -> double
    {
        if (x < a) { return 0.0; };
        if (x > b) { return 1.0; };
        return (x - a) / (b - a);
    };

    def uniform_sample(double a, double b) -> double
    {
        return rand_range(a, b);
    };

    // Normal (Gaussian) Distribution
    def normal_pdf(double x, double mu, double sigma) -> double
    {
        double diff = x - mu;
        double expo = -0.5 * (diff * diff) / (sigma * sigma);
        return (1.0 / (sigma * sqrt(TAU))) * exp(expo);
    };

    def normal_cdf(double x, double mu, double sigma) -> double
    {
        return 0.5 * (1.0 + erf((x - mu) / (sigma * SQRT2)));
    };

    bool has_spare = false;
    double spare = 0.0;

    def normal_sample(double mu, double sigma) -> double
    {
        if (has_spare) {
            has_spare = false;
            return mu + sigma * spare;
        };

        double u, v, s;
        do {
            u = rand_range(-1.0, 1.0);
            v = rand_range(-1.0, 1.0);
            s = u * u + v * v;
        } while (s >= 1.0 | s == 0.0);

        double mul = sqrt(-2.0 * log(s) / s);
        spare = v * mul;
        has_spare = true;
        return mu + sigma * u * mul;
    };

    // Statistical functions
    def mean(Vector v) -> double
    {
        if (v.size == 0) { return 0.0; };
        double sum = 0.0;
        for (int i = 0; i < v.size; i++) {
            sum = sum + v.data[i];
        };
        return sum / (double)v.size;
    };

    def variance(Vector v) -> double
    {
        if (v.size <= 1) { return 0.0; };
        double m = mean(v);
        double sum = 0.0;
        for (int i = 0; i < v.size; i++) {
            double diff = v.data[i] - m;
            sum = sum + diff * diff;
        };
        return sum / (double)(v.size - 1);
    };

    def std_dev(Vector v) -> double
    {
        return sqrt(variance(v));
    };
};
