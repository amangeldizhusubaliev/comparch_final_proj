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

long long wtf;

void f(double *v, double *w) {
    __asm__ __volatile__ (
        "fldl -8(%%rsi)\n\t"
        "fldl (%%rsi)\n\t"
        "fldl 8(%%rsi)\n\t"
        "faddp\n\t"
        "faddp\n\t"
        "mov $3, %%rcx\n\t"
        "mov %%rcx, (%%rdx)\n\t"
        "fildl (%%rdx)\n\t"
        "fdivrp\n\t"
        "fstpl (%%rdi)\n\t"
        :
        : "S"(v), "D"(w), "d"(&wtf)
        : "%rcx"
    );
}

int main() {
    double v[34], w[32];
    double a, x, c, m;
    scanf("%lf%lf%lf%lf", &a, &x, &c, &m);
    v[0] = x;
    for (int i = 1; i < 32; i++) {
        rnd_gen(&a, &c, &m, v + i - 1, v + i);
    }
    v[32] = v[0];
    v[33] = v[1];
    printf("rnd array: ");
    for (int i = 0; i < 32; i++) {
        printf("%.3lf%c", v[i], " \n"[i == 31]);
    }
    for (int i = 0; i < 32; i++) {
        f(v + i + 1, w + i);
    }
    printf("new array: ");
    for (int i = 0; i < 32; i++) {
        printf("%.3lf%c", w[i], " \n"[i == 31]);
    }
    return 0;
}