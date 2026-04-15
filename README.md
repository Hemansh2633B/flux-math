
# 📦 flux-cMath

> A comprehensive mathematical library for the Flux programming language — featuring complex analysis, special functions, and numerical methods.

---

## 🚀 Overview

`flux-cMath` is an advanced mathematical library for Flux that provides 150+ functions across complex arithmetic, special functions, numerical analysis, and signal processing. Inspired by Python's `math` and `cmath` modules, it brings industrial-strength mathematical capabilities to Flux with full complex number support.

This library extends beyond basic math to include:
* Complex number operations
* Special functions (Gamma, Bessel, Zeta)
* Matrix algebra and Möbius transformations
* Numerical integration and root finding
* Signal processing tools
* Advanced error functions and Fresnel integrals

---

## ✨ Features

* 🔢 **Complex Arithmetic** — Full complex number support with proper branch cuts
* 🧮 **Special Functions** — Gamma, Beta, Bessel, Error functions, Zeta functions
* 📈 **Advanced Algebra** — Matrix operations, Möbius transforms, Lambert W function
* 🔺 **Trigonometry & Hyperbolics** — Extended to complex domain with exotic functions
* ⚡ **Numerical Methods** — Root finding, integration, differentiation
* 📊 **Signal Processing** — DFT tools, window functions, phase analysis
* 📐 **Constants & Classification** — 17+ mathematical constants, type predicates
* 🧪 **Scientific Computing** — Ready for physics, engineering, and quantum computing

---

## 📁 Project Structure

```
flux-cMath/
├── src/
│   ├── cmath.fx           # Main orchestrator & namespace
│   ├── constants.fx       # Mathematical constants
│   ├── complex.fx         # Complex number operations
│   ├── polar.fx           # Polar/Cartesian conversions
│   ├── power.fx           # Exponentials, powers, roots
│   ├── trig.fx            # Trigonometric functions
│   ├── hyperbolic.fx      # Hyperbolic functions
│   ├── classify.fx        # Type checking & classification
│   ├── special.fx         # Gamma, Beta, Digamma
│   ├── erf.fx             # Error functions
│   ├── bessel.fx          # Bessel functions
│   ├── zeta.fx            # Zeta & integral functions
│   ├── lambert.fx         # Lambert W function
│   ├── fresnel.fx         # Fresnel integrals
│   ├── signal.fx          # DSP utilities
│   ├── matrix.fx          # 2×2 complex matrices
│   ├── mobius.fx          # Möbius transformations
│   ├── numeric.fx         # Numerical methods
│   └── format.fx          # Output formatting
├── package.json
├── README.md
└── LICENSE
```

---

## 📦 Installation

Add the package source:

```
fpm addsource https://github.com/yourusername/flux-cMath/package.json
```

Install the package:

```
fpm install flux-cMath
```

---

## 🔧 Usage

### Basic Usage

```flux
import cmath

fn main() {
    // Real math
    print(cmath.sqrt(16.0));        // 4.0
    print(cmath.sin(cmath.PI/2));   // 1.0
    print(cmath.factorial_c(5));    // 120.0

    // Complex numbers
    let z = cmath.complex(3.0, 4.0);  // 3 + 4i
    print(cmath.abs_c(z));            // 5.0
    print(cmath.exp(cmath.I * cmath.PI));  // -1 + 0i (Euler's identity)
}
```

### Complex Arithmetic

```flux
import cmath

fn complex_demo() {
    let a = cmath.complex(1.0, 2.0);  // 1 + 2i
    let b = cmath.complex(3.0, -1.0); // 3 - i

    let sum = cmath.add(a, b);        // 4 + i
    let prod = cmath.mul(a, b);       // 5 + 5i
    let sqrt_a = cmath.sqrt(a);       // Complex square root

    print(cmath.format_complex(sum));   // "4.000000 + 1.000000i"
    print(cmath.format_complex(prod));  // "5.000000 + 5.000000i"
}
```

### Special Functions

```flux
import cmath

fn special_functions() {
    // Gamma function
    print(cmath.gamma_c(0.5));  // √π ≈ 1.77245

    // Bessel functions
    print(cmath.besselj_c(0, 1.0));  // J₀(1) ≈ 0.76520

    // Error functions
    print(cmath.erf_c(1.0));  // erf(1) ≈ 0.84270

    // Zeta function
    print(cmath.zeta(2.0));  // ζ(2) = π²/6 ≈ 1.64493
}
```

### Matrix Operations

```flux
import cmath

fn matrix_demo() {
    let m1 = cmath.matrix_identity();
    let m2 = cmath.matrix_pauli_x();

    let prod = cmath.matrix_mul(m1, m2);
    let exp_m = cmath.matrix_exp(m2);

    print(cmath.matrix_det(prod));  // Determinant
    print(cmath.matrix_trace(exp_m));  // Trace
}
```

### Numerical Methods

```flux
import cmath

fn numerical_demo() {
    // Root finding
    let root = cmath.newton_raphson(
        |z| cmath.sub(cmath.mul(z, z), cmath.complex(2.0, 0.0)),  // z² - 2 = 0
        |z| cmath.scale(z, 2.0),  // derivative: 2z
        cmath.complex(1.5, 0.0)   // initial guess
    );

    // Integration
    let integral = cmath.integrate_simpson(
        |x| cmath.sin(x),  // ∫ sin(x) dx from 0 to π
        0.0, cmath.PI, 100
    );

    print(cmath.format_complex(root));  // ≈ 1.4142135623730951 + 0i
    print(integral);  // ≈ 2.0
}
```

### Signal Processing

```flux
import cmath

fn signal_demo() {
    // Window functions
    let window = cmath.hann_window(1024);

    // DFT twiddle factors
    let twiddle = cmath.dft_twiddle(512, 1);

    // Sinc function
    print(cmath.sinc(0.5));  // sinc(0.5) ≈ 0.63662
}
```

---

## 📚 Available Modules

### 🔹 Complex Arithmetic
* `complex(real, imag)` — Create complex number
* `add(a, b)`, `sub(a, b)`, `mul(a, b)`, `div(a, b)` — Basic operations
* `abs_c(z)`, `arg(z)`, `conj(z)`, `recip(z)` — Properties
* `polar(z)`, `rect(r, phi)` — Coordinate conversion

### 🔹 Power & Exponential
* `exp(z)`, `log(z)`, `sqrt(z)`, `cbrt(z)` — Basic functions
* `pow_c(base, exp)`, `root_n(z, n)` — Powers and roots
* `roots_of_unity(n)` — nth roots of unity

### 🔹 Trigonometry
* `sin(z)`, `cos(z)`, `tan(z)`, `sec(z)`, `csc(z)` — Direct functions
* `asin(z)`, `acos(z)`, `atan(z)` — Inverse functions
* `versin(z)`, `haversin(z)` — Exotic trigonometric functions

### 🔹 Hyperbolic Functions
* `sinh(z)`, `cosh(z)`, `tanh(z)` — Direct functions
* `asinh(z)`, `acosh(z)`, `atanh(z)` — Inverse functions
* `sech(z)`, `csch(z)` — Reciprocal functions

### 🔹 Special Functions
* `gamma_c(z)`, `lgamma_c(z)` — Gamma function and log-gamma
* `beta_c(a, b)` — Beta function
* `digamma_c(z)` — Digamma function
* `besselj_c(n, z)`, `bessely_c(n, z)` — Bessel functions of first/second kind
* `besseli_c(n, z)`, `besselk_c(n, z)` — Modified Bessel functions
* `erf_c(z)`, `erfc_c(z)`, `erfi_c(z)` — Error functions

### 🔹 Advanced Functions
* `zeta(s)`, `hurwitz_zeta(s, a)` — Zeta functions
* `eta(s)` — Dirichlet eta function
* `lambertw(z, branch)` — Lambert W function (multi-branch)
* `fresnel_s(z)`, `fresnel_c(z)` — Fresnel integrals
* `ei(z)`, `li(z)` — Exponential and logarithmic integrals

### 🔹 Matrix Algebra
* `matrix_mul(a, b)`, `matrix_add(a, b)` — Basic operations
* `matrix_inv(m)`, `matrix_det(m)`, `matrix_trace(m)` — Properties
* `matrix_exp(m)`, `matrix_pow(m, n)` — Advanced operations
* `matrix_eigenvalues(m)` — Eigenvalue computation
* Pauli matrices: `matrix_pauli_x()`, `matrix_pauli_y()`, `matrix_pauli_z()`

### 🔹 Möbius Transformations
* `mobius_apply(t, z)` — Apply transformation
* `mobius_compose(t1, t2)` — Compose transformations
* `mobius_fixed_points(t)` — Find fixed points
* Classification: elliptic, hyperbolic, parabolic, loxodromic

### 🔹 Numerical Methods
* `newton_raphson(f, df, x0)` — Root finding
* `halley_method(f, df, ddf, x0)` — Higher-order root finding
* `integrate_rectangle(f, a, b, n)` — Numerical integration (rectangle rule)
* `integrate_trapezoidal(f, a, b, n)` — Trapezoidal rule
* `integrate_simpson(f, a, b, n)` — Simpson's rule
* `derivative(f, x, h)` — Numerical differentiation

### 🔹 Signal Processing
* Window functions: `hann_window(n)`, `hamming_window(n)`, `blackman_window(n)`
* `dft_twiddle(n, k)` — DFT twiddle factors
* `sinc(x)` — Sinc function
* `instantaneous_phase(z)`, `group_delay(z)` — Phase analysis

### 🔹 Classification & Utilities
* `isfinite(z)`, `isnan(z)`, `isinf(z)` — Type checking
* `isreal(z)`, `isimag(z)`, `iszero(z)` — Complex properties
* `isclose(a, b, tol)` — Approximate equality
* `quadrant(z)` — Determine complex quadrant

### 🔹 Constants
* `PI`, `E`, `TAU` — Fundamental constants
* `PHI` (golden ratio), `SQRT2`, `SQRT3` — Algebraic constants
* `INF`, `NAN` — Special values
* `I` (imaginary unit), `ZERO`, `ONE` — Complex constants

---

## ⚠️ Limitations

* ⚠️ Pure Flux implementation (no native C bindings yet)
* ⚠️ Limited to double precision (64-bit floating point)
* ⚠️ Some functions may have edge case inaccuracies near branch cuts
* ⚠️ Matrix operations currently limited to 2×2 complex matrices

For IEEE-754 compliant accuracy, consider native C bindings in future versions.

---

## 🛣️ Roadmap

### v1.1 (Current)
* ✅ Complex number support
* ✅ Special functions (Gamma, Bessel, Error, Zeta)
* ✅ Matrix algebra and Möbius transforms
* ✅ Numerical methods and signal processing
* ✅ Comprehensive test suite

### v2.0
* Arbitrary precision arithmetic
* N-dimensional matrices and vectors
* Random number generation
* Statistical distributions and functions
* FFT implementation

### v3.0
* Native C bindings for performance
* GPU acceleration support
* Parallel computing primitives
* Scientific computing ecosystem integration

---

## 🤝 Contributing

Contributions are welcome! The library is designed with modularity in mind.

1. Fork the repo
2. Create a new branch (`git checkout -b feature/amazing-feature`)
3. Add your feature in the appropriate `.fx` module
4. Update tests and documentation
5. Submit a pull request

### Development Setup

```bash
# Clone and setup
git clone https://github.com/yourusername/flux-cMath.git
cd flux-cMath

# Run tests (assuming Flux test runner)
flux test

# Build documentation
flux doc
```

---

## 📜 License

MIT License — see [LICENSE](LICENSE) for details.

---

## 💡 Inspiration

This project draws inspiration from:

* Python's `math` and `cmath` modules
* MATLAB's mathematical functions
* SciPy's special functions
* Standard mathematical libraries in modern languages

---

## ⭐ Support

If you like this project:

* ⭐ Star the repo on GitHub
* 🧑‍💻 Contribute features or bug fixes
* 🚀 Build amazing things with Flux
* 📚 Share your mathematical discoveries

---

## 📞 Contact

For questions, issues, or contributions:
- GitHub Issues: [Report bugs or request features](https://github.com/yourusername/flux-cMath/issues)
- Discussions: [Share ideas and get help](https://github.com/yourusername/flux-cMath/discussions)

---

**Made with ❤️ for the Flux ecosystem — powering scientific computing, engineering, and mathematical exploration.**
