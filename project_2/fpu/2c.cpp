#include <stdio.h>

void rnd_gen(double *a, double *c, double *m, double *prev, double *cur) {
    __asm__ __volatile__ (
        "fldl (%2)\n\t"
        "fldl (%3)\n\t"
        "fldl (%0)\n\t"
        "fmulp\n"
        "fldl (%1)\n\t"
        "faddp\n\t"
        "fprem\n\t"
        "fstpl (%4)\n\t"
        "fstpl (%2)\n\t"
        :
        : "d"(a), "c"(c), "b"(m), "D"(prev), "S"(cur)
        :
    );
}

void f(double *p, double *v, double *w) {
    __asm__ __volatile__ (
        "fldl -8(%%rdi)\n\t"
        "fldl -8(%%rsi)\n\t"
        "fmulp\n\t"
        "fldl (%%rdi)\n\t"
        "fldl (%%rsi)\n\t"
        "fmulp\n\t"
        "faddp\n\t"
        "fldl 8(%%rdi)\n\t"
        "fldl 8(%%rsi)\n\t"
        "fmulp\n\t"
        "faddp\n\t"
        "fstpl (%%rbx)\n\t"
        :
        : "S"(p), "D"(v), "b"(w)
        : 
    );
}

double p[] = {0.393, 0.769, 0.189};
double q[] = {0.349, 0.686, 0.168};
double s[] = {0.272, 0.534, 0.131};

int main() {
    double v[33], w[33];
    double a, x, c, m;
    scanf("%lf%lf%lf%lf", &a, &x, &c, &m);
    v[0] = x;
    for (int i = 1; i < 33; i++) {
        rnd_gen(&a, &c, &m, v + i - 1, v + i);
    }
    printf("rnd array: ");
    for (int i = 0; i < 33; i++) {
        printf("%.3lf%c", v[i], " \n"[i == 32]);
    }
    for (int i = 0; i < 33; i += 3) {
        f(p + 1, v + i + 1, w + i);
        f(q + 1, v + i + 1, w + i + 1);
        f(s + 1, v + i + 1, w + i + 2);
    }
    printf("new array: ");
    for (int i = 0; i < 33; i++) {
        printf("%.3lf%c", w[i], " \n"[i == 32]);
    }
    return 0;
}