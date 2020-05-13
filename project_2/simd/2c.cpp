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


void f(double *p, int *v, double *w) {
    __asm__ __volatile__ (
        "cvtsi2sd -4(%%edi), %%xmm0\n\t"
        "mulsd -8(%%rsi), %%xmm0\n\t"
        "cvtsi2sd (%%edi), %%xmm1\n\t"
        "mulsd (%%rsi), %%xmm1\n\t"
        "addsd %%xmm1, %%xmm0\n\t"
        "cvtsi2sd 4(%%edi), %%xmm1\n\t"
        "mulsd 8(%%rsi), %%xmm1\n\t"
        "addsd %%xmm1, %%xmm0\n\t"
        "movsd %%xmm0, (%%rbx)\n\t"
        :
        : "S"(p), "D"(v), "b"(w)
        : "%xmm0", "%xmm1"
    );
}

double p[] = {0.393, 0.769, 0.189};
double q[] = {0.349, 0.686, 0.168};
double s[] = {0.272, 0.534, 0.131};

int main() {
    int v[33];
    double w[33];
    int a, x, c, m;
    scanf("%d%d%d%d", &a, &x, &c, &m);
    v[0] = x;
    for (int i = 1; i < 33; i++) {
        rnd_gen(a, c, m, v[i - 1], v + i);
    }
    printf("rnd array: ");
    for (int i = 0; i < 33; i++) {
        printf("%d%c", v[i], " \n"[i == 32]);
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