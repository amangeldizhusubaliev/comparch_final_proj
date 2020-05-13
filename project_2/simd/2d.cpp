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

void f(int *v, double *w) {
    __asm__ __volatile__ (
        "cvtsi2sd -4(%%esi), %%xmm0\n\t"
        "cvtsi2sd (%%esi), %%xmm1\n\t"
        "addsd %%xmm1, %%xmm0\n\t"
        "cvtsi2sd 4(%%esi), %%xmm1\n\t"
        "addsd %%xmm1, %%xmm0\n\t"
        "mov $3, %%ecx\n\t"
        "cvtsi2sd %%ecx, %%xmm1\n\t"
        "divsd %%xmm1, %%xmm0\n\t"
        "movsd %%xmm0, (%%rdi)\n\t"
        :
        : "S"(v), "D"(w)
        : "%xmm0", "%xmm1", "%ecx"
    );
}

int main() {
    int v[34];
    double w[32];
    int a, x, c, m;
    scanf("%d%d%d%d", &a, &x, &c, &m);
    v[0] = x;
    for (int i = 1; i < 32; i++) {
        rnd_gen(a, c, m, v[i - 1], v + i);
    }
    v[32] = v[0];
    v[33] = v[1];
    printf("rnd array: ");
    for (int i = 0; i < 32; i++) {
        printf("%d%c", v[i], " \n"[i == 31]);
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