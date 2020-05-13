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

void f(int b, int c, int *cur) {
    __asm__ __volatile__ (
        "mov (%2), %%eax\n\t"
        "mul %0\n\t"
        "add %1, %%eax\n\t"
        "mov %%eax, (%2)\n\t"
        :
        : "S"(c), "D"(b), "b"(cur)
        : "%eax"
    );
}

int main() {
    int v[32];
    int a, x, c, m, b;
    scanf("%d%d%d%d", &a, &x, &c, &m);
    v[0] = x;
    for (int i = 1; i < 32; i++) {
        rnd_gen(a, c, m, v[i - 1], v + i);
    }
    printf("rnd array: ");
    for (int i = 0; i < 32; i++) {
        printf("%d%c", v[i], " \n"[i == 31]);
    }
    scanf("%d%d", &b, &c);
    printf("new array: ");
    for (int i = 0; i < 32; i++) {
        f(b, c, v + i);
        printf("%d%c", v[i], " \n"[i == 31]);
    }
    return 0;
}