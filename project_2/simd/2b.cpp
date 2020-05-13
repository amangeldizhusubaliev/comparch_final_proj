#include <stdio.h>

void rnd_gen(int a, int c, int m, int prev, int *cur) {
    __asm__ __volatile__ (
        "mov %3, %%eax\n\t"
        "mul %0\n\t"
        "add %1, %%eax\n\t"
        "div %2\n\t"
        "mov %%edx, (%4)\n\t"
        :
        : "d"(a), "c"(c), "b"(m), "D"(prev), "S"(cur)
        : "%eax"
    );
}

void f(double *b, double *c, int prev, double *cur) {
    __asm__ __volatile__ (
        "cvtsi2sd %%ecx, %%xmm0\n\t"
        "movsd (%%rsi), %%xmm1\n\t"
        "movsd (%%rdx), %%xmm2\n\t"
        "vfmadd132sd %%xmm1, %%xmm2, %%xmm0\n\t"
        "movsd %%xmm0, (%%rbx)\n\t"
        :
        : "S"(c), "d"(b), "b"(cur), "c"(prev)
        : "%xmm0", "%xmm1", "%xmm2", "%eax"
    );
}

int main() {
    int v[32];
    double w[32];
    int a, x, c, m;
    scanf("%d%d%d%d", &a, &x, &c, &m);
    v[0] = x;
    for (int i = 1; i < 32; i++) {
        rnd_gen(a, c, m, v[i - 1], v + i);
    }
    printf("rnd array: ");
    for (int i = 0; i < 32; i++) {
        printf("%d%c", v[i], " \n"[i == 31]);
    }
    double B, C;
    scanf("%lf%lf", &B, &C);
    printf("new array: ");
    for (int i = 0; i < 32; i++) {
        f(&B, &C, v[i], w + i);
        printf("%.3lf%c", w[i], " \n"[i == 31]);
    }
    return 0;
}