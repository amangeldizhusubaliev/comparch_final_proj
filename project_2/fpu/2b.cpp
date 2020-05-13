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

void f(double *b, double *c, double *cur) {
    __asm__ __volatile__ (
        "fldl (%2)\n\t"
        "fldl (%0)\n\t"
        "fmulp\n\t"
        "fldl (%1)\n\t"
        "faddp\n\t"
        "fstpl (%2)\n\t"
        :
        : "S"(c), "D"(b), "b"(cur)
        :
    );
}

int main() {
    double v[32];
    double a, x, c, m, b;
    scanf("%lf%lf%lf%lf", &a, &x, &c, &m);
    v[0] = x;
    for (int i = 1; i < 32; i++) {
        rnd_gen(&a, &c, &m, v + i - 1, v + i);
    }
    printf("rnd array: ");
    for (int i = 0; i < 32; i++) {
        printf("%.3lf%c", v[i], " \n"[i == 31]);
    }
    scanf("%lf%lf", &b, &c);
    printf("new array: ");
    for (int i = 0; i < 32; i++) {
        f(&b, &c, v + i);
        printf("%.3lf%c", v[i], " \n"[i == 31]);
    }
    return 0;
}