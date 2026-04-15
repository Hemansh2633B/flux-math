#import "constants.fx";
#import "ndarray.fx";

namespace cmath
{
    struct PCG32
    {
        ulong state;
        ulong inc;
    };

    def pcg32_random(PCG32 rng) -> uint
    {
        ulong oldstate = rng.state;
        rng.state = oldstate * 6364136223846793005uL + (rng.inc | 1uL);
        uint xorshifted = (uint)(((oldstate >> 18uL) ^ oldstate) >> 27uL);
        uint rot = (uint)(oldstate >> 59uL);
        return (xorshifted >> rot) | (xorshifted << ((0u - rot) & 31u));
    };

    def pcg32_init(ulong seed, ulong seq) -> PCG32
    {
        PCG32 rng;
        rng.state = 0uL;
        rng.inc = (seq << 1uL) | 1uL;
        pcg32_random(rng);
        rng.state = rng.state + seed;
        pcg32_random(rng);
        return rng;
    };

    PCG32 GLOBAL_RNG = pcg32_init(42uL, 54uL);

    def seed(ulong s) -> void
    {
        GLOBAL_RNG = pcg32_init(s, 54uL);
        return;
    };

    def rand_u32() -> uint
    {
        return pcg32_random(GLOBAL_RNG);
    };

    def rand_f64() -> double
    {
        return (double)rand_u32() / 4294967296.0;
    };

    def rand_range(double min, double max) -> double
    {
        return min + (max - min) * rand_f64();
    };

    def rand_int(int min, int max) -> int
    {
        if (min >= max) { return min; };
        return min + (int)(rand_u32() % (uint)(max - min));
    };
};
