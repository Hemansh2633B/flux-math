#import "constants.fx";
#import "complex.fx";
#import "power.fx";
#import "trig.fx";

namespace cmath
{
    const int BIG_MAX_LIMBS = 128;
    const int BIG_BASE = 10000000;
    int BIG_GLOBAL_PREC = 16;

    struct BigFloat
    {
        int[128] limbs;
        int exp;
        int size;
        bool neg;
        int prec;
    };

    def big_set_precision(int p) -> void
    {
        if (p < 1) { p = 1; };
        if (p > BIG_MAX_LIMBS) { p = BIG_MAX_LIMBS; };
        BIG_GLOBAL_PREC = p;
        return;
    };

    def big_zero() -> BigFloat
    {
        BigFloat z;
        z.exp = 0;
        z.size = 0;
        z.neg = false;
        z.prec = BIG_GLOBAL_PREC;
        for (int i = 0; i < 128; i++) { z.limbs[i] = 0; };
        return z;
    };

    def big_copy(BigFloat a) -> BigFloat
    {
        return a;
    };

    def big_normalize(BigFloat a) -> BigFloat
    {
        if (a.size == 0) { return a; };

        int first = -1;
        for (int i = 0; i < a.size; i++) {
            if (a.limbs[i] != 0) {
                first = i;
                break;
            };
        };

        if (first == -1) {
            return big_zero();
        };

        if (first > 0) {
            for (int i = 0; i < a.size - first; i++) {
                a.limbs[i] = a.limbs[i + first];
            };
            for (int i = a.size - first; i < 128; i++) {
                a.limbs[i] = 0;
            };
            a.exp = a.exp - first;
            a.size = a.size - first;
        };

        if (a.size > a.prec) {
            a.size = a.prec;
            for (int i = a.size; i < 128; i++) { a.limbs[i] = 0; };
        };

        while (a.size > 0 & a.limbs[a.size - 1] == 0) {
            a.size = a.size - 1;
        };

        if (a.size == 0) { return big_zero(); };
        return a;
    };

    def big_from_double(double x) -> BigFloat
    {
        if (x == 0.0) { return big_zero(); };
        BigFloat res = big_zero();
        if (x < 0.0) {
            res.neg = true;
            x = 0.0 - x;
        };

        double lx = log10(x);
        int e = (int)floor(lx / 7.0);
        res.exp = e;

        double mant = x / pow(10.0, (double)(e * 7));
        if (mant < 1.0) {
            mant = mant * (double)BIG_BASE;
            res.exp = res.exp - 1;
        } else if (mant >= (double)BIG_BASE) {
            mant = mant / (double)BIG_BASE;
            res.exp = res.exp + 1;
        };

        res.size = res.prec;
        for (int i = 0; i < res.prec; i++) {
            int limb = (int)floor(mant);
            res.limbs[i] = limb;
            mant = (mant - (double)limb) * (double)BIG_BASE;
        };
        return big_normalize(res);
    };

    def big_to_double(BigFloat a) -> double
    {
        if (a.size == 0) { return 0.0; };
        double res = 0.0;
        double b = (double)BIG_BASE;
        double inv_b = 1.0 / b;
        double p = 1.0;
        for (int i = 0; i < a.size; i++) {
            res = res + (double)a.limbs[i] * p;
            p = p * inv_b;
        };
        res = res * pow(b, (double)a.exp);
        if (a.neg) { res = 0.0 - res; };
        return res;
    };

    def big_compare_abs(BigFloat a, BigFloat b) -> int
    {
        if (a.size == 0) { return b.size == 0 ? 0 : -1; };
        if (b.size == 0) { return 1; };
        if (a.exp > b.exp) { return 1; };
        if (a.exp < b.exp) { return -1; };
        for (int i = 0; i < 128; i++) {
            int al = (i < a.size) ? a.limbs[i] : 0;
            int bl = (i < b.size) ? b.limbs[i] : 0;
            if (al > bl) { return 1; };
            if (al < bl) { return -1; };
        };
        return 0;
    };

    def big_add(BigFloat a, BigFloat b) -> BigFloat
    {
        if (a.size == 0) { return b; };
        if (b.size == 0) { return a; };
        if (a.neg != b.neg) {
            bool old_neg = b.neg;
            b.neg = !old_neg;
            BigFloat res = big_sub(a, b);
            b.neg = old_neg;
            return res;
        };

        BigFloat res = big_zero();
        res.neg = a.neg;
        res.prec = a.prec > b.prec ? a.prec : b.prec;

        int max_exp = a.exp > b.exp ? a.exp : b.exp;
        res.exp = max_exp;

        double[130] temp;
        for (int i = 0; i < 130; i++) { temp[i] = 0.0; };

        int shift_a = max_exp - a.exp;
        int shift_b = max_exp - b.exp;

        for (int i = 0; i < a.size; i++) {
            if (i + shift_a < 130) { temp[i + shift_a] = temp[i + shift_a] + (double)a.limbs[i]; };
        };
        for (int i = 0; i < b.size; i++) {
            if (i + shift_b < 130) { temp[i + shift_b] = temp[i + shift_b] + (double)b.limbs[i]; };
        };

        double carry = 0.0;
        for (int i = 129; i >= 0; i--) {
            double v = temp[i] + carry;
            double c = floor(v / (double)BIG_BASE);
            temp[i] = v - c * (double)BIG_BASE;
            carry = c;
        };

        if (carry > 0.0) {
            res.exp = res.exp + 1;
            for (int i = 127; i > 0; i--) { res.limbs[i] = (int)temp[i-1]; };
            res.limbs[0] = (int)carry;
        } else {
            for (int i = 0; i < 128; i++) { res.limbs[i] = (int)temp[i]; };
        };
        res.size = 128;
        return big_normalize(res);
    };

    def big_sub(BigFloat a, BigFloat b) -> BigFloat
    {
        if (b.size == 0) { return a; };
        if (a.size == 0) {
            BigFloat res = b;
            res.neg = !b.neg;
            return res;
        };
        if (a.neg != b.neg) {
            bool old_neg = b.neg;
            b.neg = !old_neg;
            BigFloat res = big_add(a, b);
            b.neg = old_neg;
            return res;
        };

        int cmp = big_compare_abs(a, b);
        if (cmp == 0) { return big_zero(); };
        if (cmp < 0) {
            BigFloat res = big_sub(b, a);
            res.neg = !a.neg;
            return res;
        };

        BigFloat res = big_zero();
        res.neg = a.neg;
        res.exp = a.exp;
        res.prec = a.prec > b.prec ? a.prec : b.prec;

        double[128] temp;
        for (int i = 0; i < 128; i++) { temp[i] = (double)a.limbs[i]; };

        int shift = a.exp - b.exp;
        for (int i = 0; i < b.size; i++) {
            if (i + shift < 128) { temp[i + shift] = temp[i + shift] - (double)b.limbs[i]; };
        };

        for (int i = 127; i > 0; i--) {
            if (temp[i] < 0.0) {
                temp[i] = temp[i] + (double)BIG_BASE;
                temp[i-1] = temp[i-1] - 1.0;
            };
        };

        for (int i = 0; i < 128; i++) { res.limbs[i] = (int)temp[i]; };
        res.size = 128;
        return big_normalize(res);
    };

    def big_mul(BigFloat a, BigFloat b) -> BigFloat
    {
        if (a.size == 0 | b.size == 0) { return big_zero(); };
        BigFloat res = big_zero();
        res.neg = a.neg ^ b.neg;
        res.exp = a.exp + b.exp;
        res.prec = a.prec > b.prec ? a.prec : b.prec;

        double[256] temp;
        for (int i = 0; i < 256; i++) { temp[i] = 0.0; };

        for (int i = 0; i < a.size; i++) {
            for (int j = 0; j < b.size; j++) {
                if (i + j < 256) {
                    temp[i + j] = temp[i + j] + (double)a.limbs[i] * (double)b.limbs[j];
                };
            };
        };

        double carry = 0.0;
        for (int i = 255; i >= 0; i--) {
            double v = temp[i] + carry;
            double c = floor(v / (double)BIG_BASE);
            temp[i] = v - c * (double)BIG_BASE;
            carry = c;
        };

        if (carry > 0.0) {
            res.exp = res.exp + 1;
            res.limbs[0] = (int)carry;
            for (int i = 1; i < 128; i++) { res.limbs[i] = (int)temp[i-1]; };
        } else {
            for (int i = 0; i < 128; i++) { res.limbs[i] = (int)temp[i]; };
        };
        res.size = 128;
        return big_normalize(res);
    };

    def big_div(BigFloat a, BigFloat b) -> BigFloat
    {
        if (b.size == 0) { throw(CmathError("big_div: division by zero\0")); };
        if (a.size == 0) { return big_zero(); };

        BigFloat res = big_zero();
        res.neg = a.neg ^ b.neg;
        res.exp = a.exp - b.exp;
        res.prec = a.prec > b.prec ? a.prec : b.prec;

        BigFloat rem = a;
        rem.neg = false;
        rem.exp = 0;

        BigFloat den = b;
        den.neg = false;
        den.exp = 0;

        for (int i = 0; i < res.prec; i++) {
            int cmp = big_compare_abs(rem, den);
            if (cmp < 0) {
                if (i == 0) {
                    res.exp = res.exp - 1;
                    rem = big_mul_int(rem, BIG_BASE);
                    i = i - 1;
                    continue;
                };
            };

            // Estimate limb
            double n = (double)rem.limbs[0];
            if (rem.size > 1) { n = n + (double)rem.limbs[1] / (double)BIG_BASE; };
            double d = (double)den.limbs[0];
            if (den.size > 1) { d = d + (double)den.limbs[1] / (double)BIG_BASE; };

            int q = (int)floor(n / d);
            if (q == 0 & cmp >= 0) { q = 1; };

            BigFloat prod = big_mul_int(den, q);
            while (big_compare_abs(prod, rem) > 0) {
                q = q - 1;
                prod = big_mul_int(den, q);
            };

            res.limbs[i] = q;
            rem = big_sub(rem, prod);
            if (rem.size == 0) { break; };
            rem = big_mul_int(rem, BIG_BASE);
        };
        res.size = res.prec;
        return big_normalize(res);
    };

    def big_mul_int(BigFloat a, int b) -> BigFloat
    {
        if (b == 0 | a.size == 0) { return big_zero(); };
        if (b == 1) { return a; };
        BigFloat res = a;
        double carry = 0.0;
        double db = (double)b;
        for (int i = a.size - 1; i >= 0; i--) {
            double v = (double)a.limbs[i] * db + carry;
            double c = floor(v / (double)BIG_BASE);
            res.limbs[i] = (int)(v - c * (double)BIG_BASE);
            carry = c;
        };
        if (carry > 0.0) {
            for (int i = 127; i > 0; i--) { res.limbs[i] = res.limbs[i-1]; };
            res.limbs[0] = (int)carry;
            res.exp = res.exp + 1;
            if (res.size < 128) { res.size = res.size + 1; };
        };
        return big_normalize(res);
    };

    def big_sqrt(BigFloat a) -> BigFloat
    {
        if (a.neg) { throw(CmathError("big_sqrt: negative input\0")); };
        if (a.size == 0) { return big_zero(); };

        BigFloat x = big_from_double(sqrt(big_to_double(a)));
        BigFloat half = big_from_double(0.5);
        for (int i = 0; i < 6; i++) {
            x = big_mul(half, big_add(x, big_div(a, x)));
        };
        return x;
    };

    def big_exp(BigFloat a) -> BigFloat
    {
        if (a.size == 0) { return big_from_double(1.0); };
        BigFloat res = big_from_double(1.0);
        BigFloat term = big_from_double(1.0);
        for (int i = 1; i < 50; i++) {
            term = big_div(big_mul(term, a), big_from_double((double)i));
            res = big_add(res, term);
            if (term.size == 0) { break; };
        };
        return res;
    };

    def big_log(BigFloat a) -> BigFloat
    {
        if (a.size == 0 | a.neg) { throw(CmathError("big_log: invalid input\0")); };
        // Use Newton's method for log(x): y_{n+1} = y_n + x * exp(-y_n) - 1
        BigFloat y = big_from_double(log(big_to_double(a)));
        for (int i = 0; i < 6; i++) {
            BigFloat ey = big_exp(y);
            y = big_add(y, big_sub(big_div(a, ey), big_from_double(1.0)));
        };
        return y;
    };

    def big_sin(BigFloat a) -> BigFloat
    {
        BigFloat res = big_zero();
        BigFloat term = a;
        BigFloat a2 = big_mul(a, a);
        for (int i = 1; i < 40; i++) {
            res = big_add(res, term);
            term = big_mul(term, a2);
            term = big_div(term, big_from_double((double)(2*i * (2*i + 1))));
            term.neg = !term.neg;
            if (term.size == 0) { break; };
        };
        return res;
    };

    def big_cos(BigFloat a) -> BigFloat
    {
        BigFloat res = big_from_double(1.0);
        BigFloat term = big_from_double(1.0);
        BigFloat a2 = big_mul(a, a);
        for (int i = 1; i < 40; i++) {
            term = big_mul(term, a2);
            term = big_div(term, big_from_double((double)((2*i-1) * (2*i))));
            term.neg = !term.neg;
            res = big_add(res, term);
            if (term.size == 0) { break; };
        };
        return res;
    };

    def big_tan(BigFloat a) -> BigFloat
    {
        return big_div(big_sin(a), big_cos(a));
    };

    def big_pow(BigFloat a, BigFloat b) -> BigFloat
    {
        return big_exp(big_mul(b, big_log(a)));
    };
};
