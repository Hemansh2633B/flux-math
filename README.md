# MATH-4-FLUX
A standard MATH libraray for FLUX 
# 📦 flux-math

> A complete mathematical library for the Flux programming language — inspired by Python’s `math` module.

---

## 🚀 Overview

`flux-math` is a standard-style math library for Flux that provides a wide range of mathematical functions including:

* Arithmetic utilities
* Number theory functions
* Algebra & logarithms
* Trigonometry
* Floating-point helpers
* Mathematical constants

This library is heavily inspired by Python’s math module, which provides “common mathematical functions and constants” for computation ([Python documentation][1]).

---

## ✨ Features

* 🔢 Core math functions (`abs`, `floor`, `ceil`)
* 🧮 Number theory (`gcd`, `factorial`, `lcm`)
* 📈 Algebra (`sqrt`, `pow`, `log`, `exp`)
* 🔺 Trigonometry (`sin`, `cos`, `tan`)
* ⚡ Floating-point utilities (`isfinite`, `isnan`, `isclose`)
* 📐 Constants (`PI`, `E`, `TAU`)

---

## 📁 Project Structure

```
flux-math/
├── src/
│   ├── core.fx
│   ├── number.fx
│   ├── algebra.fx
│   ├── trig.fx
│   ├── float.fx
│   ├── constants.fx
│   └── main.fx
└── package.json
```

---

## 📦 Installation

Add the package source:

```
fpm addsource https://github.com/yourusername/flux-math/package.json
```

Install the package:

```
fpm install flux-math
```

---

## 🔧 Usage

```flux
import math

fn main() {
    print(math.sqrt(16));
    print(math.sin(1.57));
    print(math.factorial(5));
}
```

---

## 📚 Available Modules

### 🔹 Core

* `abs(x)`
* `floor(x)`
* `ceil(x)`
* `trunc(x)`

### 🔹 Number Theory

* `gcd(a, b)`
* `lcm(a, b)`
* `factorial(n)`

### 🔹 Algebra

* `pow(x, y)`
* `sqrt(x)`
* `exp(x)`
* `log(x)`

### 🔹 Trigonometry

* `sin(x)`
* `cos(x)`
* `tan(x)`
* `atan(x)`

### 🔹 Floating Utilities

* `isfinite(x)`
* `isinf(x)`
* `isnan(x)`
* `isclose(a, b, tol)`

### 🔹 Constants

* `PI`
* `E`
* `TAU`
* `INF`
* `NAN`

---

## ⚠️ Limitations

* ⚠️ Uses approximations (not IEEE-accurate yet)
* ⚠️ No complex number support
* ⚠️ Limited precision compared to native implementations

Python’s math module relies on optimized C implementations for high accuracy and performance ([GeeksforGeeks][2]) — this library is a pure Flux implementation.

---

## 🛣️ Roadmap

### v1.1

* Add `log10`, `log2`
* Improve trig accuracy
* Add `clamp`, `lerp`

### v2.0

* Matrix & vector math
* Random number generation
* Statistical functions

### v3.0

* Native bindings (high performance)
* Scientific computing support

---

## 🤝 Contributing

Contributions are welcome!

1. Fork the repo
2. Create a new branch
3. Add your feature
4. Submit a pull request

---

## 📜 License

MIT License

---

## 💡 Inspiration

This project is inspired by:

* Python `math` module
* Standard libraries in modern languages

---

## ⭐ Support

If you like this project:

* ⭐ Star the repo
* 🧑‍💻 Contribute
* 🚀 Build with Flux

---

**Made with ❤️ for the Flux ecosystem**

[1]: https://docs.python.org/3/library/math.html?utm_source=chatgpt.com "math — Mathematical functions — Python 3.14.4 documentation"
[2]: https://www.geeksforgeeks.org/python/python-math-module/?utm_source=chatgpt.com "Python Math Module - GeeksforGeeks"
