import math
import numpy as np
import random

from scipy.optimize import linprog


def generate_instance(m, n=10, maxW=100):
    instance = []
    for _ in range(m):
        s = set(random.sample(range(n), random.randint(1, n // m)))
        instance += [(s, random.randint(1, maxW))]
    return instance


def set_cover(I, k):
    m = len(I)
    universe = list(set.union(*[s for s, _ in I]))
    n = len(universe)

    c = np.array([w for _, w in I])
    A_ub = np.zeros((n, m))
    b_ub = np.zeros(n)

    for i in range(n):
        p = universe[i]
        for j in range(len(I)):
            s, _ = I[j]
            if p in s:
                A_ub[i][j] = -1
        b_ub[i] = -1

    lp_hat = linprog(c, A_ub, b_ub, bounds=(0, 1))
    x_hat = lp_hat.x

    lp_exact = linprog(c, A_ub, b_ub, bounds=(0, 1), integrality=1)
    x_exact = lp_exact.x

    attempts = math.ceil(k + math.log(n))

    I = set()
    for i in range(m):
        for _ in range(attempts):
            if random.random() <= x_hat[i]:
                I |= set([i])
                break

    I_exact = set([i for i in range(m) if x_exact[i] == 1])
    return I, I_exact


def main():
    while True:
        instance = generate_instance(150, n=1000)
        I, I_exact = set_cover(instance, 3)

        w = sum(instance[x][1] for x in I)
        w_exact = sum(instance[x][1] for x in I_exact)

        if I != I_exact and w != w_exact:
            print(
                f"SOLUZIONE ESATTA\nQuanti elementi sono stati coperti: {len(I_exact)}\nCosto degli abbonamenti comprati: {w_exact}\n"
            )
            print(
                f"SOLUZIONE APPROSSIMATA\nQuanti elementi sono stati coperti: {len(I)}\nCosto degli abbonamenti comprati: {w}"
            )
            break


if __name__ == "__main__":
    main()
