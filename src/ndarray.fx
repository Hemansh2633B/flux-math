#import "constants.fx";
#import "bigmath.fx";

namespace cmath
{
    const int ND_MAX_SIZE = 1024;

    struct Matrix
    {
        double[1024] data;
        int rows;
        int cols;
    };

    struct Vector
    {
        double[1024] data;
        int size;
    };

    def mat_new(int rows, int cols) -> Matrix
    {
        if (rows * cols > ND_MAX_SIZE)
        {
            throw(CmathError("mat_new: matrix too large\0"));
        };
        Matrix m;
        m.rows = rows;
        m.cols = cols;
        for (int i = 0; i < ND_MAX_SIZE; i++) { m.data[i] = 0.0; };
        return m;
    };

    def vec_new(int size) -> Vector
    {
        if (size > ND_MAX_SIZE)
        {
            throw(CmathError("vec_new: vector too large\0"));
        };
        Vector v;
        v.size = size;
        for (int i = 0; i < ND_MAX_SIZE; i++) { v.data[i] = 0.0; };
        return v;
    };

    def mat_get(Matrix m, int r, int c) -> double
    {
        return m.data[r * m.cols + c];
    };

    def mat_set(Matrix m, int r, int c, double val) -> Matrix
    {
        m.data[r * m.cols + c] = val;
        return m;
    };

    def mat_add_nd(Matrix A, Matrix B) -> Matrix
    {
        if (A.rows != B.rows | A.cols != B.cols)
        {
            throw(CmathError("mat_add_nd: dimension mismatch\0"));
        };
        Matrix res = mat_new(A.rows, A.cols);
        int total = A.rows * A.cols;
        for (int i = 0; i < total; i++)
        {
            res.data[i] = A.data[i] + B.data[i];
        };
        return res;
    };

    def mat_mul_nd(Matrix A, Matrix B) -> Matrix
    {
        if (A.cols != B.rows)
        {
            throw(CmathError("mat_mul_nd: dimension mismatch\0"));
        };
        Matrix res = mat_new(A.rows, B.cols);
        for (int i = 0; i < A.rows; i++)
        {
            for (int j = 0; j < B.cols; j++)
            {
                double sum = 0.0;
                for (int k = 0; k < A.cols; k++)
                {
                    sum = sum + mat_get(A, i, k) * mat_get(B, k, j);
                };
                res = mat_set(res, i, j, sum);
            };
        };
        return res;
    };

    def mat_transpose_nd(Matrix m) -> Matrix
    {
        Matrix res = mat_new(m.cols, m.rows);
        for (int i = 0; i < m.rows; i++)
        {
            for (int j = 0; j < m.cols; j++)
            {
                res = mat_set(res, j, i, mat_get(m, i, j));
            };
        };
        return res;
    };

    // LU Decomposition for Determinant and Inverse
    struct LUResult
    {
        Matrix L;
        Matrix U;
        bool success;
    };

    def mat_lu(Matrix m) -> LUResult
    {
        if (m.rows != m.cols)
        {
            throw(CmathError("mat_lu: must be square\0"));
        };
        int n = m.rows;
        Matrix L = mat_new(n, n);
        Matrix U = mat_new(n, n);

        for (int i = 0; i < n; i++) {
            L = mat_set(L, i, i, 1.0);
            for (int j = 0; j < n; j++) {
                double sum = 0.0;
                if (i <= j) {
                    for (int k = 0; k < i; k++) {
                        sum = sum + mat_get(L, i, k) * mat_get(U, k, j);
                    };
                    U = mat_set(U, i, j, mat_get(m, i, j) - sum);
                } else {
                    for (int k = 0; k < j; k++) {
                        sum = sum + mat_get(L, i, k) * mat_get(U, k, j);
                    };
                    double u_jj = mat_get(U, j, j);
                    if (u_jj == 0.0) {
                        LUResult res; res.success = false; return res;
                    };
                    L = mat_set(L, i, j, (mat_get(m, i, j) - sum) / u_jj);
                };
            };
        };

        LUResult res;
        res.L = L;
        res.U = U;
        res.success = true;
        return res;
    };

    def mat_det_nd(Matrix m) -> double
    {
        LUResult lu = mat_lu(m);
        if (!lu.success) { return 0.0; };
        double det = 1.0;
        for (int i = 0; i < m.rows; i++) {
            det = det * mat_get(lu.U, i, i);
        };
        return det;
    };

    def mat_inv_nd(Matrix m) -> Matrix
    {
        if (m.rows != m.cols) { throw(CmathError("mat_inv: must be square\0")); };
        int n = m.rows;
        LUResult lu = mat_lu(m);
        if (!lu.success) { throw(CmathError("mat_inv: singular matrix\0")); };

        Matrix inv = mat_new(n, n);
        // Solve AX = I where X is inv
        for (int i = 0; i < n; i++) {
            // Solve Ly = b (b is i-th column of Identity)
            double[1024] y;
            for (int j = 0; j < n; j++) {
                double sum = 0.0;
                for (int k = 0; k < j; k++) {
                    sum = sum + mat_get(lu.L, j, k) * y[k];
                };
                y[j] = (j == i ? 1.0 : 0.0) - sum;
            };

            // Solve Ux = y
            for (int j = n - 1; j >= 0; j--) {
                double sum = 0.0;
                for (int k = j + 1; k < n; k++) {
                    sum = sum + mat_get(lu.U, j, k) * inv.data[k * n + i];
                };
                inv.data[j * n + i] = (y[j] - sum) / mat_get(lu.U, j, j);
            };
        };
        return inv;
    };

    def vec_dot(Vector a, Vector b) -> double
    {
        if (a.size != b.size) { throw(CmathError("vec_dot: dimension mismatch\0")); };
        double sum = 0.0;
        for (int i = 0; i < a.size; i++) {
            sum = sum + a.data[i] * b.data[i];
        };
        return sum;
    };

    def mat_vec_mul_nd(Matrix m, Vector v) -> Vector
    {
        if (m.cols != v.size) { throw(CmathError("mat_vec_mul: dimension mismatch\0")); };
        Vector res = vec_new(m.rows);
        for (int i = 0; i < m.rows; i++) {
            double sum = 0.0;
            for (int j = 0; j < m.cols; j++) {
                sum = sum + mat_get(m, i, j) * v.data[j];
            };
            res.data[i] = sum;
        };
        return res;
    };
};
