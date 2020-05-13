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

void f(double *b, double *c, double *v, double *w) {
    __asm__ __volatile__ (
        "mov $255, %%rax\n\t"
        "mov %%rax, (%%rbx)\n\t"
        "fildl (%%rbx)\n\t"
        "fldl (%%rdx)\n\t"
        "fdivrp\n\t"
        "mov $2, %%rax\n\t"
        "mov %%rax, (%%rbx)\n\t"
        "fildl (%%rbx)\n\t"
        "fdivrp\n\t"
        "fldl (%%rcx)\n\t"
        "fmulp\n\t"
        "fldl (%%rsi)\n\t"
        "fmulp\n\t"
        "fldl -8(%%rsi)\n\t"
        "fsubrp\n\t"
        "fstpl (%%rdi)\n\t"
        :
        : "S"(v), "D"(w), "d"(b), "c"(c), "b"(&wtf)
        : "%rax"
    );
}

int main() {
    double v[32], w[32];
    double a, x, c, m;
    scanf("%lf%lf%lf%lf", &a, &x, &c, &m);
    v[0] = x;
    for (int i = 1; i < 32; i++) {
        rnd_gen(&a, &c, &m, v + i - 1, v + i);
    }
    printf("rnd array: ");
    for (int i = 0; i < 32; i++) {
        printf("%.3lf%c", v[i], " \n"[i == 31]);
    }
    w[0] = v[0];
    double b;
    scanf("%lf%lf", &b, &c);
    for (int i = 1; i < 32; i++) {
        f(&b, &c, v + i, w + i);
    }
    printf("new array: ");
    for (int i = 0; i < 32; i++) {
        printf("%.3lf%c", w[i], " \n"[i == 31]);
    }
    return 0;
}